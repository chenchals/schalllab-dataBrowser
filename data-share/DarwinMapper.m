function [ mapper ] = DarwinMapper()
%DARWINMAPPER Summary of this function goes here
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
    targetOnset = 3500;
    mapper.correctTrials = @(allVars) find(allVars.Correct_(:,2)==1);
    mapper.targetLocation = @(allVars) [mapper.correctTrials(allVars) allVars.Target_(mapper.correctTrials(allVars),2)];
    mapper.responseLocation = @(allVars) [mapper.correctTrials(allVars) allVars.saccLoc(mapper.correctTrials(allVars),1)];
    % note add 3500 to all Event times
    mapper.fixateTime =@(allVars) fixateTime(allVars, mapper.correctTrials(allVars),targetOnset); 
    mapper.targetTime = @(allVars) [mapper.correctTrials(allVars) allVars.Target_(mapper.correctTrials(allVars),1)];
    %TargetHoldTimeJitter=13;%FixSpotOff
    %mapper.responseCueTime = @(allVars) [mapper.correctTrials(allVars) allVars.Target_(mapper.correctTrials(allVars),TargetHoldTimeJitter)+targetOnset)];
    mapper.responseCueTime = @(allVars) responseCueTime(allVars, mapper.correctTrials(allVars), targetOnset);
    mapper.saccadeTime = @(allVars) [mapper.correctTrials(allVars) allVars.SRT(mapper.correctTrials(allVars),1)+targetOnset];
    mapper.decideTime = @(allVars) [mapper.correctTrials(allVars) allVars.Decide_(mapper.correctTrials(allVars),1)+targetOnset];
    mapper.correctTime = @(allVars) correctTime(allVars, mapper.correctTrials(allVars),targetOnset);
    mapper.rewardTime = @(allVars) rewardTime(allVars, mapper.correctTrials(allVars),targetOnset);
    

end
% FixAcqTime_ not in S or Q
function [ fxVals ] = fixateTime(allVars, correctTrials, targetOnset)
  if isfield(allVars,'FixAcqTime_')
      fxVals = [correctTrials allVars.FixAcqTime_(correctTrials,1)+targetOnset];
  else
      fxVals = [correctTrials targetOnset-allVars.FixTime_Jit_(correctTrials,1)];
  end
end

% Target_(:,13) not in Q Target_ has 12 columns and not 13
function [ fxVals ] = responseCueTime(allVars, correctTrials, targetOnset)
  if size(allVars.Target_,2)==12
      % nans need double
      fxVals = [double(correctTrials) nan(length(correctTrials),1)];
  else
      fxVals = [correctTrials allVars.Target_(correctTrials,13)+targetOnset];
  end
end

% JuiceOn_ not in Q
function [ fxVals ] = rewardTime(allVars, correctTrials, targetOnset)
  if isfield(allVars,'JuiceOn_')
      fxVals = [correctTrials allVars.JuiceOn_(correctTrials,1)+targetOnset];
  else
      % nans need double
      fxVals = [double(correctTrials) nan(length(correctTrials),1)];
  end
end

% BellOn_ not in Q
function [ fxVals ] = correctTime(allVars, correctTrials, targetOnset)
  if isfield(allVars,'BellOn_')
      fxVals = [correctTrials allVars.BellOn_(correctTrials,1)+targetOnset];
  else
      % nans need double
      fxVals = [double(correctTrials) nan(length(correctTrials),1)];
  end
end

