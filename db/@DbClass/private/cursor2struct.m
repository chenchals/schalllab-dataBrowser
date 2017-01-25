function [ outStruct ] = cursor2struct( dbCursor )
%CURSOR2STRUCT Convert database result set to table
    
   if(contains(char(dbCursor.Message),'Invalid connection'))
      me = MException('DbClass:cursor2struct',...
          'Invalid connection. Check batabase global connection object (global conn) exists and is valid');
      throw(me);
   end 
    setdbprefs('DataReturnFormat','table');
    curs = fetch(dbCursor);
    dat = curs.Data;
    if( isequal(dat{1,1},'No Data') )
        outStruct =[ ];
    else
        outStruct = table2struct(dat);
    end
end

