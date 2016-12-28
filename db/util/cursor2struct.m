function [ outStruct ] = cursor2struct( dbCursor )
%CURSOR2STRUCT Convert database result set to table
    setdbprefs('DataReturnFormat','table');
    curs=fetch(dbCursor);
    dat=curs.Data;
    %cols=columnnames(curs,true);
    outStruct=table2struct(dat);
end

