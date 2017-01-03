function [ dbRecs] = saveOrUpdate(tableName, objectStruct)
%SAVEORUPDATE Inserts or Updates a row in a database table. 
%      conn: Connection object required in global space 
%   Detailed explanation goes here
    global conn;

    dbRecs= fetchRecords(tableName,objectStruct);

    if( isempty(dbRecs))
        colValues=struct2table(objectStruct);
        colNames=fieldnames(objectStruct);
        insert(conn,tableName,colNames,colValues);
        dbRecs=fetchRecords(tableName,objectStruct);
    end

    % insert(conn,'subject',colnames,subsTable);
    % update(conn,'subject',{'subject_species'},{'Macaca'},'where subject_id=subject_id');

end
