classdef Person < DbClass
    %Person Class Person encpsulates lab person
    % This is a sub-class of DbClass that provides most of the
    % functionality for marshall instances of this class to and from
    % database. It implements the abstarct properties that map this class
    % to a table in the database. The names of class properties and
    % corresponding names of columns in databse table are mapped in a
    % hidden variable.  While these values are same, it need not be the
    % same. See also DbClass
    %
    % Person Properties:
    %    person_id  - INT Populated by database
    %    initials   - CHAR Lab person initials
    %    firstname  - CHAR Lab person firstname
    %    lastname   - CHAR Lab person lastname
    %    email      - CHAR Lab person email
    %
    % Person Methods:
    %    Person   - Constructor
    %    save     - Save the curent person instance
    %
    % Person Methods (Static):
    %    saveAllRecords       - Save all instance objects to database
    %    fetchAllRecords      - Fetch all records from database
    %    fetchMatchingRecords - Fetch matching records from database
    %    toClass              - Transform Matlab struct to class instance(s)
    %    toStruct             - Transform class instance(s) to Matlab struct
    %    toTable              - Transform class instance(s) to Matlab table
    %
    
    % Instance Properties
    properties
        person_id; % INT Populated by database. Is primary key.
        initials; % CHAR Lab person initials
        firstname; % CHAR Lab person firstname
        lastname; % CHAR Lab person lastname
        email; % CHAR Lab person email
    end
    
    % Hidden properties
    properties (Hidden = true)
        %tableName -  Database table name
        tableName = 'person';
        %className - Name of this class
        className = mfilename('class');
        %mapColumns2Properties - Map column names to property names
        mapColumns2Properties = containers.Map(...
            {'person_id','initials','firstname','lastname','email'},... % column names
            {'person_id','initials','firstname','lastname','email'}... % property names
            );
    end
    
    % Class Instance Methods
    methods
        function object = Person()
            %PERSON Constructor
        end
        
        function [ object ] = save(object)
            %SAVE  Save or update Person object
            if(isa(object,'Person'))
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


