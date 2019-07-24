function [  ] = summarize( sessionDir, alignEventName, eventMarkerNames)
%SUMMARIZE Summary of this function goes here
%   Detailed explanation goes here
    figureExport=1;
    load(strcat(sessionDir,filesep,'Cells.mat'));
    load(strcat(sessionDir,filesep,'Events.mat'));
    cellIds=fieldnames(Cells);
    for ii=1:length(cellIds)
        cellId = char(cellIds{ii});
        delete(gcf)
        %oSdf=sdf(Cells.(cellId).spikeTimes,Events,'TargetTime',{'SaccadeTime'},Cells.(cellId).info);
        oSdf=sdf(Cells.(cellId).spikeTimes,Events,alignEventName,eventMarkerNames,Cells.(cellId).info);
        h=plotByLocations(oSdf, Events.TargetLocation);
        if figureExport
            fxExists = which('export_fig');
            if isempty(fxExists)
                warning('Function export_fig does nto exist on Matlab path!');
                warning('Please download export_fig from Matlab file exchange and add to Matlab path');
                warning('Download URL: https://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/23629/versions/100/download/zip');
            else
                export_fig([sessionDir 'sdf.pdf'],'-pdf','-append',h);
            end
        else
            pause
        end
    end

end

