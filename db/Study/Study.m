classdef Study < DbClass
    %Subject Object of class Subject
    
    properties
        id;
        subject_id;
        person_id;
        data_dir;
        data_file;
        description;
        date;
    end

    properties (Hidden=true)        
        tableName='study';
        className=mfilename('class');
        mapColumns2Properties = containers.Map(...
              {'study_id','subject_id','person_id','study_data_dir','study_data_file','study_description','study_date'},...
              {'id','subject_id','person_id','data_dir','data_file','description','date'}...
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


