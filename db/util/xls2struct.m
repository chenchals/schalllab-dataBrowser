function [outStruct] = xls2struct(excelFile, sheetName, columnNamesRowNum)

    % indx of non-missing columns in excel sheet
    nonMissingCols=@(x) sum(~isnan(x))>0;
    % Make excel column names compliant with matlab struct fieldnames
    colName2Field=@(x) regexprep(x,'[^a-z,A-Z,0-9]','_');
    [~,~,raw]=xlsread(excelFile, sheetName);
    colIdx=cell2mat(cellfun(nonMissingCols,raw(columnNamesRowNum,:),'UniformOutput',false));
    fieldNames=cellfun(colName2Field,raw(columnNamesRowNum,colIdx),'UniformOutput',false)';
    outStruct=cell2struct(raw(columnNamesRowNum+1:end,colIdx),fieldNames,2);

end