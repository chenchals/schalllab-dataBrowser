function [outStruct] = xls2struct(excelFile, sheetName, columnNamesRowNum)
%XLS2STRUCT Convert an excel sheet to a matlab struct.
%   columnNamesRowNum: the row number from which to to read data. This row
%   shall contain the column Names. Rows following this row will be the
%   data that is converted to a struct.  All values for the field names
%   will be strings.   It will be as if you have read from a text file.
%   
%   Note: Matlab struct has a restricted cahracter set, so any char not in
%   [a-zA-Z0-9] is replaced by an '_'. Fist char has to be in [a-zA-Z]  
%   Columns with 'missing data' are dropped.

    % indx of non-missing columns in excel sheet
    nonMissingCols=@(x) sum(~isnan(x))>0;
    % Make excel column names compliant with matlab struct fieldnames
    colName2Field=@(x) regexprep(x,'[^a-z,A-Z,0-9]','_');
    [~,~,raw]=xlsread(excelFile, sheetName);
    colIdx=cell2mat(cellfun(nonMissingCols,raw(columnNamesRowNum,:),'UniformOutput',false));
    fieldNames=cellfun(colName2Field,raw(columnNamesRowNum,colIdx),'UniformOutput',false)';
    outStruct=cell2struct(raw(columnNamesRowNum+1:end,colIdx),fieldNames,2);

end