classdef Person < DbClass
    %PERSON Object of class Person
    
    properties
        id;
        firstname;
        lastname;
        email;
    end
    
    properties
        tableName='person';
        mapColumns2Properties = containers.Map(...
            {'person_id','person_firstname','person_lastname','person_email'},...
            {'id','firstname','lastname','email'}...
            );
    end
    
    methods
        % Constructor
        function object = Person(id, firstname, lastname, email)
            object.id = id;
            object.firstname = firstname;
            object.lastname = lastname;
            object.email = email;
        end
        
        % save or update Person object
        function [ object ] = dbSaveOrUpdate(object)
            objStruct = asDbStruct(object);
            dbStruct = saveOrUpdate('person',objStruct);
            object.id = dbStruct.person_id ;
            object.firstname = dbStruct.person_firstname;
            object.lastname = dbStruct.person_lastname;
            object.email = dbStruct.person_email;
        end
        
        function [ dbStruct ] = getAsDbStruct(object)
            dbStruct = asDbStruct(object);           
        end
        
    end
    
%     methods (Access='private')
%         % Person table columnnames
%         function  [objStruct] = asDbStruct(object)
%             objStruct.person_id = object.id;
%             objStruct.person_firstname = object.firstname;
%             objStruct.person_lastname = object.lastname;
%             objStruct.person_email = object.email;
%         end
%     end
end


