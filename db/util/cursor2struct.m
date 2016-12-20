function [ outStruct ] = cursor2struct( dbCursor )
%CURSOR2STRUCT Convert database result set to struct

  curs=dbCursor.fetch;
  dat=curs.Data;
  cols=columnnames(curs,true);
  outStruct = cell2struct(dat',cols);

end

