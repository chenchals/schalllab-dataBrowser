function [ persons ] = PersonPopulate()
%PERSONPOPULATE Populate the Person structure that can be used for
%                updating/inserting data into Person table in MySQL Database
%   Detailed explanation goes here
    personList={
    {'RH','Rich','Heitz','richard.heitz@gmail.com'},...
    {'JC','Jeremiah','Cohen','jeremiah.cohen@gmail.com'},...
    {'GW','Geoff','Woodman','geoffrey.f.woodman@vanderbilt.edu'},...
    {'BP','Braden','Purcell','braden@nyu.edu'},...
    {'DG','David','Godlove','david.godlove@nih.gov'},...
    {'UI','Unknown','Investigator','unknown.investigator@schalllab'}...
    };
    count = 0;
    for ii = length(personList):-1:1
        p=personList{ii};
        persons(count+ii)=createPerson(p{1},p{2},p{3},p{4});
    end
    
end

function [ person ] = createPerson(initials,firstname, lastname,email)
   person = Person();
   person.initials = upper(initials);
   person.firstname = firstname;
   person.lastname = lastname;
   person.email = email;
   person = person.save;
end