function [ subjects ] = SubjectPopulate()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    subjectsExcel='/Volumes/schalllab/policy_procedures/NHPs/NHP Records/Schall ALL NHP/Schall_All_NHP_Major_Intervals 07-22-16.xlsx';
    subjectsAllDataSheet='ALL DATA';
    allNames='/Volumes/schalllab/policy_procedures/NHPs/NHP Records/Schall ALL NHP/All Names List.xlsx';
    allNamesDataSheet='Sheet1';

    [subjectUniqData,uniqNames,allData]=getSubjectData(subjectsExcel,subjectsAllDataSheet,4);

    subjectDirs=xls2struct(allNames,allNamesDataSheet,1);
    c=0;
    
    for ii=1:length({subjectDirs.Name})
        dataDir=subjectDirs(ii).Name;
        idx=find(strncmpi({subjectUniqData.NAME},dataDir,2),1);
        if(idx > 0)
            c=c+1;
            subjects(c).subject_id=c;
            subjects(c).subject_species='Macaca';
            subjects(c).subject_name=subjectUniqData(idx).NAME;
            subjects(c).subject_name_abbr=subjectUniqData(idx).ID_Alpha;
            subjects(c).subject_data_dir=dataDir;
            if(strcmpi('y',subjectDirs(ii).Active_))
                subjects(c).subject_is_active=1;
            else
                subjects(c).subject_is_active=0;
            end
            subjects(c).subject_dob=xls2mdatestr(subjectUniqData(idx).DOB);
            subjects(c).subject_acquisition_date=xls2mdatestr(subjectUniqData(idx).ACQUISITION_DATE);
            subjects(c).subject_dod=xls2mdatestr(subjectUniqData(idx).D_O_D_);
            subjects(c).subject_gender='U';
        end
    end
end
%%
function [dstr] = xls2mdatestr(xdate)
    if(isnumeric(xdate) && ~isnan(xdate))
        dstr=datestr(x2mdate(xdate),'yyyy-mm-dd');
    else
        dstr=NaN;
    end
end
%%
function [subjectUniqData,uniqNames,allData] = getSubjectData(xlsFile, xlsSheet,colNamesRowNum)
    allData=xls2struct(xlsFile,xlsSheet,colNamesRowNum);
    uniqNames=unique(cellfun(@(x) regexprep(char(x),'\s+$',''),{allData.NAME},'UniformOutput',false))';
    % find data once for subject to populate subject fields
    uniqData=@(x) allData(find(strcmpi({allData.NAME},x)==1,1));
    subjectUniqData=cellfun(uniqData, uniqNames,'UniformOutput',false);
    subjectUniqData=[subjectUniqData{:}]';
end