function [ figHandle ] = plotByLocations( sdfStruct, trialNoLocationMat )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    infos=sdfStruct.cellAnnotations;
    eventMarkers=sdfStruct.alignedEvents;

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
    xRange=[-1500 2500];
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
        plotRasters(rasterStep,sdfStruct.bins,sdfStruct.counts,trials,spikeTrials,eventMarkers);
        drawnow;
        annotateLocation(trials,spikeTrials,noSpikeTrials,infos);
        drawnow;
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

function plotRasters(rasterStep, bins, binaryMat, trials, spikeTrials, eventMarkers )

    for ii=1:length(trials)
        if ismember(trials(ii),spikeTrials)
            [~,co]=find(binaryMat(trials(ii),:));
            col=[0.5 0.5 0.5];
        else
            endBin=length(bins);
            midBin=round(endBin/2);
            co=[1:40 midBin-20:midBin+20  endBin-40:endBin];
            col=[0.5 0.0 0.0];
        end
        yStart=repmat(rasterStep*ii,1,length(co));
        yExtent=[yStart; yStart+(rasterStep*0.5)];
        line([bins(co); bins(co)],yExtent,'color',col);
    end
    drawnow;
    hold;
    % for event markers all trials including noSpikeTrials
    marker={'m.','b.','r.'};
    if isstruct(eventMarkers)
        evNames= fieldnames(eventMarkers);
        for jj=1:length(evNames)
            yx=eventMarkers.(char(evNames(jj)));
            yx=yx(trials,:);
            y=(1:size(yx,1)).*rasterStep;
            x=yx(:,2);
            plot(x,y,marker{jj});
        end
    end
    hold;
end

function annotateLocation(trials,spikeTrials, noSpikeTrials, infos)
  annot={['Spike trials    : ' num2str(length(spikeTrials))];
         ['No Spike trials : ' num2str(length(noSpikeTrials))];
         ['Total trials    : ' num2str(length(trials))];
         };
   annot2={};
   if isstruct(infos)
       fields = fieldnames(infos);
       for ii=1:length(fields)
           f=char(fields(ii));
           v=infos.(f);
           if isnumeric(v)
               v=num2str(v);
           end
           annot2{ii,1}=strcat(f,' : ',v);
       end       
   end
     
  gca;
  x=min(xlim);
  y=max(ylim);
  if(x<0)
      text(x*0.90, y*0.90,annot);
  else
      text(x*1.10, y*0.90,annot);
  end
  text(max(xlim)*.7,y*.85,annot2)
end

function [mat, noSpikeTrials, spikeTrials] = removeNoSpikeRows(mat,trialNos)
  mat=mat(trialNos,:);
  mat(mat==0)=NaN;
  noSpikeRows=find(all(isnan(mat),2));
  mat(noSpikeRows,:)=[];
  %putback zeros
  mat(isnan(mat))=0;
  noSpikeTrials=trialNos(noSpikeRows);
  spikeTrials=setdiff(trialNos,noSpikeTrials);
   
end

