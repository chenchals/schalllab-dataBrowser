classdef DbClass < handle
    %DbClass An abstract class for database interactions
    % This class provides boiler-plate code to persist, fetch and transform
    % Matlab user-class instances to/from database. Classes that map
    % database tables to Matlab Class instances should sub-class DbClass.
    %
    % DbClass Properties (Abstract):
    %     Sub-class should define these variables
    %     tableName - Database table name for the sub-class
    %     className - Name of the sub-class to which the table maps to
    %     mapColumns2Properties - A containers.Map that maps column-name
    %     to class-property. This variable is used for ORM (Object
    %     Relational Mapping)
    %
    % DbClass Methods (Protected): Accessed only through sub-class instance
    %    dbSaveOrUpdate   - Save an instance of DbClass to database or populate if present.
    %    getKeysValues    - Return columnNames and propertyNames for the classObject
    %
    % DbClass Methods (Static): Accessed through class
    %    fetchDbRecords        - Fetch all records from database table
    %    fetchDbRecordsByModel - Fetch records that match model properties
    %    asClass               - Transform struct to class instance
    %    asStruct              - Transform class instance to struct
    %    asTable               - Transform class instance to table
    %
    properties (Abstract)
        tableName; % Database table name
        className; % Matlab Class name
        mapColumns2Properties; % Mapping for Table column names to Class property names
    end
    
    methods (Access = 'protected')
        % [ oClassObject ] = dbSaveOrUpdate(classObject)
        % Save and return a fully populated classObject
        %   classObject : Instance of DbClass to be saved
        %
        %   oClassObject : Fully hydrated instance of DbClass
        %   propertyNames : Cell array of property names of classObject
        function [ oClassObject ] = dbSaveOrUpdate(classObject)
            objStruct = DbClass.asStruct(classObject);
            dbStruct = saveOrUpdate(classObject.tableName, objStruct);
            oClassObject = DbClass.asClass(classObject.className,dbStruct);
        end
        
        % [ columnNames, propertyNames ] = getKeysValues(classObject)
        % Returns columnNames and corresponding propertyNames
        %   classObject : Instance of DbClass
        %   columnNames : Cell array of columnNames of the database table
        %   propertyNames : Cell array of property names of classObject
        function [ columnNames, propertyNames ] = getKeysValues(classObject)
            columnNames = classObject.mapColumns2Properties.keys;
            propertyNames = classObject.mapColumns2Properties.values;
        end
        
    end
    
    methods (Static)
        % [ classObject ] = fetchDbRecords(className)
        % Fetche all rows from the table corresponding to the className
        %   className : Name of the Matlab class that will be evaluated to
        %   an instance of the class, which is used for SQL query
        %   classObject : Instance(es) of all records
        function [ classObject ] = fetchDbRecords(className)
            classObject=eval([className,'();']);
            dbRecords = fetchRecords(classObject.tableName);
            classObject = DbClass.asClass(className, dbRecords);
        end
        
        % [ classInstance ] = fetchDbRecordsByModel(modelObject)
        % Fetch all records from database that match the modelObject properties.
        %   modelObject : Template for SQL query.
        %   classInstance : Instance(es) of matching records
        function [ classInstance ] = fetchDbRecordsByModel(modelObject)
            dbRecords = fetchRecords(modelObject.tableName,DbClass.asStruct(modelObject));
            classInstance = DbClass.asClass(modelObject.className, dbRecords);
        end
        
        % [ classInstance ] = asClass(className, dbStruct)
        % Transform a struct to instance of a class of name className
        %   className : Name of the Matlab class
        %   dbStruct : A struct where fieldnames correspond to columnNames
        %   classInstance : Instance(es) of class
        function  [ classInstance ] = asClass(className, dbStruct)
            classInstance = eval([className,'();']);
            [ columnNames, propertyNames ] = getKeysValues(classInstance);
            fnames = fieldnames(dbStruct);
            for n = length(dbStruct):-1:1
                for ii = 1:length(columnNames)
                    columnName = char(columnNames{ii});
                    propertyName = char(propertyNames{ii});
                    if(sum(contains(fnames,columnName)))
                        classInstance(n).(propertyName) = dbStruct(n).(columnName);
                    end
                end
            end
        end
        
        % [ dbStruct ] = asStruct(classInstance)
        % Transform a classInstance to a struct
        %   classInstance : Instance(es) of class
        %   dbStruct : A struct where fieldnames correspond to columnNames
        function  [dbStruct] = asStruct(classInstance)
            [ columnNames, propertyNames ] = getKeysValues(classInstance(1));
            for n = length(classInstance):-1:1
                for ii = 1:length(columnNames)
                    columnName = char(columnNames{ii});
                    propertyName = char(propertyNames{ii});
                    dbStruct(n).(columnName) = classInstance(n).(propertyName);
                end
            end
        end
        
        % [ classTable ] = asTable(classInstance)
        % Transform a classInstance to a table
        %   classInstance : Instance(es) of class
        %   classTable : A table where column names are class properties
        function  [ classTable ] = asTable(classInstance)
            classTable = struct2table(DbClass.asStruct(classInstance));
        end
        
    end
end


