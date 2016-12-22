%% Update all subjects from excel files
% Create a global conn object in workspace
global conn;
subjects=SubjectPopulate();
subsTable=struct2table(subjects);
colnames=fieldnames(subjects(1));

% insert(conn,'subject',colnames,subsTable);
% update(conn,'subject',{'subject_species'},{'Macaca'},'where subject_id=subject_id');

cursor=exec(conn,'select * from subject');

dbSubjects=cursor2struct(cursor);




