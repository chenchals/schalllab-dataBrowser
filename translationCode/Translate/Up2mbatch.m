% Cp2mbatch.m
% converts a stack of PDP11-files into Matlab format


% where to look for PDP11 Files and where to write 

clear all
p_global

file_path = 'c:\data\convert\';
q='''';c=',';qcq=[q c q];

list=[];
cd c:\data\Standard;
list=dir('c:\data\convert\*ef.*');

for i=1:length(list)
   ifile_=deblank(list(i).name)
   
   Updp2mat(file_path,ifile_)
   
end

list=[];
list=dir('c:\data\convert\*acc.*');

for i=1:length(list)
   ifile_=deblank(list(i).name)
   
   Updp2mat(file_path,ifile_)
   
end

list=[];
list=dir('c:\data\convert\*tha.*');

for i=1:length(list)
   ifile_=deblank(list(i).name)
   
   Updp2mat(file_path,ifile_)
   
end