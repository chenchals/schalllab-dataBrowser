function [ studies ] = getAllMemoryStudies()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  global conn
  studyTemplate=Study();
  studyTemplate.description={'Memory','MG'};
  studies=Study.fetchMatchingRecords(studyTemplate);
end

