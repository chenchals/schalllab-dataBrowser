classdef Study < DbClass
    %STUDY Class Study encpsulates a datafile characteristics
    % This is a sub-class of DbClass that provides most of the
    % functionality for marshall instances of this class to and from
    % database. It implements the abstarct properties that map this class
    % to a table in the database. The names of class properties and
    % corresponding names of columns in databse table are mapped in a
    % hidden variable.  While these values are same, it need not be the
    % same. See also DbClass
    %
    % Study Properties:
    %   study_id           - INT Populated by database
    %   subject_initials   - CHAR Monk Abbrev
    %   person_initials    - CHAR Person Initials
    %   data_dir           - CHAR Directory where file is present
    %   data_file          - CHAR Name of the datafile
    %   file_date          - DATE Date file was created
    %   study_date         - DATE Date embedded in file name
    %   description        - CHAR Task from datafile..? need more work
    %   comment            - CHAR General comment
    %
    % Study Methods:
    %    Person   - Constructor
    %    save     - Save the curent subject instance
    %
    % Study Methods (Static):
    %    saveAllRecords       - Save all instance objects to database
    %    fetchAllRecords      - Fetch all records from database
    %    fetchMatchingRecords - Fetch matching records from database
    %    toClass              - Transform Matlab struct to class instance(s)
    %    toStruct             - Transform class instance(s) to Matlab struct
    %    toTable              - Transform class instance(s) to Matlab table
    %
    
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
        tableName='study'; %tableName -  Database table name
        className=mfilename('class'); %className - Name of this class
        %mapColumns2Properties - Map column names to property names
        mapColumns2Properties = containers.Map(...
            {'study_id','subject_initials','person_initials','data_dir','data_file','file_date','study_date','description','comment'},...
            {'study_id','subject_initials','person_initials','data_dir','data_file','file_date','study_date','description','comment'}...
            );
    end
    
    % Class Instance Methods
    methods
        function object = Study()
            %STUDY Constructor
        end
        
        function [ object ] = save(object)
            %SAVE  Save or update Study object
            if(isa(object,'Subject'))
                object = save@DbClass(object);
            end
        end
    end
    
    % Class Methods
    methods (Static)
        
        function [ objects ] = saveAllRecords(objects)
            %SAVEALLRECORDS Save all instance objects to database
            objects = DbClass.saveRecords(objects);
        end
        
        function [ objects ] = fetchAllRecords()
            %FETCHALLRECORDS Fetch all records from database
            objects = DbClass.fetchRecords(mfilename('class'));
        end
        
        function [ objects ] = fetchMatchingRecords(object)
            %FETCHMATCHINGRECORDS Fetch matching records from database
            if( length(object) ~= 1 ||  ~isa(object,mfilename('class')))
                error(['Error: Non empty model objects must be instances of class ' mfilename('class')]);
            end
            objects = DbClass.fetchRecordsByModel(object);
        end
        
        function [ objects ] = toClass(classStruct)
            %TOCLASS Transform Matlab struct to class instance(s) where
            %fieldnames = property names
            [ ~, propertyNames ] = DbClass.getKeysValues(eval(mfilename('class')));
            if(~isempty(setdiff(fieldnames(classStruct),propertyNames)))
                error(['Error: Fieldnames in struct contains non-matching property names for class ' mfilename('class')]);
            end
            objects = DbClass.asClass(mfilename('class'),classStruct);
        end
        
        function [ classStruct ] = toStruct(objects)
            %TOSTRUCT Transform class instance(s) to Matlab struct where
            %fieldnames = property names
            if(~isa(objects(1),mfilename('class')))
                error(['Error: All objects must be instances of class ' mfilename('class')]);
            end
            classStruct = DbClass.asStruct(objects);
        end
        
        function [ classTable ] = toTable(objects)
            %TOTable Transform class instance(s) to Matlab table where
            %table columnnames = property names
            if(~isa(objects(1),mfilename('class')))
                error(['Error: All objects must be instances of class ' mfilename('class')]);
            end
            classTable = DbClass.asTable(objects);
        end
        
    end
    
    
end


