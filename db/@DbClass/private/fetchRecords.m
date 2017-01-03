function [ dbRecords ] = fetchRecords(tableName, varargin)
%FETCHRECORDS Summary of this function goes here
%   Detailed explanation goes here
    global conn
    nVarargs=length(varargin);
    if(nVarargs==1)
        clauses = whereClause(varargin{1});
    else
        clauses='';
    end
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