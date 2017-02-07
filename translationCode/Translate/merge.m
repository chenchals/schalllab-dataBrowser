function merge(pdp_file,mnap_file)
%merge(pdp_file,mnap_file)
%merger translated PDP and MNAP files
%This file cannot be in 'Private' sub-dir since it calls functions from display8 
%Caution : checks only Eot_ and M_Eot variables for no. of trials to match
%Author:chenchal.subraveti@vanderbilt.edu

% changes done March-29-2001 by veit.stuphorn@vanderbilt:
% extend treatment of different trial size case

global Translation

% 1. GET DATA AND NAME OF NEW MERGED FILE
load(pdp_file,'-mat');
load(mnap_file,'-mat');
[File_path,File_name,File_ext]=fileparts(pdp_file);
File_name(length(File_name))='m';
OutFile_=fullfile(File_path,[File_name,File_ext]);


% 2. STORE PDP EVENTS THAT ARE RECORDED TWICE
P_TrialStart=TrialStart_;
P_Eot=Eot_;
P_FixSpotOn=FixSpotOn_;
P_FixSpotOff=FixSpotOff_;
P_Correct=Correct_;
P_TargetOn=Target_;
if(exist('Mask_','var'))
    P_Mask=Mask_;
end


% 3. Insert NaNs at appropriate locations in MNAP
M_TrialStart(find(M_TrialStart==0))=nan;%Should not happen
M_Eot(find(M_Eot==0))=nan;%Should not happen
M_FixspotOn(find(M_FixSpotOn==0))=nan;
M_FixspotOff(find(M_FixSpotOff==0))=nan;
M_Success(find(M_Success==0))=nan;
M_TargetOn(find(M_TargetOn==0))=nan;
if(exist('Mask_','var'))
    M_TargetOff(find(Mask_(:,1)==0))=nan;
end


% IF YOU WANT TO USE MNAP DATA:
%TrialStart_(:,1)=M_TrialStart;
%Eot_(:,1)=M_Eot;
%FixSpotOn_(:,1)=M_FixSpotOn;
%FixSpotOff_(:,1)=M_FixSpotOff;
%Correct_(:,1)=M_Success;
%Target_(:,1)=M_TargetOn;
% if(exist('Mask_','var'))
%     TargetOff_=Mask_;
%     TargetOff_(:,1)=M_TargetOff;
% end

VARS2CUT = {'Abort_';'Correct_';'Decide_';'EmStart_';'Eot_';
        'ExtraJuice_';'EyeX_';'EyeY_';'FixSpotOff_';'FixSpotOn_';
        'FixWindow_';'Fixate_';'Infos_';'M_Eot';'M_FixSpotOff';
        'M_FixSpotOn';'M_Success';'M_TargetOff';'M_TargetOn';
        'M_TrialStart';'P_Correct';'P_Eot';'P_FixSpotOff';
        'P_FixSpotOn';'P_TargetOn';'P_TrialStart';'Reward_';
        'Saccade_';'Spike_';'StopSignal_';'TargetWindow_';'Target_';
        'TrialStart_';'TrialType_';'Unit_';'Wrong_'};
for CurrSpk=1:size(M_SpikeID,1)
    VARS2CUT{length(VARS2CUT)+1} = M_SpikeID(CurrSpk,:);
end

% 4. TEST IF THE PDP- AND THE MNAP-FILE ARE OF SAME SIZE
if(size(Eot_,1)~=size(M_Eot,1))
    % 4.1. IF NOT...
    disp('Mismatch in the Number of trials')
    disp(['No. of trials in PDP file ',pdp_file,'  =  ',num2str(size(Eot_,1))])
    disp(['No. of trials in MNAP file ',mnap_file,'  =  ',num2str(size(M_Eot,1))])
    
    % 4.2. FIND LONGER FILE &  FIND LIST OF COMMON TRIALS 
    %     (BEGINNING AT THE FIRST TRIAL TILL THE LAST COMMON TRIAL)
    %      AND CUT
    if (size(Eot_,1) > size(M_Eot,1))
        % PDP longer then MNAP
        NonMatchingTrials = find(abs(Eot_(1:size(M_Eot,1),1)-M_Eot(1:size(M_Eot,1),1)) > 10 );
        Additional = [size(M_Eot,1)+1:1:size(Eot_,1)]';
        NonMatchingTrials = [NonMatchingTrials; Additional];
        disp(['No. of non-matching Trials: ',num2str(length(NonMatchingTrials))])
        for ii=1:length(VARS2CUT)
            eval(['CurVar = ',VARS2CUT{ii},';']); 
            cNMT = find(NonMatchingTrials<=size(CurVar,1));
            CurVar(NonMatchingTrials(cNMT),:) = [];
            eval([VARS2CUT{ii},' = CurVar;']);
            disp(['Cut Trials that do not match between PDP and MNAP file in ',VARS2CUT{ii},'.'])
        end
        
    elseif (size(M_Eot,1) > size(Eot_,1))
        % MNAP longer then PDP
        NonMatchingTrials = find(abs(Eot_(1:size(Eot_,1),1)-M_Eot(1:size(Eot_,1),1)) > 10 );
        Additional = [size(Eot_,1)+1:1:size(M_Eot,1)]';
        NonMatchingTrials = [NonMatchingTrials; Additional];
        disp(['No. of non-matching Trials: ',num2str(length(NonMatchingTrials))])
        for ii=1:length(VARS2CUT)
            eval(['CurVar = ',VARS2CUT{ii},';']); 
            cNMT = find(NonMatchingTrials<=size(CurVar,1));
            CurVar(NonMatchingTrials(cNMT),:) = [];
            eval([VARS2CUT{ii},' = CurVar;']);
            disp(['Cut Trials that do not match between PDP and MNAP file in ',VARS2CUT{ii},'.'])
        end
    end
    if isempty(NonMatchingTrials)
        Longer = 'NONE';
        disp('There is NO match at all between the two files!')
        disp('Write code for systematic shifting of trial# to find MATCH.')
        break
    end
end


% 5. MERGE VARIABLES
save(OutFile_,'M_SpikeID','Translation','Header_');
for ii=1:length(VARS2CUT)
    save(OutFile_,VARS2CUT{ii},'-append');
end
disp('  ') 
disp(['Merged PDP file ',pdp_file,' with MNAP file ',mnap_file])
disp(['and saved to ',OutFile_,'.'])
clear variables
clear global
disp('Cleared global and local variables.')
