function [TotalTrials]=fusepdp(OFile_,TFile,NFiles)
%function [TotalTrials]=fusepdp(OFile_,TFile,NFiles)
%CALLS: None
%CALLER: XPDP2MAT.M
%Example: Not meant to be called from command line
%Author:chenchal.subraveti@vanderbilt.edu

varlist1={'Abort_'; 'Correct_'; 'Decide_'; 'EmStart_'; 'Eot_'; 'EyeX_';
    'EyeY_'; 'FixSpotOff_'; 'FixSpotOn_'; 'FixWindow_'; 'Fixate_';
    'Infos_'; 'Reward_'; 'Saccade_'; 'Spike_'; 'TargetWindow_'; 'Target_';
   'TrialStart_'; 'TrialType_'; 'Unit_'; 'Wrong_'};
varlist=char(varlist1);
MULTIFILE=[num2str(NFiles),' separate PDP files that are merged'];
save(OFile_,'MULTIFILE');%This creates the file for subsequent append
varname=[];
tempfile=TFile;
file=[tempfile,num2str(1)];
load(file,'Header_','Translation');
save(OFile_,'Header_','Translation','-append');
%merging
for nvars=1:size(varlist,1)
   varname=char(varlist1(nvars));   
   for nfiles=1:NFiles
      file=[tempfile,num2str(nfiles)];
      %load(file,'varlist1(nvars)');
      load(file,varname);
      eval(['tempvar',num2str(nfiles),'=',varname,';'])
      varsize(nfiles,1:2)=size(eval(['tempvar',num2str(nfiles)]));
   end
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
   save(OFile_,varname,'-append')
   TotalTrials=start_end(nfiles);
   clear tempvar* varname varsize start_end V T
end


