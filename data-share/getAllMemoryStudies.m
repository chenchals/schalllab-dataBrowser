function [ studiesStruct, dataStruct, studies] = getAllMemoryStudies()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  global conn
  studyTemplate=Study();
  studyTemplate.description={'Memory','MG'};
  studies=Study.fetchMatchingRecords(studyTemplate);
  
  %Specific files by subject:
  studiesStruct=struct();
  dataStruct=struct();
  subjectInitials=unique({studies.subject_initials});
  for ii=1:length(subjectInitials)
      subject=char(subjectInitials(ii));
      subjectStudies=findobj(studies,'subject_initials',subject);
      studiesStruct.(subject)=arrayfun(@(x) [x.data_dir filesep x.data_file],subjectStudies,'UniformOutput',false);
      [~,file,~]=fileparts(subjectStudies(1).data_file);
      dataStruct.(regexprep(file,'-','_'))=load([subjectStudies(1).data_dir filesep subjectStudies(1).data_file],'-mat');
  end
  
end

