function [out] = dataShareMemoryGuided( iFilename )
    preTime=-100; % for spikes.  Always aligned on Fixate_ event
    if iscell(iFilename)
        iFilename=char(iFilename);
    end
    disp(['Doing file ; ' iFilename]);
    vars=load(iFilename,'-mat');
    fnames=fieldnames(vars);
    if isfield(vars,'Header_') && length(vars.Header_)==56
        mapper=getPdPMapper();
    else
        mapper=getDarwinMapper();
    end
    
    
    [~,fn,ext]=fileparts(iFilename);
    out.Filename=[fn ext];
    correctTrials=mapper.correctTrials(vars);
    fixateTime=mapper.fixateTime(vars,correctTrials);
    alignTime=fixateTime(:,2);
    out.CorrectTrials=correctTrials;
    out.TargetLocation=mapper.targetLocation(vars,correctTrials);
    [locationCounts, locations]=histcounts(out.TargetLocation(:,2), (0:8));
    out.CorrectTrialsByLocation=[locations(1:end-1); locationCounts]';

    out.FixateTime=fixateTime;
    out.TargetTime=mapper.targetTime(vars,correctTrials,alignTime);
    out.FixSpotOffTime=mapper.fixSpotOffTime(vars,correctTrials,alignTime);
    out.SaccadeTime=mapper.saccadeTime(vars,correctTrials,alignTime);
    out.DecideTime=mapper.decideTime(vars,correctTrials,alignTime);
    out.ResponseLocation=mapper.responseLocation(vars,correctTrials);
    out.CorrectTime=mapper.correctTime(vars,correctTrials,alignTime);
    out.RewardTime=mapper.rewardTime(vars,correctTrials,alignTime);
    
    %For spike it is similar across all sessions and subjects
    spikeNameIndex=find(~cellfun(@isempty, regexp(fnames,'Spike_|DSP\d{2}[a-e]')));
    for ii=1:length(spikeNameIndex)
        spikeName=char(fnames(spikeNameIndex(ii)));
        disp(['Doing Cell; ' spikeName]);
        out.Cells.(spikeName).trialNo=correctTrials;
        spikes=vars.(spikeName)(correctTrials,:);
        out.Cells.(spikeName).spikeTimesRaw=single(spikes);
        spikes(spikes==0)=NaN;
        spikes=spikes-alignTime;
        [ro,co]=find(spikes<preTime);
        spikes(ro,co)=NaN;
        out.Cells.(spikeName).spikeTimes=single(spikes);
        
    end

end

function mapper = getPdPMapper()
  % all trial events are aligned on TrialStart for each trial
  mapper.correctTrials = @(allVars) single(find(allVars.Correct_(:,2)==1));
  mapper.fixateTime = @(allVars,trialNos) single([trialNos allVars.Fixate_(trialNos,1)]);
  mapper.targetTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Target_(trialNos,1)-alignTime]);
  mapper.targetLocation = @(allVars,trialNos) single([trialNos allVars.Target_(trialNos,2)]);
  mapper.fixSpotOffTime = @(allVars,trialNos,alignTime) single([trialNos allVars.FixSpotOff_(trialNos,1)-alignTime]);
  mapper.saccadeTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Saccade_(trialNos,1)-alignTime]);
  mapper.decideTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Decide_(trialNos,1)-alignTime]);  
  mapper.responseLocation = @(allVars,trialNos) single([trialNos allVars.Decide_(trialNos,2)]);  
  %CorrectTime and RewardTime are same
  mapper.correctTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Correct_(trialNos,1)-alignTime]);
  mapper.rewardTime = @(allVars,trialNos,alignTime) single([trialNos allVars.Reward_(trialNos,1)-alignTime]);
end

function mapper = getDarwinMapper()

% %    fixSpotOnTime = FixOn_(:,1)+Target(:,1)
% %     **fixateTime = FixAcqTime_(:,1) + Target(:,1)     % (offset=3500)
% %     targetOnTime = Target(:,1)                        % 3500 for all trials
% % **fixSpotOffTime = Target(:,1) + Target(:,13)         % 13th col = TrialHoldTime taking jitter  
% %   fixSpotOffTime = Target(:,1) + Target(:,10)         % 10th col = HoldTime 600 constant no jitter   <=== guess this is incorrect
% %    **saccadeTime = SRT(:,1) + 3500                    % from email to Thomas for SAT data monk left fix window?
% %       decideTime = Decide_(:,1) + 3500                % machine determined saccade in target location (correct trials)
% %       rewardTime = BellOn_(:,1) + 3500                % Same as Juice ON for MG  decideTime + monk hold fixation in tag window 
% %      rewardTime2 = JuiceOn_(:,1) + 3500               % Same as Bell ON for MG

  % all trial events are aligned on Target Onset a constant of 3500 ms
  %offset=Target_(trialNos,TargetONIndex);
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



