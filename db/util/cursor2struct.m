function [ outStruct ] = cursor2struct( dbCursor )
%CURSOR2STRUCT Convert database result set to struct
    setdbprefs('DataReturnFormat','table');
    curs=fetch(dbCursor);
    dat=curs.Data;
    %cols=columnnames(curs,true);
    outStruct=table2struct(dat);
end

