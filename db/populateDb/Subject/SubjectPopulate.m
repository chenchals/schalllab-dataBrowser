function [ subjects ] = SubjectPopulate()
%SUBJECTPOPULATE Populate the Subject structure that can be used for
%                updating/inserting data into Subject table in MySQL Database
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
            subject.name=subjectUniqData(idx).NAME;
            subject.initials=upper(subjectUniqData(idx).ID_Alpha);
            subject.species='Macaca';
            subject.data_dir=dataDir;
            if(strcmpi('y',subjectDirs(ii).Active_))
                subject.is_active='T';
            else
                subject.is_active='F';
            end
            subject.dob=xls2mdatestr(subjectUniqData(idx).DOB);
            subject.acquisition_date=xls2mdatestr(subjectUniqData(idx).ACQUISITION_DATE);
            subject.dod=xls2mdatestr(subjectUniqData(idx).D_O_D_);
            subject.gender='U';
            s=Subject.asClass(subject);
            subjects(c)=s.save;
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