function [ dbRecords ] = fetchRecords(tableName, varargin)
%FETCHRECORDS Summary of this function goes here
%   Detailed explanation goes here
    global conn
    nVarargs = length(varargin);
    if(nVarargs == 1)
        clauses = whereClause(varargin{1});
    else
        clauses =' ';
    end
    sql = char(join({'select * from',tableName,clauses},' '));
    cursor = exec(conn,sql);
    dbRecords = cursor2struct(cursor);
end

function [clause] = whereClause(objectStruct)
% Create a where clause array with field names that have values that are
% not empty or NaN
  cols = fieldnames(objectStruct);
  count = 0;
  for ii = 1:length(cols)
      col = char(cols(ii));
      value = objectStruct.(col);
      if iscellstr(value)
           count = count+1;
          clauseArr{count} = getClauseStr(col, value);        
      elseif ~(isempty(value) || sum(isnan(value)))
          count = count+1;
          clauseArr{count} = getClauseStr(col, value);
      end
  end  
  clause = char(join(['where' join(clauseArr,' and ')],' ')); 
end

function [ valueString ] = getClauseStr(col, value)
  
  if ischar(value)
      if(contains(value,'%'))
          valueString = [ 'lower(',col, ') LIKE lower(''',value,''')'];
      else
          valueString = [ 'lower(',col, ')=lower(''',value,''')'];
      end
  elseif iscellstr(value)
      valueString = ['lower(',col, ') IN (''' strjoin(lower(value),''',''') ''')'];
      
  else% assume integer
      valueString = [ 'lower(',col, ')=lower(''',num2str(value),''')'];
  end
end