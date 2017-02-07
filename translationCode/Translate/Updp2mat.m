%***NOTE***EMPTY variables are filled with *'NaN'*
%all + Eye data are offset by 1 A/D unit  
%Author:
%chenchal.subraveti@vanderbilt.edu
%11-19-98
%changes by
%veit.stuphorn@vanderbilt.edu
%includes StopSignal for use with countermanding task
%and Zap (= begin of electrical stimulation)
%function pdp2mat(pdp_file,pdp_file_path) and
%function [TotalTrials]=fusepdp(OFile_,TFile,NFiles,varlist1)
%combined, therefore new name U(niversal)pdp2mat
%
%last changes: 02-26-2001

function [outfile_, Abort_, Correct_, Decide_, EmStart_, Eot_, EyeX_, ...
            EyeY_, FixSpotOff_, FixSpotOn_, FixWindow_, Fixate_, ...
            Infos_, Reward_, Saccade_, Spike_, TargetWindow_, Target_, ...
            TrialStart_, TrialType_, Unit_, Wrong_, StopSignal_, ExtraJuice_, ...
            Mask_, Zap_]=Updp2mat(pdp_file_path,pdp_file)

% function [outfile_]=Updp2mat(pdp_file_path,pdp_file)

%Call pdpvars.m for setting the global variables
global Translation
%No global declarations
TrialNo_=0; EType_=0; EData_=0; temp=0; temp_x=0; temp_y=0; temp_bits=0;
FWinNo_=0; InfosNo_=0; from_=0; to_=0;
Header_=0; Spike_=0; EyeX_=0; EyeY_=0; TrialType_=0; FixWindow_=0;
TargetWindow_=0; TrialStart_=0; EmStart_=0; Unit_=0; Eof_=0; Reward_=0;
Abort_=0; Eot_=0; FixSpotOn_=0; FixSpotOff_=0; Fixate_=0; Target_=0; 
Mask_=0; Saccade_=0; Decide_=0; Correct_=0; Zap_=0; StopSignal_=0;
Wrong_=0; Infos_=0; ExtraJuice_ =0;
%NFixWindows_=1;%each window has 4 nos. ONLY 1 CURRENTLY
%NTargWindows_=12;%each window has 4 nos. Max allowed by PDP is 12
%NInfos_=5;%each Infos has 5 nos.
%Define EType_ codes for different events
TrialType     = 5;    % P_TRIALTYPE
Window      = 6;  % P_WINDOW
TrialStart   = 9;  % T_TRIAL 
EmStart      = 10; % T_EM
Unit         = 11; % T_UNIT
Eof          = 12; % T_EOF
Reward       = 13; % B_REWARD
Abort        = 14; % B_ABORT
Eot          = 16; % B_EOT
FixSpot      = 17; % B_OBSDOTON
Fixate        = 18; % B_OBSERVE
Target        = 19; % B_SHOWCHOICE
Saccade      = 20; % B_SACCADE
Decide       = 21; % B_DECIDE
Correct      = 22; % B_CORRECT
Wrong        = 23; % B_WRONG
Infos        = 26; % B_INFOS

Zap			 = 24; % B_ZAP
% not automatically saved
ZapFileFlag = 0;

%Initialize Trial variables
FWinNo_ = 0;TWinNo_ = 0; InfosNo_ = 0; from_ = 0; to_ = 0;
TrialNo_ = 0; TrialStartTime_= 0; MaskFlag_=0;MaskFile=0;FixSpotOnFlag=0;
FixSpotOffFlag=0; SpikeNo_=0; UnitOffset_ = 0 ;SpikeID_=1; BeginTrialFlag=0;
EyeXIndex_ = 0; EyeYIndex_ = 0; EyeOffset_ = 0;
%Get the file to process
ifile_=pdp_file;
file_path=pdp_file_path;
tic
len_f=length(ifile_);
ofile_=strcat(ifile_(1:min(len_f-4,6)),'_p',ifile_(len_f-3:len_f));
infile_= strcat(file_path,ifile_);
outfile_= strcat(file_path,ofile_);
fid = fopen(infile_,'r');
%Get size of file
status = fseek(fid,0,'eof');
filesize = ftell(fid);
status = fseek(fid,0,-1);
%Begin to read
temp = fread(fid,512,'char');
Header_ = char(temp');
Header_=deblank(Header_);
Header_(find(Header_==0))=char(32);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                         OPEN FILE AND WRITE TO MATRIZES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (isequal(deblank(Header_(5:14)),'gostop'))|(isequal(deblank(Header_(5:14)),'search'))|...
        (isequal(deblank(Header_(5:7)),'map'))
    
    % 'gostop' marks COUNTERMANDING trials
    % 'search' marks some of the MEMORY GUIDED SACCADE trials in Andy
    % 'map" marks VISUALLY AND MEMORY GUIDED SACCADE trials recorded 
    %          during mapping of the RF
    GOSTOPflag = 0; SEARCHflag = 0; MAPflag = 0;
    if (isequal(deblank(Header_(5:14)),'gostop'))
        GOSTOPflag = 1;
    elseif (isequal(deblank(Header_(5:14)),'search'))
        SEARCHflag = 1;
    elseif (isequal(deblank(Header_(5:7)),'map'))
        MAPflag = 1;
    end
    
    %**************************************************************
    %***WRITE TO MULTIPLE FILES IF TRIAL NO EXCEEDS PRESET VALUES***
    maxTrialNo=100;
    MultiFileFlag=0;
    multifile=0;
    tempfile=[file_path,'temp'];
    MULTIFILE=[num2str(multifile),' separate PDP files that are merged'];
    %****************************************************************
    while(~feof(fid))
        position = ftell(fid);
        if (filesize-position >= 2)
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
                        if (MAPflag == 1)
                            FWinNo_=FWinNo_ + 1;
                            if FWinNo_==1
                                from_ = 3; to_ = 6;
                                FixWindow_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
                                FixWindow_(TrialNo_,2)=EData_;
                                FixWindow_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            elseif FWinNo_==2
                                from_ = 3; to_ = 6;
                                TargetWindow_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
                                TargetWindow_(TrialNo_,2)=EData_;
                                TargetWindow_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            end
                        elseif (GOSTOPflag == 1)
                            if(EData_ == 0)
                                from_ = 3; to_ = 6;
                                FixWindow_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
                                FixWindow_(TrialNo_,2)=EData_;
                                FixWindow_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            end
                            if(EData_ ~= 0)
                                from_ = 3; to_ = 6;
                                TargetWindow_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
                                TargetWindow_(TrialNo_,2)=EData_;
                                TargetWindow_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            end     
                        else
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
                        end
                    case TrialStart
                        previoustrial=TrialNo_;
                        TrialNo_=TrialNo_+1;
                        Reward_Counter=0;
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
                            Mask_=0; Saccade_=0; Decide_=0; Correct_=0; Wrong_=0; Zap_=0; StopSignal_=0;
                            Infos_=0; FixSpotOnFlag=0; FixSpotOffFlag=0; ExtraJuice_=0;
                            %reset TrialNo to 1
                            TrialNo_=1;
                        end
                        %**********************************************************
                        %initialize_trial;
                        INI=NaN;
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
                        ExtraJuice_(TrialNo_,1:2) = [0 0];
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
                        Zap_(TrialNo_,1:4) = ones(1,4)*INI;
                        StopSignal_(TrialNo_,1:2) = ones(1,2)*INI;
                        Infos_(TrialNo_,1:20) = ones(1,20)*INI;      
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
                        % step out of Pdp file READING
                        break;
                    case Reward
                        RBuffer(1,Reward_Counter + 1) = get_time(fid,TrialStartTime_);
                        RBuffer(1,Reward_Counter + 2) = EData_;
                        Reward_Counter = Reward_Counter + 2;
                    case Abort
                        Abort_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                        Abort_(TrialNo_,2) = EData_;
                    case Eot
                        %Check if Eot occurs more than once in a trial
                        %was necessary because of strange case of two Eot-Events
                        %in some files
                        if(isnan(Eot_(TrialNo_,1)))
                            Eot_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            Eot_(TrialNo_,2) = EData_;
                        else
                            disp('EOT event occured two times in a trial')
                            dummy = get_time(fid,TrialStartTime_);
                            dummy = EData_;
                        end
                        
                        %sort RBUFFER into Reward_ & ExtraJuice_ (SEE Reward_)
                        TempRew = []; TempExRew = [];
                        if (Reward_Counter > 0)
                            if (Correct_(TrialNo_,2) == 1)
                                [TempRew,TempExRew] = getTrueAndExtraReward(RBuffer,Correct_(TrialNo_,1));
                                Reward_(TrialNo_,1:length(TempRew)) = TempRew;
                                ExtraJuice_(TrialNo_,1:length(TempExRew)) = TempExRew;
                            else
                                ExtraJuice_(TrialNo_,1:length(RBuffer))= RBuffer; 
                            end
                        end
                        RBuffer = [];
                        Reward_Counter=0;
                        % is been set twice, was necessary because of the occurence of two "Eot"-Events VS
                        
                        %reset Trial Variables
                        FWinNo_ = 0; TWinNo_ = 0; InfosNo_= 0;
                        TrialStartTime_ = 0; FixSpotOffFlag=0;
                        SpikeNo_=0;MaskFlag_=0;FixSpotOnFlag=0;
                        EyeXIndex_= 0; EyeYIndex_= 0;
                        %BeginTrialFlag=0;
                    case FixSpot
                        if(EData_==1)
                            if(~FixSpotOnFlag)
                                FixSpotOn_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                                FixSpotOn_(TrialNo_,2) = EData_;
                                FixSpotOnFlag=1;
                            elseif(FixSpotOffFlag)
                                StopSignal_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                                StopSignal_(TrialNo_,2) = EData_;
                            end
                        else            
                            FixSpotOff_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            FixSpotOff_(TrialNo_,2) = EData_;
                            FixSpotOffFlag=1;
                        end
                    case Fixate
                        if isnan(Fixate_(TrialNo_,1))
                            Fixate_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            Fixate_(TrialNo_,2) = EData_;
                        end
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
                    case Zap
                        if(EData_==1)  %Begin of Electrical Stimulation
                            Zap_(TrialNo_,1) = get_time(fid,TrialStartTime_);
                            Zap_(TrialNo_,2) = EData_;
                            ZapFileFlag = 1;
                        elseif(EData_==0) %End of Electrical Stimulation
                            Zap_(TrialNo_,3) = get_time(fid,TrialStartTime_);
                            Zap_(TrialNo_,4) = EData_;
                            ZapFileFlag = 1;
                        end
                    case Infos
                        InfosNo_=InfosNo_+1;
                        to_ = 4*InfosNo_;
                        from_ = to_-3;
                        Infos_(TrialNo_,from_:to_) = fread(fid,4,'bit16')';
                        notused_ = get_time(fid,TrialStartTime_);
                    otherwise
                        if(EType_ > 26 | EType_ < 0)
                            disp (['ERROR :  Unknown  EType Code. EType = ',int2str(EType_)]);
                            %pause
                        else
                            disp(['Undefined EType Code. EType = ',int2str(EType_)]);
                        end
                    end  %end for SWITCH
                    
                end %BeginTrialflag      
                
            else  %(for temp_bits)
            end
        else	%(filesize-position<2)
            disp('')
            disp(['Premature EOF ',int2str(filesize-position),' bytes before the end of file'])
            if (TrialNo_ > 0)&(isnan(Eot_(TrialNo_,1)))
                % Remove Information, that can not be analyzed
                Spike_(TrialNo_,:) = [];
                EyeX_(TrialNo_,:) = [];
                EyeY_(TrialNo_,:) = [];
                TrialType_(TrialNo_,:) = [];
                FixWindow_(TrialNo_,:) = [];
                TargetWindow_(TrialNo_,:) = [];
                TrialStart_(TrialNo_,:) = [];
                EmStart_(TrialNo_,:) = [];      
                Unit_(TrialNo_,:) = [];
                Reward_(TrialNo_,:) = [];
                ExtraJuice_(TrialNo_,:) = [];
                Abort_(TrialNo_,:) = [];
                Eot_(TrialNo_,:) = [];
                FixSpotOn_(TrialNo_,:) = [];
                FixSpotOff_(TrialNo_,:) = [];
                Fixate_(TrialNo_,:) = [];
                Target_(TrialNo_,:) = [];
                Mask_(TrialNo_,:) = [];
                Saccade_(TrialNo_,:) = [];
                Decide_(TrialNo_,:) = [];
                Correct_(TrialNo_,:) = [];
                Wrong_(TrialNo_,:) = [];
                Zap_(TrialNo_,:) = [];
                StopSignal_(TrialNo_,:) = [];
                Infos_(TrialNo_,:) = [];
                disp('')
                disp('Last Trial has been erased.');
            end
            break 
        end
    end %end WHILE
    fclose(fid);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %                   FUSE AND/OR SAVE
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(~MultiFileFlag)      %    just SAVE:
        
        %Variables Saved in MATLAB format  standard varibles saved
        save (outfile_,'Abort_','Correct_','Decide_','EmStart_','Eot_','EyeX_',...
            'EyeY_','FixSpotOff_','FixSpotOn_','FixWindow_','Fixate_',...
            'Header_','Infos_','Reward_','Saccade_','Spike_','TargetWindow_',...
            'Target_','TrialStart_','TrialType_','Unit_', 'StopSignal_','Wrong_',...
            'Translation','ExtraJuice_');
        % 1) check if there is electrical stimulation     
        if ~isempty(nonzeros(~isnan(Zap_)))
            save(outfile_,'Zap_','-append')
        else
            clear Zap_
        end
        % 2) check if there is masking stimulus
        if ~isempty(nonzeros(~isnan(Mask_)))
            save(outfile_,'Mask_','-append')
        else
            clear Map_
        end
        disp(['Wrote PDP Translated File ',outfile_]) 
        disp(['Total Trials ',num2str(TrialNo_)])
        
    else % first FUSE, then SAVE:
        
        % 1. save last Temp file
        multifile=multifile+1;
        file=[tempfile,num2str(multifile)];
        save(file);
        disp(['Trial No ',num2str(((multifile-1)*maxTrialNo)+1),' to ',...
                num2str(multifile*maxTrialNo),' written to temporay file ',...
                file])
        
        % 2. FUSE
        varlist1={'Abort_'; 'Correct_'; 'Decide_'; 'EmStart_'; 'Eot_'; 'EyeX_';
            'EyeY_'; 'FixSpotOff_'; 'FixSpotOn_'; 'FixWindow_'; 'Fixate_';
            'Infos_'; 'Reward_'; 'Saccade_'; 'Spike_'; 'TargetWindow_'; 'Target_';
            'TrialStart_'; 'TrialType_'; 'Unit_'; 'Wrong_'; 'StopSignal_';'ExtraJuice_';
            'Mask_';'Zap_'};
        varlist=char(varlist1);
        MULTIFILE=[num2str(multifile),' separate PDP files that are merged'];
        save(outfile_,'MULTIFILE'); % This creates the file for subsequent append
        varname=[];
        tempfile=tempfile;
        file=[tempfile,num2str(1)];
        load(file,'Header_','Translation');
        save(outfile_,'Header_','Translation','-append');
        %merging
        for nvars=1:size(varlist,1)
            varname=char(varlist1(nvars));   
            for nfiles=1:multifile
                file=[tempfile,num2str(nfiles)];
                %load(file,'varlist1(nvars)');
                load(file,varname);
                eval(['tempvar',num2str(nfiles),'=',varname,';'])
                varsize(nfiles,1:2)=size(eval(['tempvar',num2str(nfiles)]));
            end
            disp(['Loaded ',varname,' from all ',num2str(multifile),' files.'])
            maxcols=max(varsize(:,2));
            totaltrials=sum(varsize(:,1));
            start_end=cumsum(varsize(:,1));
            for nfiles=1: multifile
                if nfiles==1
                    rostart_=1;
                else   
                    rostart_=start_end(nfiles-1)+1;
                end
                roend_=start_end(nfiles);
                V=[varname,'(',num2str(rostart_),':',num2str(roend_),',1:',...
                        num2str(varsize(nfiles,2)),')'];
                T=['tempvar',num2str(nfiles)];
                eval([V,'=',T,';']);
            end
            disp(['Fused -----',varname])
            if isequal(varname,'ExtraJuice_')
                ExtraJuice_(find(ExtraJuice_ == 0)) = NaN;
            end
            
            % 3. SAVE variables, but :
            % a) check if there is electrical stimulation
            if isequal(varname,'Zap_')
                if ~isempty(nonzeros(~isnan(Zap_)))
                    save(outfile_,varname,'-append')
                else
                    clear Zap_
                end
            % b) check if there is masking stimulus
            elseif isequal(varname,'Mask_')
                if ~isempty(nonzeros(~isnan(Mask_)))
                    save(outfile_,varname,'-append')
                else
                    clear Map_
                end

            else   
                save(outfile_,varname,'-append')
            end
            TrialNo_=start_end(nfiles);
            clear tempvar* varname varsize start_end V T
        end

        disp(['Total Trials ',num2str(TrialNo_)])
        disp('    ')
        file=[tempfile,'*','.mat'];
        delete(file)
    end
    toc;
end

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
%************************************************************
function [TRew,TExRew] = getTrueAndExtraReward(RB,C)
index = find(RB == C);
if (length(RB) == 2)
    TRew=RB;
    TExRew=[0 0];
else
    if isempty(index)
        error(['Cpdp2mat subfunction getTrueAndExtraReward(RB,C) has an empty index for RB==C comparison!',...
                'Check logic before calling'])
    else
        TRew = RB(index:index+1);
        if index == 1
            TExRew = RB(index+2:end);
        elseif index == length(RB)-1
            TExRew = RB(1:index-1);
        else 
            TExRew = [RB(1:index-1) RB(index+2:end)];
        end
    end
end
TRew=TRew(:)'; 
TExRew = TExRew(:)';
%************************************************************
