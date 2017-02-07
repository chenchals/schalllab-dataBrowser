function outfile_=xpdp2mat(pdp_file_path,pdp_file)
%function pdp2mat(pdp_file,pdp_file_path)
%CALLS: FUSEPDP.M 
%CALLER: CONVERT.M, Command line
%Example: O=xpdp2mat('c:\fechner\fecfef\','fecfef.000')
%NOTE:  EMPTY variables are filled with *'NaN'*.
%       Writes temp files for every 100(default) trials and fuses them at the end.
%       All + Eye data are offset by 1 A/D unit.
%Author:%chenchal.subraveti@vanderbilt.edu


InitialValue=NaN;%Matrix variables are initialized to Nan
AfterNTrialsSplitFile=100;%The pdp translation writes temp files for every 100 trials
                          %and Fuses them at the end of translation
global Translation
%No global declarations
TrialNo_=0; EType_=0; EData_=0; temp=0; temp_x=0; temp_y=0; temp_bits=0;
FWinNo_=0; InfosNo_=0; from_=0; to_=0;
Header_=0; Spike_=0; EyeX_=0; EyeY_=0; TrialType_=0; FixWindow_=0;
TargetWindow_=0; TrialStart_=0; EmStart_=0; Unit_=0; Eof_=0; Reward_=0;
Abort_=0; Eot_=0; FixSpotOn_=0; FixSpotOff_=0; Fixate_=0; Target_=0; 
Mask_=0; Saccade_=0; Decide_=0; Correct_=0; Wrong_=0; Infos_=0; ;
%NFixWindows_=1;%each window has 4 nos. ONLY 1 CURRENTLY
%NTargWindows_=12;%each window has 4 nos. Max allowed by PDP is 12
%NInfos_=4;%each Infos has 4 nos.
%Define EType_ codes for different events
TrialType    = 5;  % P_TRIALTYPE
Window       = 6;  % P_WINDOW
TrialStart   = 9;  % T_TRIAL 
EmStart      = 10; % T_EM
Unit         = 11; % T_UNIT
Eof          = 12; % T_EOF
Reward       = 13; % B_REWARD
Abort        = 14; % B_ABORT
Eot          = 16; % B_EOT
FixSpot      = 17; % B_OBSDOTON
Fixate       = 18; % B_OBSERVE
Target       = 19; % B_SHOWCHOICE
Saccade      = 20; % B_SACCADE
Decide       = 21; % B_DECIDE
Correct      = 22; % B_CORRECT
Wrong        = 23; % B_WRONG
Infos        = 26; % B_INFOS
%Initialize Trial variables
FWinNo_ = 0;TWinNo_ = 0; InfosNo_ = 0; from_ = 0; to_ = 0;
TrialNo_ = 0; TrialStartTime_= 0; MaskFlag_=0;MaskFile=0;FixSpotOnFlag=0;
SpikeNo_=0; UnitOffset_ = 0 ;SpikeID_=1; BeginTrialFlag=0;
EyeXIndex_ = 0; EyeYIndex_ = 0; EyeOffset_ = 0;
%Get the file to process
ifile_=pdp_file;
file_path=pdp_file_path;
if file_path(length(file_path))~='\'
   file_path=[file_path,'\'];
end
tic
len_f=length(ifile_);
ofile_=strcat(ifile_(1:min(len_f-4,6)),'_p',ifile_(len_f-3:len_f));
infile_= strcat(file_path,ifile_);
outfile_= strcat(file_path,ofile_);
fid = fopen(infile_,'r');
temp = fread(fid,512,'char');
Header_ = char(temp');
Header_=deblank(Header_);
Header_(find(Header_==0))=char(32);
%**************************************************************
%***WRITE TO MULTIPLE FILES IF TRIAL NO EXCEEDS PRESET VALUES***
maxTrialNo=AfterNTrialsSplitFile;
MultiFileFlag=0;
multifile=0;
tempfile=[file_path,'temp'];
MULTIFILE=[num2str(multifile),' separate PDP files that are merged'];
%****************************************************************
while(~feof(fid))
   temp=fread(fid,1,'ubit16');
   temp_bits=to_bin(temp);
   %First 4 bits used to decide what to read next
   %if bit 1 is 1 read READ SPIKE
   if(temp_bits(1) == '1') % BIT for SPIKE data
      if(BeginTrialFlag)
         SpikeNo_=SpikeNo_ + 1;
         Spike_(TrialNo_,SpikeNo_,SpikeID_) = (temp - 32768)+Unit_(TrialNo_,1);
      end
   elseif(temp_bits(1:4)== '0100') %BITS for X-EYE data
      if(BeginTrialFlag)
         EyeXIndex_ = EyeXIndex_ + 1; 
         temp=temp-16384;
         if(temp > 2048), temp=temp-4096; else temp=temp+1; end; 
         EyeX_(TrialNo_, EyeXIndex_) = temp;
      end   
   elseif(temp_bits(1:4)== '0101') %BITS for Y-EYE data
      if(BeginTrialFlag)
         EyeYIndex_ = EyeYIndex_ + 1; 
         temp=temp-20480;
         if(temp > 2048), temp=temp-4096; else temp=temp+1; end; 
         EyeY_(TrialNo_, EyeYIndex_) = temp;%Offset is 1a/d unit
      end   
   elseif(temp_bits(1:2)== '00')
      EType_ = to_dec(temp_bits(1:8)); %bits 1-8 for EType
      EData_ = to_dec(temp_bits(9:16)); %bits 9-16 EData
      if (EType_==9), BeginTrialFlag=1; end %DO NOT RESET THIS FLAG
      if(BeginTrialFlag)
         switch EType_
         case TrialType
            TrialType_(TrialNo_,2) = EData_;
            TrialType_(TrialNo_,3:4) = fread(fid,2,'ubit16')';
            TrialType_(TrialNo_,1) = get_time(fid,TrialStartTime_);
         case Window
            if(EData_ == 0)
               FWinNo_=FWinNo_ + 1;
               to_ = 6 * FWinNo_; %+2 for [Time][EData]
               from_ = to_ - 3;
               FixWindow_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
               FixWindow_(TrialNo_,2)=EData_;
               FixWindow_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            end
            if(EData_ ~= 0)
               TWinNo_=TWinNo_ + 1;
               to_ = 6 * TWinNo_ ;%+2for [Time][EData]
               from_ = to_ - 3;
               TargetWindow_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
               TargetWindow_(TrialNo_,2)=EData_;
               TargetWindow_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            end
         case TrialStart
            previoustrial=TrialNo_;
            TrialNo_=TrialNo_+1;
            
            %*********************************************************
            if TrialNo_>maxTrialNo
               MultiFileFlag=1;
               multifile=multifile+1;
               file=[tempfile,num2str(multifile)];
               save(file);
               disp(['Trial No ',num2str(((multifile-1)*maxTrialNo)+1),' to ',...
                     num2str(multifile*maxTrialNo),' written to temporay file ',...
                     file])
               %empty the variables 
               TrialNo_=0; EType_=0; EData_=0; temp=0; temp_x=0; temp_y=0; temp_bits=0;
               FWinNo_=0; InfosNo_=0; from_=0; to_=0;
               Header_=0; Spike_=0; EyeX_=0; EyeY_=0; TrialType_=0; FixWindow_=0;
               TargetWindow_=0; TrialStart_=0; EmStart_=0; Unit_=0; Eof_=0; Reward_=0;
               Abort_=0; Eot_=0; FixSpotOn_=0; FixSpotOff_=0; Fixate_=0; Target_=0; 
               Mask_=0; Saccade_=0; Decide_=0; Correct_=0; Wrong_=0; Infos_=0; ;
               %reset TrialNo to 1
               TrialNo_=1;
            end
            %**********************************************************
            %initialize_trial;
            INI=InitialValue;
            Spike_(TrialNo_,1)=0;
            EyeX_(TrialNo_,1)=0;
            EyeY_(TrialNo_,1)=0;
            TrialType_(TrialNo_,1:4) = ones(1,4)*INI;
            FixWindow_(TrialNo_,1:6) = ones(1,6)*INI;
            TargetWindow_(TrialNo_,1:6) = ones(1,6)*INI;
            TrialStart_(TrialNo_,1:2) = ones(1,2)*INI;
            EmStart_(TrialNo_,1:2) = ones(1,2)*INI;      
            Unit_(TrialNo_,1:2) = ones(1,2)*INI;
            Reward_(TrialNo_,1:2) = ones(1,2)*INI;
            Abort_(TrialNo_,1:2) = ones(1,2)*INI;
            Eot_(TrialNo_,1:2) = ones(1,2)*INI;
            FixSpotOn_(TrialNo_,1:2) = ones(1,2)*INI;
            FixSpotOff_(TrialNo_,1:2) = ones(1,2)*INI;
            Fixate_(TrialNo_,1:2) = ones(1,2)*INI;
            Target_(TrialNo_,1:2) = ones(1,2)*INI;
            Mask_(TrialNo_,1:2) = ones(1,2)*INI;
            Saccade_(TrialNo_,1:2) = ones(1,2)*INI;
            Decide_(TrialNo_,1:2) = ones(1,2)*INI;
            Correct_(TrialNo_,1:2) = ones(1,2)*INI;
            Wrong_(TrialNo_,1:2) = ones(1,2)*INI;
            Infos_(TrialNo_,1:16) = ones(1,16)*INI;      
            disp(strcat('PDP File ::',pdp_file,'Trial No_ = ',...
               num2str(TrialNo_+(multifile*maxTrialNo))));
            TrialStartTime_ = fread(fid,1,'ubit32');
            TrialStart_(TrialNo_,1) = TrialStartTime_;
            TrialStart_(TrialNo_,2) = EData_;
            
         case EmStart
            EmStart_(TrialNo_,1) = get_time(fid, TrialStartTime_);
            EmStart_(TrialNo_,2) = EData_;
         case Unit
            Unit_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Unit_(TrialNo_,2) = EData_;
         case Eof
            break;
         case Reward
            Reward_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Reward_(TrialNo_,2) = EData_;
         case Abort
            Abort_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Abort_(TrialNo_,2) = EData_;
         case Eot
            Eot_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Eot_(TrialNo_,2) = EData_;
            %reset Trial Variables
            FWinNo_ = 0; TWinNo_ = 0; InfosNo_= 0;
            TrialStartTime_ = 0;
            SpikeNo_=0;MaskFlag_=0;FixSpotOnFlag=0;
            EyeXIndex_= 0; EyeYIndex_= 0;
            %BeginTrialFlag=0;
         case FixSpot
            if(EData_==1)
               if(~FixSpotOnFlag)
                  FixSpotOn_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                  FixSpotOn_(TrialNo_,2) = EData_;
                  FixSpotOnFlag=1;
               end
            else
               FixSpotOff_(TrialNo_,1) = get_time(fid,TrialStartTime_);
               FixSpotOff_(TrialNo_,2) = EData_;
            end
         case Fixate
            Fixate_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Fixate_(TrialNo_,2) = EData_;
         case Target
            if(MaskFlag_==0)
               Target_(TrialNo_,1) = get_time(fid,TrialStartTime_);
               Target_(TrialNo_,2) = EData_;
               MaskFlag_=1;
            else
               Mask_(TrialNo_,1) = get_time(fid,TrialStartTime_);
               Mask_(TrialNo_,2) = EData_;
               MaskFile=1;
            end
         case Saccade
            Saccade_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Saccade_(TrialNo_,2) = EData_;
         case Decide
            Decide_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Decide_(TrialNo_,2) = EData_;
            %Check if Decide occurs more than once in a trial
            if(previoustrial==TrialNo_)
               disp(strcat('TrialNo :::',num2str(TrialNo_),':::Decide:::',num2str(E_Data_)))
            end
         case Correct
            Correct_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Correct_(TrialNo_,2) = EData_;
         case Wrong
            Wrong_(TrialNo_,1) = get_time(fid,TrialStartTime_);
            Wrong_(TrialNo_,2) = EData_;
         case Infos
            InfosNo_=InfosNo_+1;
            to_ = 4*InfosNo_;
            from_ = to_-3;
            Infos_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
            notused_ = get_time(fid,TrialStartTime_);
         otherwise
            if(EType_ > 26 | EType_ < 0)
               disp ('ERROR :  Unknown  EType Code');
               
               pause
            end
         end  %end for SWITCH
      end %BeginTrialflag      
      
   else  %(for temp_bits)
   end
end %end WHILE
fclose(fid);

if(~MultiFileFlag)
   %Special : MASK (if Target occurs a second time)
   if(~MaskFile)
      %Variables Saved in MATLAB format NO MASK variable
      save (outfile_,'Abort_','Correct_','Decide_','EmStart_','Eot_','EyeX_','EyeY_',...
         'FixSpotOff_','FixSpotOn_','FixWindow_','Fixate_','Header_','Infos_','Reward_','Saccade_',...
         'Spike_','TargetWindow_','Target_','TrialStart_','TrialType_','Unit_', 'Wrong_','Translation');
      %Mask_(dum,:)=Mask_(1,:);**what is dum?? 
   else
      %Mask_(dum,:)=Mask_(1,:);**what is dum?? 
      Mask_=Mask_(1:TrialNo_,:);
      %Variables Saved in MATLAB format  MASK varible saved
      save (outfile_,'Abort_','Correct_','Decide_','EmStart_','Eot_','EyeX_','EyeY_',...
         'FixSpotOff_','FixSpotOn_','FixWindow_','Fixate_','Header_','Infos_','Mask_','Reward_','Saccade_',...
         'Spike_','TargetWindow_','Target_','TrialStart_','TrialType_','Unit_', 'Wrong_','Translation');
      disp(['Wrote PDP Translated File ',outfile]) 
      disp(['Total Trials ',num2str(TrialNo_)])
      
   end
else
   multifile=multifile+1;
   file=[tempfile,num2str(multifile)];
   save(file);
   disp(['Trial No ',num2str(((multifile-1)*maxTrialNo)+1),' to ',...
         num2str(multifile*maxTrialNo),' written to temporay file ',...
         file])
   %Now FUSE (Merge is for merging MNAP and PDP files)
   TrialNo_=fusepdp(outfile_,tempfile,multifile)
   disp(['Total Trials ',num2str(TrialNo_)])
   disp('    ')
   file=[tempfile,'*','.mat'];
   delete(file)
end
toc;
%************************************************************
%subfunction visible only in this file
%decimal to binary (outputs are 16 bits)
function bin_ = to_bin(dec_)
[f, e] = log2(dec_);
bin_=setstr(rem(floor(dec_*pow2(-15:0)),2) + '0');
%************************************************************
%binary to decimal
function dec_ = to_dec(bin_)
[m, n] = size(bin_);
v = bin_ - '0';
dec_= sum(v.*pow2(n-1:-1:0));
%************************************************************
function times_ = get_time(fid, TrialStartTime_)
times_ = fread(fid,1,'ubit32') - TrialStartTime_;
%**************************************************************
