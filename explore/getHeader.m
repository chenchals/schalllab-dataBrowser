function [ out ] = getHeader( dirLocation )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   flist=scanForDatafiles(dirLocation);
   for ii=length(flist):-1:1
     out(ii).fn=flist(ii);
     tmp=load(char(flist(ii)),'-mat','Header_');
     out(ii).header=tmp.Header_;
   end
   out=table2struct(sortrows(struct2table(out),'header','descend'));
  
end

