function [ mapper ] = JouleMapper()
%JOULEMAPPER Matfile variable mapper for Xena and Joule (recorded by Paul)
    % All trial events are aligned on Trial Start
    %offset=0;
    
    % %    
    % %       fixateTime = fixWindowEntered(:,1)              % (offset=0)
    % %       targetTime = targOn(:,1)                        % for all trials
    % %  responseCueTime = fixOff(:,1)                        % 
    % %      saccadeTime = responseOnset(:,1)                 % 
    % %       decideTime = targetWindowEntered(:,1)           % 
    % %      correctTime = toneOn(:,1)                        % 
    % %      rewardTime  = cell2mat(rewardOn(:,1))            % Same as Bell ON for MG
        
    trialOffset = 0;
    mapper.correctTrials = @(allVars) find(strcmpi(trialOutcome,'saccToTarget'));
    mapper.targetLocation = @(allVars) [mapper.correctTrials(allVars) allVars.Target_(mapper.correctTrials(allVars),2)];

    mapper.responseLocation = @(allVars) responseLocation(allVars,mapper.correctTrials(allVars));
        
    % note add 3500 to all Event times
    mapper.fixateTime =@(allVars) fixateTime(allVars, mapper.correctTrials(allVars),trialOffset); 
    mapper.targetTime = @(allVars) [mapper.correctTrials(allVars) allVars.Target_(mapper.correctTrials(allVars),1)];
    %TargetHoldTimeJitter=13;%FixSpotOff
    mapper.responseCueTime = @(allVars) responseCueTime(allVars, mapper.correctTrials(allVars), trialOffset);
    mapper.saccadeTime = @(allVars) [mapper.correctTrials(allVars) allVars.SRT(mapper.correctTrials(allVars),1)+trialOffset];
    mapper.decideTime = @(allVars) [mapper.correctTrials(allVars) allVars.Decide_(mapper.correctTrials(allVars),1)+trialOffset];
    mapper.correctTime = @(allVars) correctTime(allVars, mapper.correctTrials(allVars),trialOffset);
    mapper.rewardTime = @(allVars) rewardTime(allVars, mapper.correctTrials(allVars),trialOffset);
    %Eyes
    mapper.eyePos = @(allVars) eyePos(allVars,mapper.correctTrials(allVars));
    %Cells 
    mapper.cells = @(allVars) spikeTimes(allVars, mapper.correctTrials(allVars));

end

function [ eyes ] = eyePos(allVars, correctTrials)
   eyes.trialNo = correctTrials;
   eyes.EyeX = allVars.EyeX_(correctTrials,:);
   eyes.EyeY = allVars.EyeY_(correctTrials,:);
end


function [ cells ] = spikeTimes(allVars, correctTrials)
    fnames= fieldnames(allVars);
    spikeNameIndex=find(~cellfun(@isempty, regexp(fnames,'DSP\d{2}[a-z]')));
    %Cells.trialNo = correctTrials;
    for ii=1:length(spikeNameIndex)
        spikeName=char(fnames(spikeNameIndex(ii)));
        cells.(spikeName).trialNo=correctTrials;
        spikeTimes=allVars.(spikeName)(correctTrials,:);
        spikeTimes(spikeTimes==0)=nan;
        cells.(spikeName).spikeTimes=spikeTimes;
        %Cell info.cellId
        cells.(spikeName).info.cellId=spikeName;
        %info.BrainId
        cells.(spikeName).info.BrainId=[];
        if isfield(allVars,'BrainID') && isfield(allVars.BrainID,spikeName)
            cells.(spikeName).info.BrainId=allVars.BrainID.(spikeName);
        end
        %info.Hemifield
        cells.(spikeName).info.Hemifield=[];
        if isfield(allVars,'Hemi') && isfield(allVars.Hemi,spikeName)
            cells.(spikeName).info.Hemifield=allVars.Hemi.(spikeName);
        end
        %info.RFs
        cells.(spikeName).info.RFs=[];
        if isfield(allVars,'RFs') && isfield(allVars.RFs,spikeName)
            cells.(spikeName).info.RFs=allVars.RFs.(spikeName);
        end
        %info.MFs
        cells.(spikeName).info.MFs=[];
        if isfield(allVars,'MFs') && isfield(allVars.MFs,spikeName)
            cells.(spikeName).info.MFs=allVars.MFs.(spikeName);
        end
    end

end

function [ respLoc ] = responseLocation(allVars, correctTrials)
  if isfield(allVars,'saccadeToTargLocation') % when present will contain the right value
      respLoc = [correctTrials allVars.saccadeToTargLocation(correctTrials,1)];
  else
      respLoc = [double(correctTrials) nan(size(correctTrials))];
  end
end

% FixAcqTime_ not in S or Q
function [ fxVals ] = fixateTime(allVars, correctTrials, trialOffset)
  if isfield(allVars,'FixAcqTime_')
      fxVals = [correctTrials allVars.FixAcqTime_(correctTrials,1)+trialOffset];
  elseif isfield(allVars,'FixTime_Jit_')
      fxVals = [correctTrials trialOffset-allVars.FixTime_Jit_(correctTrials,1)];
  else
      % Example: /Volumes/schalllab/data/Quincy/TL/Matlab/Q070105002-JC_MG.mat ?
      fxVals = [double(correctTrials) nan(size(correctTrials))];
  end
end

% Target_(:,13) not in Q Target_ has 12 columns and not 13
function [ fxVals ] = responseCueTime(allVars, correctTrials, trialOffset)
  if size(allVars.Target_,2)==12
      % nans need double
      fxVals = [double(correctTrials) nan(length(correctTrials),1)];
  else
      fxVals = [correctTrials allVars.Target_(correctTrials,13)+trialOffset];
  end
end

% JuiceOn_ not in Q
function [ fxVals ] = rewardTime(allVars, correctTrials, trialOffset)
  if isfield(allVars,'JuiceOn_')
      fxVals = [correctTrials allVars.JuiceOn_(correctTrials,1)+trialOffset];
  else
      % nans need double
      fxVals = [double(correctTrials) nan(size(correctTrials))];
  end
end

% BellOn_ not in Q
function [ fxVals ] = correctTime(allVars, correctTrials, trialOffset)
  if isfield(allVars,'BellOn_')
      fxVals = [correctTrials allVars.BellOn_(correctTrials,1)+trialOffset];
  else
      % nans need double
      fxVals = [double(correctTrials) nan(size(correctTrials))];
  end
end

