function [sdfStruct] = sdf(spikeTimes, events, alignEventName, eventMarkerNames, cellAnnotations)
%function [sdfStruct] = sdf(spikeTimes, alignTimes, eventMarkers, cellAnnotations)
% creates spike-density function from spike times
% 
  if isnan(max(spikeTimes(:))) || isnan(min(spikeTimes(:)) || ~isstruct(events) )
      % no spikes in spike matrix
      sdfStruct.counts=[];
      sdfStruct.sdf=[];
      sdfStruct.bins=[];
      sdfStruct.cellAnnotations=[];
      sdfStruct.alignedEvents=[];
      return;
  end
  
  if ~isfield(events, alignEventName)
      error('Align event name is not in events struct');
  end
  alignTimes = events.(alignEventName);
  alignTimes = alignTimes(:,2);
  
  % Bin width for min / max time: Time axis will be evenly divisible by this
  % example 50 --> x
  binRounding=50;
  % Assume trials are in rows
  nTrials=size(spikeTimes,1);
  if ~isscalar(alignTimes) &&  ~(numel(alignTimes)==nTrials) 
          error('No of elements in alignTimes must equal number of rows in spikeTimes');
  end
  alignTimes=alignTimes(:);  
  spikeTimes(spikeTimes==0)=NaN;
  spikeTimes = spikeTimes - alignTimes;
  % Align event markes if is cell array
  if iscell(eventMarkerNames) 
      for ii=1:length(eventMarkerNames)
          eventName=char(eventMarkerNames(ii));
          eventMat=events.(eventName);
          sdfStruct.alignedEvents.(eventName)=[eventMat(:,1) eventMat(:,2)-alignTimes]; 
      end
  end
  
  hMin = floor(min(spikeTimes(:)/binRounding))*binRounding;
  hMax = ceil(max(spikeTimes(:)/binRounding))*binRounding;
  
  % histogram spikes by trial
  spikebyTrialCells=mat2cell(spikeTimes, ones(1,nTrials), size(spikeTimes,2));
  [hCounts,~]=cellfun(@(trial) histcounts(trial,(hMin:(hMax+1))), spikebyTrialCells,'UniformOutput',false);
  sdfStruct.counts=cell2mat(hCounts);
  sdfStruct.sdf=convn(sdfStruct.counts',getExpKernel(),'same')';
  sdfStruct.bins=hMin:hMax;
  if exist('cellAnnotations','var')
    sdfStruct.cellAnnotations=cellAnnotations;
  else
    sdfStruct.cellAnnotations={};
  end

end

%% Convolution Kernel based on Post-synaptic potential
function kernel = getExpKernel()
    growth=1; decay=20;
    halfBinWidth=round(decay*4);
    binSize=(halfBinWidth*2)+1;
    kernel=0:halfBinWidth;
    postHalfKernel=(1-(exp(-(kernel./growth)))).*(exp(-(kernel./decay)));
    %normalize area oft he kernel
    postHalfKernel=postHalfKernel./sum(postHalfKernel);
    %set preHalfKernel to zero
    kernel(1:halfBinWidth)=0;
    kernel(halfBinWidth+1:binSize)=postHalfKernel;
    kernel=kernel.*1000;
    % make kernel a column vector to do a convn on matrix
    kernel=kernel';
    %Note: convn works column wise for matrix:
    % resultTrialsInColumns = convn(TrialsInRowsMatrix' ,
    %    kernelColumnVector, 'same'); % not transpose in the end
    %
    % resultTrialsInRows = convn(TrialsInRowsMatrix' , kernelColumnVector,
    % 'same')'; % added transpose int he end
end

