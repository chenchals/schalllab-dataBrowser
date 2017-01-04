%% Populate study table
% this script is necessary to repopulate the study table.
% Also, code to process is not complete, as not all patterns are used when
% processing file metadata

%% Euler
% % RH
% eulerSAT=StudyPopulate('/Volumes/schalllab/data','Euler','SAT/Matlab/*.mat');
% %24

% %save Euler metedata
% save('Study/data/EulerStudies.mat','-regexp', 'euler*','-append');

%% Darwin
% % RH
% darwinSAT=StudyPopulate('/Volumes/schalllab/data','Darwin','SAT/Matlab/*.mat');
% %40

% %save Darwin metadata...
% save('Study/data/DarwinStudies.mat','-regexp', 'darwin*','-append');

%% Quincy
% %RH
% quincySAT=StudyPopulate('/Volumes/schalllab/data','Quincy','SAT/Matlab/*.mat');
% %40
% quincySAT_SEF=StudyPopulate('/Volumes/schalllab/data','Quincy','SAT_SEF/Matlab/*.mat');
% %10
% %RH, JC
% quincyTL=StudyPopulate('/Volumes/schalllab/data','Quincy','TL/Matlab/*.mat');
% %278
% %RH, JC
% quincyTLmicrostim=StudyPopulate('/Volumes/schalllab/data','Quincy','TLmicrostim/Matlab/*.mat');
% %19
% %RH, JC, BP
% quincyPopOut=StudyPopulate('/Volumes/schalllab/data','Quincy','PopOut/Matlab/*.mat');
% %47


% %save Quincy metedata
% save('Study/data/QuincyStudies.mat','-regexp', 'quincy*','-append');


 %% Seymour
% %RH
% seymourSAT=StudyPopulate('/Volumes/schalllab/data','Seymour','SAT/Matlab/*.mat');
% %36
% %RH
% seymourTL=StudyPopulate('/Volumes/schalllab/data','Seymour','TL/Matlab/*.mat');
% %92
% %RH
% seymourTLmicrostim=StudyPopulate('/Volumes/schalllab/data','Seymour','TLmicrostim/Matlab/*.mat');
% %33
% %BP
% seymourPopOut=StudyPopulate('/Volumes/schalllab/data','Seymour','Pop-out/Matlab/*.mat');
% %34


% %save Seymour metedata
% save('Study/data/SeymourStudies.mat','-regexp', 'seymour*','-append');


 