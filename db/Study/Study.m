classdef Study < DbClass
    %Subject Object of class Subject
    
    properties
        study_id;
        subject_initials;
        person_initials;
        data_dir;
        data_file;
        file_date;
        study_date;
        description;
        comment;
    end
    
    properties (Hidden = true)
        tableName = 'study';
        className = mfilename('class');
        mapColumns2Properties = containers.Map(...
            {'study_id','subject_initials','person_initials','data_dir','data_file','file_date','study_date','description','comment'},...
            {'study_id','subject_initials','person_initials','data_dir','data_file','file_date','study_date','description','comment'}...
            );
    end
    
    methods
        % Constructor
        function [ object ] = Study()
            
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


