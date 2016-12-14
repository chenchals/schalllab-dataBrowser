function [outStruct] = xls2struct(excelFile, sheetName, columnNamesRowNum)

    % Excel files to tread
    %     subjects='/Volumes/schalllab/policy_procedures/NHPs/NHP Records/Schall ALL NHP/Schall_All_NHP_Major_Intervals 07-22-16.xlsx';
    %     subjectsAllDataSheet='ALL DATA';
    %     allNames='/Volumes/schalllab/policy_procedures/NHPs/NHP Records/Schall ALL NHP/All Names List.xlsx';
    %     allNamesDataSheet='Sheet1';
    
    % indx of non-missing columns in excel sheet
    nonMissingCols=@(x) sum(~isnan(x))>0;
    % Make excel column names compliant with matlab struct fieldnames
    colName2Field=@(x) regexprep(x,'[^a-z,A-Z,0-9]','_');
    [~,~,raw]=xlsread(excelFile, sheetName);
    %column names in row 4, data row 5 onwards
    colIdx=cell2mat(cellfun(nonMissingCols,raw(columnNamesRowNum,:),'UniformOutput',false));
    fieldNames=cellfun(colName2Field,raw(columnNamesRowNum,colIdx),'UniformOutput',false)';

    outStruct=cell2struct(raw(columnNamesRowNum+1:end,colIdx),fieldNames,2);

    %uniqColVals=unique(cellfun(@(x) regexprep(char(x),'\s+$',''),{subjectsExcelData.NAME},'UniformOutput',false))';

end