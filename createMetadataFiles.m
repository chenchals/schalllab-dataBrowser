function [datafiles, files]=createMetadataFiles(location)
    files=scanForDatafiles(location);
    datafiles = cellfun(@(x) Datafile(x),files,'UniformOutput', false);
end