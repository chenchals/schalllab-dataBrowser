function [ persons ] = PersonPopulate()
%PERSONPOPULATE Populate the Person structure that can be used for
%                updating/inserting data into Person table in MySQL Database
%   Detailed explanation goes here
    personList={
    {'XXRH','Rich','Heitz','richard.heitz@gmail.com'},...
    {'XXJC','Jeremiah','Cohen','jeremiah.cohen@gmail.com'},...
    {'XXGW','Geoff','Woodman','geoffrey.f.woodman@vanderbilt.edu'},...
    {'XXBP','Braden','Purcell','braden@nyu.edu'},...
    {'XXDG','David','Godlove','david.godlove@nih.gov'},...
    {'XXUI','Unknown','Investigator','unknown.investigator@schalllab'}...
    };
    count = 0;
    for ii = length(personList):-1:1
        p = personList{ii};
        person = createPerson(p{1},p{2},p{3},p{4});
       % save individually    
        %persons(count+ii) = person.save;
       persons(count+ii) = person;
    end
    
end

function [ person ] = createPerson(initials,firstname, lastname,email)
   person = Person();
   person.initials = upper(initials);
   person.firstname = firstname;
   person.lastname = lastname;
   person.email = email;
end