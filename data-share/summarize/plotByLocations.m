function [ figHandle ] = plotByLocations( sdfStruct, trialNoLocationMat )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    
    if isempty(sdfStruct.bins) || isempty(sdfStruct.sdf) || isempty(sdfStruct.counts)
        figHandle=figure();
        text(0.5,0.5,'No Spikes to plot for this Cell');
        return
    end
    
    %Split Target Locations into Tials by individual locations
    trialNoLocationMat=[trialNoLocationMat (1:size(trialNoLocationMat,1))']; 
    locations=unique(trialNoLocationMat(:,2));
    nTrialsPerLoc=histcounts(trialNoLocationMat(:,2),locations);
    trialsByLocCell=arrayfun(@(x) trialNoLocationMat(trialNoLocationMat(:,2) == x, :), locations, 'uniformoutput', false);
    noSpikeTrialsByLoc={};
    spikeTrialsByLoc={};
    %Compute mean sdfs to get Y scaling
    meanSdf=[];
    for ii=length(locations):-1:1
        trials=trialsByLocCell{ii}(:,3);
        [reducedMat,noSpikeTrialsByLoc{ii}, spikeTrialsByLoc{ii}]=removeNoSpikeRows(sdfStruct.sdf, trials);
        %meanSdf(ii,:) = mean(sdfStruct.sdf(trials,:),1);       
        meanSdf(ii,:) = mean(reducedMat,1);       
    end
    % Limits for plots
    yRounding=5; %spiks/sec
    xRange=[-1200 3000];
    yRange=[0 ceil(max(meanSdf(:)/yRounding))*yRounding];
    % If plotting rasters y val for each trial
    % rasterStep = (80% * yMax) / maxNoTrials in a plot
    rasterStep = yRange(2)/max(nTrialsPerLoc);
    %Now plot the means and rasters
    subPlotIndex = [6 3 2 1 4 7 8 9];
    figHandle=createFigure();
    for ii=1:length(locations)      
        trials=trialsByLocCell{ii}(:,3);
        noSpikeTrials=noSpikeTrialsByLoc{ii};
        spikeTrials=spikeTrialsByLoc{ii};
        subplot(3,3,subPlotIndex(ii));
        plot(sdfStruct.bins,meanSdf(ii,:),'b');
        xlim(xRange);
        ylim(yRange);
        drawnow;
        plotRasters(rasterStep,sdfStruct.bins,sdfStruct.counts,trials,spikeTrials,noSpikeTrials);
    end

end

function figureHangle = createFigure()
    figureHangle = figure();
    set(figureHangle, 'Units', 'pixels');
    set(figureHangle, 'Position', [750  500 1750  1250]);
    set(figureHangle, 'PaperUnits', 'inches');
    set(figureHangle,'PaperPosition', [1 1 10 7]);
    set(figureHangle,'PaperOrientation','landscape');
end

function plotRasters(rasterStep, bins, binaryMat, trials, spikeTrials, noSpikeTrials )

  for ii=1:length(trials)
     if ismember(trials(ii),spikeTrials)
       [~,co]=find(binaryMat(trials(ii),:));
       col=[0.5 0.5 0.5];
     else
         endBin=length(bins);
         midBin=round(endBin/2);
         co=[1:40 midBin-20:midBin+20  endBin-40:endBin];
         col=[0.9 0.0 0.0];
     end     
     yStart=repmat(rasterStep*ii,1,length(co));
     yExtent=[yStart; yStart+(rasterStep*0.5)];
     %line([bins(co); bins(co)],repmat([ii; ii+0.2],1,length(co)),'color','k');
     line([bins(co); bins(co)],yExtent,'color',col);
  end
  annot={['Spike trials    : ' num2str(length(spikeTrials))];
         ['No Spike trials : ' num2str(length(noSpikeTrials))];
         ['Total trials    : ' num2str(length(trials))];
         };
  gca;
  x=min(xlim);
  y=max(ylim);
  if(x<0)
      text(x*0.90, y*0.90,annot);
  else
      text(x*1.10, y*0.90,annot);
  end
  drawnow;
  
end

function [mat, noSpikeTrials, spikeTrials] = removeNoSpikeRows(mat,trialNos)
  mat=mat(trialNos,:);
  mat(mat==0)=NaN;
  %reduce dimension
  %reducedMat=reducedMat(any(~isnan(reducedMat),2),:);
  noSpikeRows=find(all(isnan(mat),2));
  mat(noSpikeRows,:)=[];
  %putback zeros
  mat(isnan(mat))=0;
  noSpikeTrials=trialNos(noSpikeRows);
  spikeTrials=setdiff(trialNos,noSpikeTrials);
   
end

