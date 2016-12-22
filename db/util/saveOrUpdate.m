function [ dbRows] = saveOrUpdate(tblName,colNames,colValues, varargin)
%SAVEORUPDATE Inserts or Updates a row in a database table. 
%      conn: Connection object required in global space
%      varargin: Is for where clause.... not yet... 
%   Detailed explanation goes here
global conn;

insert(conn,tblName,colNames,colValues);

% insert(conn,'subject',colnames,subsTable);
% update(conn,'subject',{'subject_species'},{'Macaca'},'where subject_id=subject_id');

cursor=exec(conn,'select * from person');

dbRows=cursor2struct(cursor);

end

