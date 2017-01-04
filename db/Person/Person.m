classdef Person < DbClass
    %PERSON Object of class Person
    
    properties
        person_id;
        initials;
        firstname;
        lastname;
        email;
    end
    
    properties (Hidden = true)
        tableName = 'person';
        className = mfilename('class');
        mapColumns2Properties = containers.Map(...
            {'person_id','initials','firstname','lastname','email'},...
            {'person_id','initials','firstname','lastname','email'}...
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
    
    methods (Static)
        
        function [ object ] = asObject(dbStruct)
            object = asObject@DbClass(mfilename('class'),dbStruct);
        end
        
        function [ object ] = fetchDbRecords()
            object = fetchDbRecords@DbClass(mfilename('class'));
        end
        
    end
    
end


