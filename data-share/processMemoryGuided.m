function [ ] = processMemoryGuided( )
%PROCESSMEMORYGUIDED Process all memory guided sessions to create Events
%        and Cells files for sharing data

    % Get all memory studies from database 
    % global conn ==> a connection object is needed in global space
    probeRun=0;
    baseDir = '/Users/subravcr/teba/local/schalllab/memGuidedData/';
    isValidDbConnection;
    subjectStudies = getAllMemoryStudies;
    subjects = fieldnames(subjectStudies);
    for ii = 1:numel(subjects)
        subject = char(subjects(ii));
        subjectDir = strcat(baseDir,subject,filesep);
        mkdir(subjectDir);
        logger = Logger.getLogger(strcat(subjectDir,subject,'_logger.log'));
        logger.info(sprintf('Processing Memory Guided files for subject: %s',subject));
        studies = subjectStudies.(subject);
        studyCount = numel(studies);
        if probeRun
            studyCount = 1
        end
        parfor jj = 1:studyCount
            study = stidies(jj);
            dataFile =strcat(study.data_dir,filesep,study.data_file);
            [~,fn,fe] = fileparts(dataFile);
            fe = char(regexp(fe,'\d*$','match')); % for files ending in digits and not mat
            logger.info(sprintf('Processing file: %s [ %d of %d ]',dataFile,jj,studyCount));
            processDir = strcat(subjectDir,fn,fe,filesep);
            try
                dataShareMemoryGuided(dataFile,processDir,logger);
                logger.info('Processing Successful');
            catch ME
                logger.error(ME);
                logger.error(sprintf('***%s*** Processing Failed',dataFile));
                continue;
            end
        end        
    end
end

function [ valid ] = isValidDbConnection()
    %  vars = whos();
    %  vars=vars([vars.global]==1 & strcmp({vars.name},'conn'));
    global conn;
    try    
        valid = conn.catalogs;
    catch
        %database('schalllab','schalllabadmin','secret','Vendor','MySQL','Server','129.59.231.27', 'PortNumber', 6603)
        throw(MException('processMemoryGuided:isValidDbConnection','Global conn obj is invalid. Create a global ''conn'' variable that can access the MySQL database!'));
    end

end

