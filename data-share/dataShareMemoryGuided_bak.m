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
    
    %  Always aligned on Fixate_ event
    summarize=0;
    if iscell(iFilename)
        iFilename=char(iFilename);
    end
    logger.info(sprintf('Processing Events for file: %s ', iFilename));
    vars=load(iFilename,'-mat');
    fnames=fieldnames(vars);
    if isfield(vars,'Header_') && length(vars.Header_)==56
        mapper=getPdPMapper();
    else
        mapper=getDarwinMapper();
    end
    
    [~,fn,ext]=fileparts(iFilename);
    Events.Filename=[fn ext];
    Events.AlignedOn='FixateTime';
    correctTrials=mapper.correctTrials(vars);
    fixateTime=mapper.fixateTime(vars,correctTrials);
    alignTime=fixateTime(:,2);
    Events.CorrectTrials=correctTrials;
    Events.TargetLocation=mapper.targetLocation(vars,correctTrials);
    [locationCounts, locations]=histcounts(Events.TargetLocation(:,2), (0:8));
    Events.CorrectTrialsByLocation=[locations(1:end-1); locationCounts]';
    Events.AlignTime=fixateTime;
    Events.FixateTime=fixateTime;
    Events.TargetTime=mapper.targetTime(vars,correctTrials,alignTime);
    Events.FixSpotOffTime=mapper.fixSpotOffTime(vars,correctTrials,alignTime);
    Events.SaccadeTime=mapper.saccadeTime(vars,correctTrials,alignTime);
    Events.DecideTime=mapper.decideTime(vars,correctTrials,alignTime);
    Events.ResponseLocation=mapper.responseLocation(vars,correctTrials);
    Events.CorrectTime=mapper.correctTime(vars,correctTrials,alignTime);
    Events.RewardTime=mapper.rewardTime(vars,correctTrials,alignTime);
    % Save Events file
    oFile = [oDir 'Events.mat'];
    logger.info(sprintf('Saving Events for file: %s to %s', iFilename,oFile));
    saveVar(oFile,Events);
    %For spike it is similar across all sessions and subjects
    spikeNameIndex=find(~cellfun(@isempty, regexp(fnames,'Spike_|DSP\d{2}[a-e]')));
    for ii=1:length(spikeNameIndex)
        spikeName=char(fnames(spikeNameIndex(ii)));
        logger.info(sprintf('Doing Cell: %s ', spikeName));
        Cells.(spikeName).trialNo=correctTrials;
        spikes=vars.(spikeName)(correctTrials,:);
        Cells.(spikeName).spikeTimesRaw=single(spikes);
        spikes(spikes==0)=NaN;
        spikes=reduceDimension(spikes);
        spikes=spikes-alignTime;
        spikes=reduceDimension(spikes, -500);
        Cells.(spikeName).spikeTimes=single(spikes);
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
            oSdf=sdf(Cells.(cellId).spikeTimes,Events.TargetTime(:,2));
            h=plotByLocations(oSdf, Events.TargetLocation);
            export_fig([oDir 'sdf.pdf'],'-pdf','-append',h);
        end
    end
end

function mapper = getPdPMapper()
  % all trial events are aligned on TrialStart for each trial
  mapper.correctTrials = @(allVars) single(find(allVars.Correct_(:,2)==1));
  mapper.fixateTime = @(allVars,trialNos) single([trialNos allVars.Fixate_(trialNos,1)]);
  mapper.targetTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Target_(trialNos,1)]);
  mapper.targetLocation = @(allVars,trialNos) single([trialNos allVars.Target_(trialNos,2)]);
  mapper.fixSpotOffTime = @(allVars,trialNos) single([trialNos allVars.FixSpotOff_(trialNos,1)]);
  mapper.saccadeTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Saccade_(trialNos,1)]);
  mapper.decideTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Decide_(trialNos,1)]);  
  mapper.responseLocation = @(allVars,trialNos) single([trialNos allVars.Decide_(trialNos,2)]);  
  %CorrectTime and RewardTime are same
  mapper.correctTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Correct_(trialNos,1)]);
  mapper.rewardTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Reward_(trialNos,1)]);
end

function mapper = getDarwinMapper()
    % all trial events are aligned on Target Onset a constant of 3500 ms
    %offset=Target_(trialNos,TargetONIndex);

    % %    fixSpotOnTime = FixOn_(:,1)+Target(:,1)
    % %     **fixateTime = FixAcqTime_(:,1) + Target(:,1)     % (offset=3500)
    % %     targetOnTime = Target(:,1)                        % 3500 for all trials
    % % **fixSpotOffTime = Target(:,1) + Target(:,13)         % 13th col = TrialHoldTime taking jitter
    % %   fixSpotOffTime = Target(:,1) + Target(:,10)         % 10th col = HoldTime 600 constant no jitter   <=== guess this is incorrect
    % %    **saccadeTime = SRT(:,1) + 3500                    % from email to Thomas for SAT data monk left fix window?
    % %       decideTime = Decide_(:,1) + 3500                % machine determined saccade in target location (correct trials)
    % %       rewardTime = BellOn_(:,1) + 3500                % Same as Juice ON for MG  decideTime + monk hold fixation in tag window
    % %      rewardTime2 = JuiceOn_(:,1) + 3500               % Same as Bell ON for MG
    mapper.correctTrials = @(allVars) single(find(allVars.Correct_(:,2)==1));
    TargetONIndex=1;
    mapper.targetTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Target_(trialNos,TargetONIndex)-alignTime]);

    mapper.fixateTime = @(allVars,trialNos) single([trialNos allVars.FixAcqTime_(trialNos,1)+ allVars.Target_(trialNos,TargetONIndex)]);
    TargetLocationIndex=2;
    mapper.targetLocation = @(allVars,trialNos) single([trialNos allVars.Target_(trialNos,TargetLocationIndex)]);
    % dont know yet
    TargetHoldTimeJitter=13;
    mapper.fixSpotOffTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Target_(trialNos,TargetONIndex)+allVars.Target_(trialNos,TargetHoldTimeJitter)-alignTime]);
    mapper.saccadeTime = @(allVars,trialNos,alignTime) single([trialNos allVars.SRT(trialNos,1)+allVars.Target_(trialNos,TargetONIndex)-alignTime]);
    mapper.decideTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Decide_(trialNos,1)+allVars.Target_(trialNos,TargetONIndex)-alignTime]);
    mapper.responseLocation = @(allVars,trialNos) single([trialNos allVars.saccLoc(trialNos,1)]);
    mapper.correctTime = @(allVars,trialNos,alignTime) single([trialNos allVars.BellOn_(trialNos,1)+allVars.Target_(trialNos,TargetONIndex)-alignTime]);
    mapper.rewardTime = @(allVars,trialNos,alignTime) single([trialNos allVars.JuiceOn_(trialNos,1)+allVars.Target_(trialNos,TargetONIndex)-alignTime]);
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
