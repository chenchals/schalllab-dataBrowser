function [Events, Cells] = dataShareMemoryGuided( iFilename, varargin )
    
% All times are aligned to Target Onset
    % dir for output
    oDir='temp-data/';%write to temp data
    logger = '';
    if length(varargin)==2
        oDir = char(varargin{1});
        logger = varargin{2};
    elseif length(varargin)==1
        oDir = char(varargin{1});
        logger = Logger.getLogger([oDir 'temp-logger.log']);
    else
        mkdir(oDir);
        logger = Logger.getLogger([oDir filesep 'temp-logger.log']);
    end
    
    %  Always aligned on TrialStart
    summarize=1;
    if iscell(iFilename)
        iFilename=char(iFilename);
    end
    logger.info(sprintf('Processing Events for file: %s ', iFilename));
    vars=load(iFilename,'-mat');
    fnames=fieldnames(vars);
    if isfield(vars,'Header_') && length(vars.Header_)==56
        mapper=getPdPMapper();
    else
        mapper=DarwinMapper();
    end
    
    [~,fn,ext] = fileparts(iFilename);
    Events.Filename = [fn ext];
    Events.CorrectTrials = mapper.correctTrials(vars);
    Events.TargetLocation=mapper.targetLocation(vars);
    [locationCounts, locations]=histcounts(Events.TargetLocation(:,2), (0:8));
    Events.CorrectTrialsByLocation=[locations(1:end-1); locationCounts]';
    Events.ResponseLocation=mapper.responseLocation(vars);

    Events.FixateTime=mapper.fixateTime(vars);
    Events.TargetTime=mapper.targetTime(vars);
    Events.ResponseCueTime=mapper.responseCueTime(vars);
    Events.SaccadeTime=mapper.saccadeTime(vars);
    Events.DecideTime=mapper.decideTime(vars);
    Events.CorrectTime=mapper.correctTime(vars);
    Events.RewardTime=mapper.rewardTime(vars);
    
    correctTrials = Events.CorrectTrials;
    % Save Events file
    oFile = [oDir 'Events.mat'];
    logger.info(sprintf('Saving Events for file: %s to %s', iFilename,oFile));
    saveVar(oFile,Events);
    %For spike it is similar across all sessions and subjects
    spikeNameIndex=find(~cellfun(@isempty, regexp(fnames,'Spike_|DSP\d{2}[a-e]')));
    %Cells.trialNo = correctTrials;
    for ii=1:length(spikeNameIndex)
        spikeName=char(fnames(spikeNameIndex(ii)));
        logger.info(sprintf('Doing Cell: %s ', spikeName));
        Cells.(spikeName).trialNo=correctTrials;
        spikeTimes=vars.(spikeName)(correctTrials,:);
        spikeTimes(spikeTimes==0)=nan;
        Cells.(spikeName).spikeTimes=spikeTimes;
        %Cell info
        Cells.(spikeName).info.cellId=spikeName;
        Cells.(spikeName).info.BrainId=[];
        if isfield(vars,'BrainID')
            Cells.(spikeName).info.BrainId=vars.BrainID.(spikeName);
        end
        Cells.(spikeName).info.Hemifield=[];
        if isfield(vars,'Hemi')
            Cells.(spikeName).info.Hemifield=vars.Hemi.(spikeName);
        end
        
        Cells.(spikeName).info.RFs=[];
        if isfield(vars,'RFs')
            Cells.(spikeName).info.RFs=vars.RFs.(spikeName);
        end
        Cells.(spikeName).info.MFs=[];
        if isfield(vars,'MFs')
            Cells.(spikeName).info.MFs=vars.MFs.(spikeName);
        end
    end
    % Save Cells file
    oFile = [oDir 'Cells.mat'];
    logger.info(sprintf('Saving Events for file: %s to %s', iFilename,oFile));
    saveVar(oFile,Cells);

    if(summarize)
        cellIds=fieldnames(Cells);
        for ii=1:length(cellIds)
            cellId = char(cellIds{ii});
            logger.info(sprintf('Summarizing cell %s:', cellId));
            delete(gcf)
            oSdf=sdf(Cells.(cellId).spikeTimes,Events,'TargetTime',{'SaccadeTime'},Cells.(cellId).info);
            h=plotByLocations(oSdf, Events.TargetLocation);
            export_fig([oDir 'sdf.pdf'],'-pdf','-append',h);
        end
    end
end

function mapper = getPdPMapper()
  % all trial events are aligned on TrialStart for each trial
  mapper.correctTrials = @(allVars) single(find(allVars.Correct_(:,2)==1));
  mapper.targetLocation = @(allVars,trialNos) single([trialNos allVars.Target_(trialNos,2)]);
  mapper.responseLocation = @(allVars,trialNos) single([trialNos allVars.Decide_(trialNos,2)]);  

  mapper.fixSPotOn =  @(allVars,trialNos) single([trialNos allVars.FixSpotOn_(trialNos,2)]);
  
  
  mapper.fixateTime = @(allVars,trialNos) single([trialNos allVars.Fixate_(trialNos,1)]);
  
  mapper.targetTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Target_(trialNos,1)]);
  mapper.fixSpotOffTime = @(allVars,trialNos) single([trialNos allVars.FixSpotOff_(trialNos,1)]);
  mapper.saccadeTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Saccade_(trialNos,1)]);
  mapper.decideTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Decide_(trialNos,1)]);  
  %CorrectTime and RewardTime are same
  mapper.correctTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Correct_(trialNos,1)]);
  mapper.rewardTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Reward_(trialNos,1)]);
end


function [] = saveVar(oFile, myVar)
    [fp,~,~]=fileparts(oFile);
    if (~exist(fp,'dir'))
        mkdir(fp);
    end
    save(oFile,'myVar');
end


function [] = saveToEvents(oDir,oDirMonk,oDirFile,outStruct)
   fp=[oDir,oDirMonk,filesep,oDirFile,filesep];
   fn='Events.mat';
   if (~exist(fp,'dir'))
       mkdir(fp);
   end
   cells = outStruct.Cells;
   outStruct.Cells=[];
   % Events 
   f = [fp fn];
   save f -struct outStruct;
end
