function [ outStruct ] = cursor2struct( dbCursor )
%CURSOR2STRUCT Convert database result set to table
    setdbprefs('DataReturnFormat','table');
    curs=fetch(dbCursor);
    dat=curs.Data;
    if( isequal(dat{1,1},'No Data') )
        outStruct=[];
    else
        outStruct=table2struct(dat);
    end
end

