function [ studiesStruct, sampleStruct, studies] = getAllMemoryStudies()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  global conn
  studyTemplate=Study();
  studyTemplate.description={'Memory','MG'};
  studies=Study.fetchMatchingRecords(studyTemplate);
  
  %Specific files by subject:
  studiesStruct=struct();
  sampleStruct=struct();
  subjectInitials=unique({studies.subject_initials});

  for ii=1:length(subjectInitials)
      subject=char(subjectInitials(ii));
      studiesStruct.(subject)=studies(strcmp({studies.subject_initials},subject));
      [~,file,~]=fileparts(studiesStruct.(subject)(1).data_file);
      sampleStruct.(regexprep(file,'-','_'))=load([studiesStruct.(subject)(1).data_dir filesep studiesStruct.(subject)(1).data_file],'-mat');
  end

end

