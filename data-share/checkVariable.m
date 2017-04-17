function [ ] = checkVariable( varName, subjectIds)
%CHECKVARIABLE Summary of this function goes here
%   Detailed explanation goes here
    logger = Logger.getLogger(strcat('temp_',join(subjectIds,'_'),'.log'));
    subjectStudies = getAllMemoryStudies;
    subjects = fieldnames(subjectStudies);
    matchedSubs = ~cellfun(@isempty, regexp(subjects,join(strcat('^',subjectIds,'$'),'|'),'match'));
    %contains(subjects,subs)
    subjects = subjects(matchedSubs);
    for ii = 1:numel(subjects)
        subject = char(subjects(ii));
        studyCount = numel(subjectStudies.(subject));
        studies = subjectStudies.(subject);
        for jj = 1:studyCount
            study = studies(jj);
            dataFile =strcat(study.data_dir,filesep,study.data_file);
            try
                vars = who('-file', dataFile);
                ind = contains(vars,varName);
                logger.info(sprintf('%s - %s',dataFile,char(vars(ind))));
            catch ME
                logger.error(ME);
                logger.error(sprintf('***%s*** Processing Failed',dataFile));
                continue;
            end
        end        
    end

end

