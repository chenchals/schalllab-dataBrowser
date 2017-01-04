function [ studies ] = StudyPopulate(baseDataDir, subjectName, subDirMask ,personFirstname)
%STUDYPOPULATE Populate the Study structure that can be used for
%                updating/inserting data into Study table in MySQL Database
%   Detailed explanation goes here
    locationOfDatafiles=[baseDataDir,filesep,subjectName,filesep,subDirMask];
    datafiles=scanForDatafiles(locationOfDatafiles);
    
    subject=getObject('Subject',subjectName,'name');    
    person=getObject('Person',personFirstname,'firstname');
   
    for ii=1:length(datafiles)
        df=char(datafiles{ii});
        dfObj=dir(df);
        s=Study();
        [dirName, fileName, ext] = fileparts(df);
        s.data_dir=dirName;
        s.data_file=[fileName,ext];
        s.description=getDescriptionFromFilename(fileName);
        s.subject_id=subject.id;
        s.person_id=person.id;
        s.date=datestr(dfObj.datenum,'yyyy-mm-dd');
        studies(ii)=s.save;
        %studies(ii)=s;
        
    end
end

function [ desc ] = getDescriptionFromFilename(fileName)
    % based on parts of the file
    % examples: 'zap_SEF_chan13', 'MG', 'SEARCH', ...
    p=regexp(fileName,'_(?<desc>[a-zA-Z_\d]*)$','once','names')
    desc=p.desc;
end

function [ object ] = getObject(className, nameValue, propertyName)
   % get database subject id
     object=eval([className,'();']);
     object.(propertyName)=nameValue;
     object=object.save;
end
