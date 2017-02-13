%% Populate study table
% this script is necessary to repopulate the study table.
% Also, code to process is not complete, as not all patterns are used when
% processing file metadata
% % global conn
% % conn=database('schalllab','schalllabadmin','!','Vendor','MySQL','Server','129.59.231.27', 'PortNumber', 6603);

%% Andy andfef
% % Unknown
%andyAll=StudyPopulate('/Volumes/schalllab/data','andy','/andfef/Misc/Matlab/andfef*','Unknown');
% %495
%cellfun(@(dt,f,ds) [dt,' : ',f,' : ', ds], {andyAll.study_date},{andyAll.data_file},{andyAll.description}, 'UniformOutput',false)
% %save Andy metadata
%save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/AndfefAllUnknown.mat','-regexp', 'andyAll', '-append');

%% Fechner fecfef
% % Unknown
%fecfefAll=StudyPopulate('/Volumes/schalllab/data','Fechner','/fecfef/MatlabDataFiles/fecfef*.mat','Unknown');
% %110
%cellfun(@(dt,f,ds) [dt,' : ',f,' : ', ds], {fecfefAll.study_date},{fecfefAll.data_file},{fecfefAll.description}, 'UniformOutput',false)
% %save Fechner metadata
%save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/FecfefAllUnknown.mat','-regexp', 'fecfefAll', '-append');

%% Broca
% % PM
brocaCcm=StudyPopulate('/Volumes/schalllab/data','Broca','/bp*.mat','Paul','bp.*\d{2}(-pm)?.mat');
% %568
%cellfun(@(dt,f,ds) [dt,' : ',f,' : ', ds], {brocaCcm.study_date},{brocaCcm.data_file},{brocaCcm.description}, 'UniformOutput',false)
% %save Broca metadata
--save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/BrocaStudiesPaul.mat','-regexp', 'broca*','-append');

%% Xena
% % PM
%xenaCcm=StudyPopulate('/Volumes/schalllab/data','Xena','Plexon/*.mat','Paul','xp\d{3}n\d{2}((-tp)|(-tp-\d{2}))?.mat');
% %194
%cellfun(@(dt,f,ds) [dt,' : ',f,' : ', ds], {xenaCcm.study_date},{xenaCcm.data_file},{xenaCcm.description}, 'UniformOutput',false)
% %save Xena metadata
%save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/XenaStudiesPaul.mat','-regexp', 'xena*','-append');
%% Joule
% % PM
% jouleCcm=StudyPopulate('/Volumes/schalllab/data','Joule','','Paul');
% %194
%cellfun(@(dt,f,ds) [dt,' : ',f,' : ', ds], {jouleCcm.study_date},{jouleCcm.data_file},{jouleCcm.description}, 'UniformOutput',false)
% %save Joule metadata
% save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/JouleStudiesPaul.mat','-regexp', 'joule*','-append');

%% Euler
% % RH
% eulerSAT=StudyPopulate('/Volumes/schalllab/data','Euler','SAT/Matlab/*.mat', 'Rich');
% %24

% %save Euler metedata
% save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/EulerStudies.mat','-regexp', 'euler*','-append');

%% Darwin
% % RH
% darwinSAT=StudyPopulate('/Volumes/schalllab/data','Darwin','SAT/Matlab/*.mat', 'Rich');
% %40

% %save Darwin metadata...
% save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/DarwinStudies.mat','-regexp', 'darwin*','-append');

%% Quincy
% %RH
% quincySAT=StudyPopulate('/Volumes/schalllab/data','Quincy','SAT/Matlab/*.mat', 'Rich');
% %40
% quincySAT_SEF=StudyPopulate('/Volumes/schalllab/data','Quincy','SAT_SEF/Matlab/*.mat', 'Rich');
% %10
% %RH, JC
% quincyTL=StudyPopulate('/Volumes/schalllab/data','Quincy','TL/Matlab/*.mat');
% %278
% %RH, JC
% quincyTLmicrostim=StudyPopulate('/Volumes/schalllab/data','Quincy','TLmicrostim/Matlab/*.mat', 'Rich');
% %19
% %RH, JC, BP
% quincyPopOut=StudyPopulate('/Volumes/schalllab/data','Quincy','PopOut/Matlab/*.mat', 'Rich');
% %47
% %RH
% quincyOrientDiscrim=StudyPopulate('/Volumes/schalllab/data','Quincy','OrientDiscrim/Matlab/*.mat', 'Rich');
% %2


% %save Quincy metedata
% save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/QuincyStudies.mat','-regexp', 'quincy*','-append');


 %% Seymour
% %RH
% seymourSAT=StudyPopulate('/Volumes/schalllab/data','Seymour','SAT/Matlab/*.mat', 'Rich');
% %36
% %RH
% seymourTL=StudyPopulate('/Volumes/schalllab/data','Seymour','TL/Matlab/*.mat', 'Rich');
% %92
% %RH
% seymourTLmicrostim=StudyPopulate('/Volumes/schalllab/data','Seymour','TLmicrostim/Matlab/*.mat'), 'Rich';
% %33
% %BP
% seymourPopOut=StudyPopulate('/Volumes/schalllab/data','Seymour','Pop-out/Matlab/*.mat', 'Rich');
% %34


% %save Seymour metedata
% save('/Users/subravcr/Projects/schalllab-dataBrowser/db/populateDb/data/SeymourStudies.mat','-regexp', 'seymour*','-append');


 