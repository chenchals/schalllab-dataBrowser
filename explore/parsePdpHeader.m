function [ varArray,availableVarNames ] = parsePdpHeader( fileList )
%PARSEPDPHEADER Same as getVariable, but parses the header value as a struct
%
%   see also GETVARIABLE

   varName='Header_';
   [ varArray,availableVarNames ] = getVariable( fileList,varName );
   for ii=length(varArray):-1:1
      varArray(ii).progname = deblank(varArray(ii).Header_(5:14));
      varArray(ii).eventfile = deblank(varArray(ii).Header_(15:26));
      varArray(ii).stimfile = deblank(varArray(ii).Header_(27:38));
      varArray(ii).acqdate = deblank(varArray(ii).Header_(39:48));
      varArray(ii).acqtime = deblank(varArray(ii).Header_(49:56));
   end
   
   %out=table2struct(sortrows(struct2table(out),'header','descend'));
  
end

