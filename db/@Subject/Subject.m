classdef Subject < DbClass
    %SUBJECT Class Subject encpsulates monk
    % This is a sub-class of DbClass that provides most of the
    % functionality for marshall instances of this class to and from
    % database. It implements the abstarct properties that map this class
    % to a table in the database. The names of class properties and
    % corresponding names of columns in databse table are mapped in a
    % hidden variable.  While these values are same, it need not be the
    % same. See also DbClass
    %
    % Subject Properties:
    %   subject_id        - INT Populated by database
    %   name              - CHAR Monk Name
    %   initials          - CHAR Monk Abbrev
    %   species           - CHAR Monk species
    %   data_dir          - CHAR Monk Directory name for data
    %   is_active         - CHAR Monk Being used in studies
    %   dob               - DATE Monk DOB
    %   acquisition_date  - DATE Monk Date acquired
    %   dod               - DATE Monk DOD
    %   gender            - CHAR Monk Gender
    %
    % Subject Methods:
    %    Person   - Constructor
    %    save     - Save the curent subject instance
    %
    % Subject Methods (Static):
    %    saveAllRecords   - Save all instance objects to database
    %    fetchAllRecords  - Fetch all records from database
    %    toClass          - Transform Matlab struct to class instance(s)
    %    toStruct         - Transform class instance(s) to Matlab struct
    %    toTable          - Transform class instance(s) to Matlab table
    %
    
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
        tableName='subject'; %tableName -  Database table name
        className=mfilename('class'); %className - Name of this class
        %mapColumns2Properties - Map column names to property names
        mapColumns2Properties = containers.Map(...
            {'subject_id','name','initials','species','data_dir','is_active','dob','acquisition_date','dod','gender'},...
            {'subject_id','name','initials','species','data_dir','is_active','dob','acquisition_date','dod','gender'}...
            );
    end
    
    % Class Instance Methods
    methods
        function object = Subject()
            %SUBJECT Constructor
        end
        
        function [ object ] = save(object)
            %SAVE  Save or update Subject object
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


