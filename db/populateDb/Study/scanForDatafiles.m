function [ files ] = scanForDatafiles(location)
    %ignore files with extension
    ignoreFileExt = {'.plx','.fig','.dcm','.pdf','.cmd','.CMD','.bat','.txt'};
    dirStruct = dir(location);
    % Inline function funcIgnore : ignore all that start with a {dot}
    funcIgnore = @(x) {isempty(regexp(x,'^\.','once'))};
    % Inline function funcFullpath : build full filepath
    funcFullpath = @(x) [x.folder,filesep ,x.name];
    % Find indexes in dirStructure that are used (not ignored)
    indxDirOrFile = find(cell2mat(cellfun(funcIgnore,{dirStruct.name}))~=0);
    % Find indexes in dirStruct that are directories
    indxDir = intersect(find(arrayfun(@(x) x.isdir, dirStruct)==1), indxDirOrFile);
    % Find indexes in dirStruct that are files
    indxFile = intersect(find(arrayfun(@(x) x.isdir, dirStruct)==0), indxDirOrFile);
    % directories in dirStruct
    dirs = arrayfun(funcFullpath,dirStruct(indxDir),'UniformOutput',false);
    % files in dirStruuct
    files = arrayfun(funcFullpath,dirStruct(indxFile),'UniformOutput',false);
    % Find indexes if files with extensions specified in the ignoreFileExt list above
    files = files(sum(cell2mat(arrayfun(@(x) [contains(cellstr(files),char(x))], ignoreFileExt, 'UniformOutput', false)),2) == 0);
    %files = files(cell2mat(cellfun(@(x) isequal(matfinfo(x),'MAT-file'), files, 'UniformOutput', false)) == 1);
    files = files(cell2mat(cellfun(@(x) isequal(finfo(x),'mat'), files, 'UniformOutput', false)) == 1);
    for d = 1:length(dirs)
        files = [files;scanForDatafiles(char(dirs(d)))];
    end
end

