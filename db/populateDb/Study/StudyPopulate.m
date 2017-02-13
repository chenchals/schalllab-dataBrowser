function [ studies ] = StudyPopulate(baseDataDir, subjectName, subDirMask, personFirstname,fileFilterRegexp)
%STUDYPOPULATE Populate the Study structure that can be used for
%                updating/inserting data into Study table in MySQL Database
%   Detailed explanation goes here
    locationOfDatafiles = [baseDataDir,filesep,subjectName,filesep,subDirMask];    
        % Filter files if filterRegexp
    if(exist('fileFilterRegexp','var'))
        % for Pauls: '\d{2}(-pm)?.mat$' all files ending in 
        % dd.mat and % dd-pm.mat
        %datafiles(cell2mat(cellfun(@(x) isempty(regexp(x,fileFilterRegexp,'once')),datafiles,'UniformOutput',false)))=[];
        datafiles = scanForDatafiles(locationOfDatafiles,fileFilterRegexp);
    else
        datafiles = scanForDatafiles(locationOfDatafiles);
    end
    
    subject = getObject('Subject','name',subjectName);    
    person = getObject('Person','firstname',personFirstname);
    
    % The date number in filename varies as yyyymmdd or mmddyy
    for ii=1:length(datafiles)
        dfile=char(datafiles{ii});
        disp(['Doing file :' dfile]);
        [dirName, fileName, ext] = fileparts(dfile);
        dfObj=dir(dfile);
        study=Study();
        study.subject_initials=subject.initials;
        study.person_initials=person.initials;
        study.data_dir=dirName;
        study.data_file=[fileName,ext];
        study.file_date=datestr(dfObj.datenum,'yyyy-mm-dd');
        [study_date, description, comment] = getStudyDateAndDescription(dfile, personFirstname);
        study.study_date=study_date;
        study.description=description;
        study.comment = comment;
        studies(ii)=study.save;
        %studies(ii)=study;
        
    end
end

function [ studyDate, description, comment ] = getStudyDateAndDescription(filename, personFirstname)
          studyDate = [];
          description = '';
          comment = '';
  switch personFirstname
      case 'Rich'
          [ studyDate, description ] = getFromFilename(filename);
      case 'Paul'
          [ studyDate, description ] = getFromVarSessionData(filename);
      case 'Unknown' 
           [ studyDate, description, comment ] = getFromPdpHeader(filename);
  end

end

function [ studyDate, description, comment ] = getFromPdpHeader(filename)
   varHeader = loadVariable(filename,'Header_');
   
   comment = varHeader;
   if (startsWith(varHeader,'new'))
       description = '';
       progname  = deblank(varHeader(5:14));
       switch progname
           case char(regexp(progname,'search|cntrst|srch08','match'))
               description = 'Search';
           case 'sstep'
               description = 'Sstep';
           case 'gostop'
               description = 'Gostop';
       end
       
       % Memory guided parse
       stimfile = deblank(varHeader(27:38));
       if startsWith(stimfile,'mem')
          % Check of this is correct for others
          % correct for fecfef
          description = 'Memory';
       else
          % Check of this is correct?
          HOLDT=14; %col 14 is hold time
          varInfos=loadVariable(filename,'Infos_');
          if(max(unique(varInfos(:,HOLDT)))>100)
            description = 'Memory';  
          end
       end
       try
         studyDate = datestr(datenum(deblank(varHeader(39:48)),'dd-mmm-yy'),'yyyy-mm-dd');
       catch err
           disp(err);
           studyDate=[];
       end
   else
       studyDate=[];
       description='';
   end
   if any(comment >127)
       % non ascii in comments
       comment(comment>127)='x';
       comment=['** non-ascii Header_ replaced with x **:' comment];
   end
   

end

function [ studyDate, description ] = getFromFilename(filename)
    % based on parts of the file
    % examples: 'zap_SEF_chan13', 'MG', 'SEARCH', ...
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

function [ studyDate, description ] = getFromVarSessionData(filename)
   % for Paul's data
   varname = 'SessionData';
   studyDate='';
   description='';
   disp(['Doing file :',filename]);
   varSessionData=loadVariable(filename,varname);
   legacyFileName = regexprep(filename,'.mat','_legacy.mat');
   if (sum(isfield(varSessionData,{'date','taskName','task'}))==2 ) %task or taskName
       [studyDate, description] = fromSessionData(varSessionData);
   elseif(exist(legacyFileName,'file')==2)
       [ studyDate, description] = fromHeader(legacyFileName);
   end
      
    %Nested fx : SessionData
    function [studyDate, description] = fromSessionData(varSessionData)
        try
            studyDate = datestr(datenum(varSessionData.date,'dd-mmm-yyyy'),'yyyy-mm-dd');
        catch err
            %other format: date: {? 5/29/2012?} --> some Broca files
            studyDate = datestr(datenum(strtrim(char(varSessionData.date)),'mm/dd/yyyy'),'yyyy-mm-dd');
        end
        if(isfield(varSessionData,'taskName'))
           description = varSessionData.taskName;
        else
           description = varSessionData.task.taskName;
        end
    end
    
    %Nested fx : Header from *_legacy file
    function [studyDate, description] = fromHeader(legacyFileName)
        varHeader=loadVariable(legacyFileName,'Header_');
        if (sum(isfield(varHeader,{'Date_and_Time','Task'}))==2 )
            studyDate = datestr(datenum(varHeader.Date_and_Time,'mm/dd/yyyy'),'yyyy-mm-dd');
            description = varHeader.Task;
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
    v=eval(['load(''',filename,''',''-mat'',''',varname,''')']);
    var=v.(varname);
end
