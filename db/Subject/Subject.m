classdef Subject < DbClass
    %Subject Object of class Subject
    
    properties
        subject_id;
        name;
        initials;
        species;
        data_dir;
        is_active;
        dob;
        acquisition_date;
        dod;
        gender;
    end

    properties (Hidden=true)        
        tableName='subject';
        className=mfilename('class');
        mapColumns2Properties = containers.Map(...
            {'subject_id','name','initials','species','data_dir','is_active','dob','acquisition_date','dod','gender'},...
            {'subject_id','name','initials','species','data_dir','is_active','dob','acquisition_date','dod','gender'}...
            );
    end
    
    methods
        % Constructor
        function [ object ] = Subject()
            
        end
        
        % save or update Subject object
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


