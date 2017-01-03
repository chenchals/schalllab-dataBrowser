function [ dbRecs] = saveOrUpdate(tableName, objectStruct)
%SAVEORUPDATE Inserts or Updates a row in a database table. 
%      conn: Connection object required in global space 
%   Detailed explanation goes here
    global conn;

    dbRecs= fetchRecord(tableName,objectStruct);

    if( isempty(dbRecs))
        colValues=struct2table(objectStruct);
        colNames=fieldnames(objectStruct);
        insert(conn,tableName,colNames,colValues);
        dbRecs=fetchRecord(tableName,objectStruct);
    end

    % insert(conn,'subject',colnames,subsTable);
    % update(conn,'subject',{'subject_species'},{'Macaca'},'where subject_id=subject_id');

end

function [ dbRecords ] = fetchRecord(tableName, objectStruct)
   global conn
   clauses = whereClause(objectStruct);
   sql = char(join({'select * from',tableName,clauses},' '));
   cursor=exec(conn,sql);
   dbRecords=cursor2struct(cursor);
end


function [clause] = whereClause(objectStruct)
% Create a where clause array with field names that have values that are
% not empty or NaN
  cols=fieldnames(objectStruct);
  count=0;
  for ii=1:length(cols)
      col=char(cols(ii));
      value=objectStruct.(col);
      if ~(isempty(value) || sum(isnan(value)))
          count=count+1;
          clauseArr{count}=[ 'lower(',col, ')=lower(', getValueStr(value),')'];
      end
  end  
  clause = char(join(['where' join(clauseArr,' and ')],' ')); 
end

function [ valueString ] = getValueStr(value)
  
  if ischar(value)
      valueString=['''',value,''''];
  else % assume integer
      valueString=['''',num2str(value),''''];
      
  end

end
