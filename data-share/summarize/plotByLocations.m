function [ figHandle ] = plotByLocations( bins, sdfMat, rasterMat, trialNoLocationMat )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here

    %Split Target Locations into Tials by individual locations
    trialNoLocationMat=[trialNoLocationMat (1:size(trialNoLocationMat,1))']; 
    locations=unique(trialNoLocationMat(:,2));
    
    trialsByLocCell=arrayfun(@(x) trialNoLocationMat(trialNoLocationMat(:,2) == x, :), locations, 'uniformoutput', false);
    subPlotIndex = [6 3 2 1 4 7 8 9];
    figHandle=figure();
    for ii=1:length(locations)
        trialLocs=cell2mat(trialsByLocCell(ii));
        trials=trialLocs(:,3);
        subplot(3,3,subPlotIndex(ii));
        plot(bins,mean(sdfMat(trials,:),1),'b');
        %plotRasters(bins,rasterMat(trials,:));
        xlim([-3500 2500]);
    end

end

function plotRasters(bins,binaryMat)
  for ii=1:size(binaryMat,1)
     [~,co]=find(binaryMat(ii,:));
     line([bins(co); bins(co)],repmat([ii; ii+0.2],1,length(co)),'color','k')
  end
end

