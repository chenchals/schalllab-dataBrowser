classdef Person < DbClass
    %PERSON Object of class Person
    
    properties
        id;
        firstname;
        lastname;
        email;
    end
    
    properties (Hidden=true)
        tableName='person';
        mapColumns2Properties = containers.Map(...
            {'person_id','person_firstname','person_lastname','person_email'},...
            {'id','firstname','lastname','email'}...
            );
    end
    
    methods
        % Constructor
        function object = Person()
        end
        
        % save or update Person object
        function [ object ] = save(object)
            object = dbSaveOrUpdate(object);
        end
        
        function [ dbStruct ] = getAsDbStruct(object)
            dbStruct = asDbStruct(object);
        end
        
    end

end


