classdef Subject < DbClass
    %Subject Object of class Subject
    
    properties
        id;
        species;
        name;
        name_abbr;
        data_dir;
        is_active;
        dob;
        acquisition_date;
        dod;
        gender;
    end

    properties (Hidden=true)        
        tableName='subject';
        mapColumns2Properties = containers.Map(...
            {'subject_id','subject_species','subject_name','subject_name_abbr','subject_data_dir','subject_is_active','subject_dob','subject_acquisition_date','subject_dod','subject_gender'},...
            {'id','species','name','name_abbr','data_dir','is_active','dob','acquisition_date','dod','gender'}...
            );
    end
    
    methods
        % Constructor
        function [ object ] = Subject()
            
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


