function [ studies ] = StudyPopulate(baseDataDir, subjectName, subDirMask)
%STUDYPOPULATE Populate the Study structure that can be used for
%                updating/inserting data into Study table in MySQL Database
%   Detailed explanation goes here
    locationOfDatafiles = [baseDataDir,filesep,subjectName,filesep,subDirMask];
    datafiles = scanForDatafiles(locationOfDatafiles);
    
    subject = getObject('Subject',subjectName,'name');    
    persons = Person.fetchDbRecords;
    
    % The date number in filename varies as yyyymmdd or mmddyy
   
    for ii=1:length(datafiles)
        dfile=char(datafiles{ii});
        [dirName, fileName, ext] = fileparts(dfile);
        dfObj=dir(dfile);
        study=Study();
        study.subject_initials=subject.initials;
        study.person_initials=getPersonInitials(fileName,persons);
        study.data_dir=dirName;
        study.data_file=[fileName,ext];
        study.file_date=datestr(dfObj.datenum,'yyyy-mm-dd');
        study.study_date=getStudyDateFromFile(fileName);
        study.description=getDescriptionFromFile(fileName);
        studies(ii)=study.save;
        %studies(ii)=s;
        
    end
end

function [ desc ] = getDescriptionFromFile(fileNameNoExt)
    % based on parts of the file
    % examples: 'zap_SEF_chan13', 'MG', 'SEARCH', ...
    p=regexp(fileNameNoExt,'_(?<desc>[a-zA-Z_\d]*)$','once','names');
    desc=p.desc;
end

function [ studyDate ] = getStudyDateFromFile(fileNameNoExt)
    % based on parts of the file
    % examples:  yyyymmdd or mmddyy
    p=regexp(fileNameNoExt,'[a-zA-Z]*(?<studyDate>\d*).*$','once','names');
    l=length(p.studyDate);
    if(l == 8 || l == 11) % yyyymmdd001  etc
        studyDate=datestr(datenum(p.studyDate(1:8),'mmddyy'),'yyyy-mm-dd');
    elseif (l == 6 || l == 9) % mmddyy001 etc
         studyDate=datestr(datenum(p.studyDate(1:6),'mmddyy'),'yyyy-mm-dd');   
    end
end

function [ personInitials ] = getPersonInitials(fileNameNoExt,persons)
    % based on parts of the file
    p=regexp(fileNameNoExt,'.*[_-](?<initials>[A-Z]{2})[_-].*$','once','names');
    if(isempty(p) || isempty(persons))
       personInitials = 'UI'; % Unknown Investigator in person table     
    elseif(contains(p.initials,{persons.initials}))
       personInitials = p.initials;
    else %not found
         personInitials = 'UI'; % Unknown Investigator in person table     
    end
end

function [ object ] = getObject(className, nameValue, propertyName)
   % get database subject id
     object=eval([className,'();']);
     object.(propertyName)=nameValue;
     object=object.save;
end
