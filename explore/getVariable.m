function [ varArray,availableVarNames ] = getVariable( fileList,varName )
%GETVARIABLE Agggregate a variable from each file in fileList
%   
  varArray = struct();
  availableVarNames = struct();
  
  for ii = length(fileList):-1:1
      fn = char(fileList(ii));
      disp(['Checking for file : ' fn ]);
      varArray(ii,1).filename = fn;
      temp=load(fn,'-mat',varName);
      varArray(ii,1).(varName) = temp.(varName);
      availableVarNames(ii,1).filename = fn;
      varNames=who('-file',fn);
      for jj=length(varNames):-1:1
         availableVarNames(ii,1).(char(varNames(jj)))='exists';
      end
       clear temp varnames
  end
  
end

