function Cutfile(file_path,ifile_,PrintFlag)
% fuses all matlab files that are in the specified path

varlistP={'Abort_'; 'Correct_'; 'Decide_'; 'EmStart_'; 'Eot_'; 'EyeX_';
   'EyeY_'; 'FixSpotOff_'; 'FixSpotOn_'; 'FixWindow_'; 'Fixate_';
   'Infos_'; 'Reward_'; 'Saccade_'; 'Spike_'; 'TargetWindow_'; 'Target_';
   'TrialStart_'; 'TrialType_'; 'Unit_'; 'Wrong_'; 'StopSignal_';'ExtraJuice_';'Zap_'};
varlistM={'DSP01a'; 'DSP01a'; 'DSP01b'; 'DSP01c'; 'DSP01d'; 'P_TrialStart'; 'P_Eot';
   'P_FixSpotOn'; 'P_FixSpotOff'; 'P_Correct'; 'P_TargetOn'; 'M_TrialStart'; 'M_Eot';
   'M_FixSpotOn'; 'M_FixSpotOff'; 'M_Correct'; 'M_TargetOn'};

% if been used outside the BATCH mode
if nargin<2
    [ifile_,file_path] = uigetfile('c:\*.*','Choose MATLAB File to Process');
    if isequal(ifile_,0)|isequal(file_path,0)
        disp('File not found')
    else
        disp(['File ', file_path, ifile_, ' found'])
    end
end

if ~isempty(ifile_(8)=='m')
    varlist1 = [varlistP; varlistM];
else
    varlist1 = varlistP;
end
varlist=char(varlist1); varname=[];

ofile_=ifile_; ofile_(8)='c'; %creates Output file
INPUTpath = strcat(file_path,ifile_);
OUTPUTpath = strcat(file_path,ofile_);

format('rational')
load(INPUTpath,'Header_','-mat');
save(OUTPUTpath ,'Header_');
load(INPUTpath,'TrialStart_','-mat');
disp(['The File contains ',num2str(size(TrialStart_),1),' trials.'])
disp('Which trials do you want to cut?')
Startcut = input('Start of cut: ');
Endcut = input('End of cut [Press Enter if END]: ');
format('short')
if isempty(Endcut); Endcut = 'end'; end

%Cuting
for nvars=1:size(varlist,1)
    
    % load Varable
    varname=char(varlist1(nvars));
    load(INPUTpath,varname,'-mat');
    
    if exist(varname)
        if ~isequal(Endcut,'end')
            eval([varname,'(Startcut:Endcut,:) = [];'])
        else
            eval([varname,'(Startcut:end,:) = [];'])
        end
        save(OUTPUTpath,varname,'-append')
    else
        disp([varname,' does not exist.']);
    end
    
    clear varname
end

