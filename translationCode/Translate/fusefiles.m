function [TotalTrials]=fusefiles
% fuses all matlab files that are in the specified path

varlistP={'Abort_'; 'Correct_'; 'Decide_'; 'EmStart_'; 'Eot_'; 'EyeX_';
   'EyeY_'; 'FixSpotOff_'; 'FixSpotOn_'; 'FixWindow_'; 'Fixate_';
   'Infos_'; 'Reward_'; 'Saccade_'; 'Spike_'; 'TargetWindow_'; 'Target_';
   'TrialStart_'; 'TrialType_'; 'Unit_'; 'Wrong_'; 'StopSignal_';'ExtraJuice_';'Zap_'};
varlistM={'DSP01a'; 'DSP01a'; 'DSP01b'; 'DSP01c'; 'DSP01d'; 'P_TrialStart'; 'P_Eot';
   'P_FixSpotOn'; 'P_FixSpotOff'; 'P_Correct'; 'P_TargetOn'; 'M_TrialStart'; 'M_Eot';
   'M_FixSpotOn'; 'M_FixSpotOff'; 'M_Correct'; 'M_TargetOn'};

list_p=[]; list_m=[]; list = []; LIST = [];
FUSEpath = 'c:\data\fuse';
list_p=dir([FUSEpath,'\*_p.*']);
list_m=dir([FUSEpath,'\*_m.*']);
list = [list_p; list_m];

if ~isempty(list_m)
   varlist1 = [varlistP; varlistM];
else
   varlist1 = varlistP;
end

for i=1:length(list)
   ifile_=deblank(list(i).name);
   LIST = [LIST; ifile_];
end
if ~isempty(LIST)
   LIST = sortrows(LIST);
   
   varlist=char(varlist1);
   MULTIFILE=[num2str(size(LIST,1)),' separate files that are merged'];
   ifile_ = LIST(1,:); ofile_=ifile_; ofile_(8)='f';
   ifile_ = [FUSEpath,'\',ifile_];
   OFile_ = [FUSEpath,'\',ofile_];
   save(OFile_,'MULTIFILE');%This creates the file for subsequent append
   varname=[];
   
   load(ifile_,'Header_','-mat');
   save(OFile_,'Header_','-append');
   NFiles = size(LIST,1);
   
   %merging
   for nvars=1:size(varlist,1)
      varname=char(varlist1(nvars));
      DoesNotExist = 0;
      for nfiles=1:NFiles
         ifile_=[FUSEpath,'\',LIST(nfiles,:)];
         load(ifile_,varname,'-mat');
         if exist(varname)
            eval(['tempvar',num2str(nfiles),'=',varname,';'])
            varsize(nfiles,1:2)=size(eval(['tempvar',num2str(nfiles)]));
         else
            DoesNotExist = 1;
            break
         end
      end
      if DoesNotExist == 0
         disp(['Loaded ',varname,' from all ',num2str(NFiles),' files.'])
         maxcols=max(varsize(:,2));
         totaltrials=sum(varsize(:,1));
         start_end=cumsum(varsize(:,1));
         for nfiles=1: NFiles
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
         if isequal(varname,'Zap_')
            if ~isempty(nonzeros(~isnan(Zap_)))
               save(OFile_,varname,'-append')
            else
               clear Zap_
               disp('Zap_ was deleted because it is EMPTY.')
            end     
         else
            save(OFile_,varname,'-append')
         end
         TotalTrials=start_end(nfiles);
      end
      clear tempvar* varname varsize start_end V T 
   end 
end
