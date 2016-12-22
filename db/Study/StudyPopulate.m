function [ studies ] = StudyPopulate(studyMatfile)
%SUBJECTPOPULATE Populate the Study structure that can be used for
%                updating/inserting data into Study table in MySQL Database
%   studyMatfile : The matlab file for the study

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
            studies(c).subject_id=c;
            studies(c).subject_species='Macaca';
            studies(c).subject_name=subjectUniqData(idx).NAME;
            studies(c).subject_name_abbr=subjectUniqData(idx).ID_Alpha;
            studies(c).subject_data_dir=dataDir;
            if(strcmpi('y',subjectDirs(ii).Active_))
                studies(c).subject_is_active=1;
            else
                studies(c).subject_is_active=0;
            end
            studies(c).subject_dob=xls2mdatestr(subjectUniqData(idx).DOB);
            studies(c).subject_acquisition_date=xls2mdatestr(subjectUniqData(idx).ACQUISITION_DATE);
            studies(c).subject_dod=xls2mdatestr(subjectUniqData(idx).D_O_D_);
            studies(c).subject_gender='U';
        end
    end
end

%% Excel date number to String (yyyy-mm-dd format is autoboxed to Date by MySQL)
function [dstr] = xls2mdatestr(xdate)
    if(isnumeric(xdate) && ~isnan(xdate))
        dstr=datestr(x2mdate(xdate),'yyyy-mm-dd');
    else
        dstr=NaN;
    end
end

%% Read Excel file and make the column names to be fieldnames 
function [subjectUniqData,uniqNames,allData] = getSubjectData(xlsFile, xlsSheet,colNamesRowNum)
    allData=xls2struct(xlsFile,xlsSheet,colNamesRowNum);
    uniqNames=unique(cellfun(@(x) regexprep(char(x),'\s+$',''),{allData.NAME},'UniformOutput',false))';
    % find data once for subject to populate subject fields
    uniqData=@(x) allData(find(strcmpi({allData.NAME},x)==1,1));
    subjectUniqData=cellfun(uniqData, uniqNames,'UniformOutput',false);
    subjectUniqData=[subjectUniqData{:}]';
end