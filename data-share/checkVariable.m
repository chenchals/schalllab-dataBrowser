function [ ] = checkVariable( varNames, subjectIds)
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
            vars = who('-file', dataFile);
            for kk=1:numel(varNames)
                varName = char(varNames(kk));
                try
                    ind = contains(vars,varName);
                    temp = load(dataFile,'-mat',varName);
                    matSize=num2str(size(temp.(varName)));
                    maxVal= num2str(nanmax(temp.(varName)));
                    logger.info(sprintf('%s - varName: %s size: %s nanmaxVal: %s',dataFile,char(vars(ind)),matSize, maxVal));
                catch ME
                    logger.error(ME);
                    logger.error(sprintf('***%s*** Processing Failed',dataFile));
                    continue;
                end
            end
        end        
    end

end

