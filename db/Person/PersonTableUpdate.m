function [ dbPersons ] = PersonTableUpdate()
%INSERTPERSONS Populate the Subject structure that can be used for
%                updating/inserting data into Subject table in MySQL Database
%   Detailed explanation goes here


%% Update all persons
% Create a global conn object in workspace
global conn;

saveOrUpdate('person', ...
    {'person_id', 'person_firstname', 'person_lastname', 'person_email'},...
    {1, 'Rich', 'Hietz', 'richard.heitz@gmail.com'}...
    );


end

function [ person ] = createPerson(fn, ln, email)
  person.person_firstname=fn;
  person.person_lastname=ln;
  person.person_email=email;
end





