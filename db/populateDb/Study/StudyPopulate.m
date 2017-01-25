function [ studies ] = StudyPopulate(baseDataDir, subjectName, subDirMask, personFirstname,fileFilterRegexp)
%STUDYPOPULATE Populate the Study structure that can be used for
%                updating/inserting data into Study table in MySQL Database
%   Detailed explanation goes here
    locationOfDatafiles = [baseDataDir,filesep,subjectName,filesep,subDirMask];
    datafiles = scanForDatafiles(locationOfDatafiles);
        % Filter files if filterRegexp
    if(exist('fileFilterRegexp','var'))
        % for Pauls: '\d{2}(-pm)?.mat$' all files ending in 
        % dd.mat and % dd-pm.mat
        datafiles(cell2mat(cellfun(@(x) isempty(regexp(x,fileFilterRegexp,'once')),datafiles,'UniformOutput',false)))=[];
    end
    
    subject = getObject('Subject','name',subjectName);    
    person = getObject('Person','firstname',personFirstname);
    
    % The date number in filename varies as yyyymmdd or mmddyy
   
    for ii=1:length(datafiles)
        dfile=char(datafiles{ii});
        [dirName, fileName, ext] = fileparts(dfile);
        dfObj=dir(dfile);
        study=Study();
        study.subject_initials=subject.initials;
        study.person_initials=person.initials;
        study.data_dir=dirName;
        study.data_file=[fileName,ext];
        study.file_date=datestr(dfObj.datenum,'yyyy-mm-dd');
        [study_date, description] = getStudyDateAndDescription(dfile, personFirstname);
        study.study_date=study_date;
        study.description=description;
        %studies(ii)=study.save;
        studies(ii)=study;
        
    end
end

function [ studyDate, description ] = getStudyDateAndDescription(filename, personFirstname)

  switch personFirstname
      case 'Rich'
          [ studyDate, description ] = getFromFilename(filename);
      case 'Paul'
          [ studyDate, description ] = getFromVariable(filename, 'SessionData');
      case 'Unknown' 
          studyDate = '';
          description = '';
  end

end

function [ studyDate, description ] = getFromFilename(filename)
    % based on parts of the file
    % examples: 'zap_SEF_chan13', 'MG', 'SEARCH', ...
    description = '';
    studyDate = '';
    [~,fileNameNoExt,~] = fileparts(filename);
    p=regexp(fileNameNoExt,'_(?<desc>[a-zA-Z_\d]*)$','once','names');
    description=p.desc;
    % examples:  yyyymmdd or mmddyy
    p=regexp(fileName,'[a-zA-Z]*(?<studyDate>\d*).*$','once','names');
    l=length(p.studyDate);
    if(l == 8 || l == 11) % yyyymmdd001  etc
        studyDate=datestr(datenum(p.studyDate(1:8),'mmddyy'),'yyyy-mm-dd');
    elseif (l == 6 || l == 9) % mmddyy001 etc
         studyDate=datestr(datenum(p.studyDate(1:6),'mmddyy'),'yyyy-mm-dd');   
    end    
end

function [ studyDate, description ] = getFromVariable(filename, varname)
   % for Paul's data
   studyDate='';
   description='';
   disp(['Doing file :',filename]);
   var=loadVariable(filename,varname);
   legacyFile = regexprep(filename,'.mat','_legacy.mat');
   if (sum(isfield(var,{'date','taskName'}))==2 )
       [ studyDate, description] = fromVarSessionData();
   elseif(exist(legacyFile,'file')==2)
       [ studyDate, description] = fromVarHeader();
   end
      
    %SessionData
    function [studyDate, description] = fromVarSessionData()
        try
            studyDate = datestr(datenum(var.date,'dd-mmm-yyyy'),'yyyy-mm-dd');
        catch err
            %other format: date: {? 5/29/2012?} --> some Broca files
            studyDate = datestr(datenum(strtrim(char(var.date)),'mm/dd/yyyy'),'yyyy-mm-dd');
        end
        description = var.taskName;
    end

    function [studyDate, description] = fromVarHeader()
        var=loadVariable(legacyFile,'Header_');
        if (sum(isfield(var,{'Date_and_Time','Task'}))==2 )
            studyDate = datestr(datenum(var.Date_and_Time,'mm/dd/yyyy'),'yyyy-mm-dd');
            description = var.Task;
        end
    end
end

function [ object ] = getObject(className, propertyName, provertyValue)
   % get database subject id
     object=eval([className,'();']);
     object.(propertyName)=provertyValue;
     object=object.fetchMatchingRecords(object);
end

function [var] = loadVariable(filename,varname)
    v=eval(['load(''',filename,''',''',varname,''')']);
    var=v.(varname);
end
