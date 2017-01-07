classdef Publication < DbClass
    %PUBLICATION Class Publication encpsulates a publication
    % This is a sub-class of DbClass that provides most of the
    % functionality for marshall instances of this class to and from
    % database. It implements the abstarct properties that map this class
    % to a table in the database. The names of class properties and
    % corresponding names of columns in databse table are mapped in a
    % hidden variable.  While these values are same, it need not be the
    % same. See also DbClass
    %
    % Publication Properties:
    %   publication_i     - INT Populated by database
    %   category          - CHAR Publication category (from web page)
    %   citation          - CHAR Publication full ref Abbrev
    %   pdf_url           - CHAR Publication pdf URL species
    %   year              - INT  Publication year
    %
    % Publication Methods:
    %    Publication   - Constructor
    %    save     - Save the curent Publication instance
    %
    % Publication Methods (Static):
    %    saveAllRecords       - Save all instance objects to database
    %    fetchAllRecords      - Fetch all records from database
    %    fetchMatchingRecords - Fetch matching records from database
    %    toClass              - Transform Matlab struct to class instance(s)
    %    toStruct             - Transform class instance(s) to Matlab struct
    %    toTable              - Transform class instance(s) to Matlab table
    %
    
    properties
        publication_id;
        category;
        citation;
        pdf_url;
        year;
    end

    properties (Hidden=true)        
        tableName='publication'; %tableName -  Database table name
        className=mfilename('class'); %className - Name of this class
        %mapColumns2Properties - Map column names to property names
        mapColumns2Properties = containers.Map(...
            {'publication_id','category','citation','pdf_url','year'},...
            {'publication_id','category','citation','pdf_url','year'}...
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


