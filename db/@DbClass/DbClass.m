classdef DbClass < handle
    %DbClass An abstract class for database interactions
    % This class provides boiler-plate code to persist, fetch and transform
    % Matlab user-class instances to/from database. Classes that map
    % database tables to Matlab Class instances should sub-class DbClass.
    %
    % DbClass Properties (Abstract):
    %     Sub-class should define these variables
    %     tableName             - Database table name for the sub-class
    %     className             - Name of the sub-class to which the table maps to
    %     mapColumns2Properties - A containers.Map that maps column-name
    %     to class-property. This variable is used for ORM (Object
    %     Relational Mapping)
    %
    % DbClass Methods (Protected):
    %    Accessed only through sub-class instance
    %    dbSaveOrUpdate   - Save an instance of DbClass to database or populate if present.
    %    getKeysValues    - Return columnNames and propertyNames for the classObject
    %
    % DbClass Methods (Static, Protected):
    %    Accessed through sub-class
    %    saveRecords           - Save all class instances to database table
    %    fetchRecords          - Fetch all records from database table
    %    fetchRecordsByModel   - Fetch records that match model properties
    %    asClass               - Transform struct to class instance
    %    asStruct              - Transform class instance to struct
    %    asTable               - Transform class instance to table
    %
    % DbClass Methods (Static, Private): Accessed by DbClass internally
    
    
    properties (Abstract)
        tableName; % Database table name
        className; % Matlab Class name
        mapColumns2Properties; % Mapping for Table column names to Class property names
    end
    
    methods
        
        function [ oClassObject ] = save(classObject)
            %SAVE Save and return a fully populated classObject
            % [ oClassObject ] = save(classObject)
            %   classObject : Instance of DbClass to be saved
            %   oClassObject : Fully hydrated instance of DbClass
            oClassObject = DbClass.saveRecords(classObject);
        end
        
    end
    
    %% Called by sub-class methods statically, do not need a class instance to be called.
    % Save/fetch/update Database records given instances of a sub-class of DbClass
    % Transformations between class instance, class properties as Matlab struct,
    % and class properties as Matlab table
    methods (Static, Access='protected')
        
        function [ oClassObjects ] = saveRecords(classObjects)
            %SAVEALL Save and return fully populated classObjects
            % [ oClassObjects ] = saveAll(classObjects)
            %   classObjects : Instances of DbClass to be saved
            %   oClassObjects : Fully hydrated instances of DbClass
            % currently saves only one record .. mod needed for bulk
            % saveUpdate

            objStruct = DbClass.asDbStructFromClass(classObjects);
            tableName = classObjects(1).tableName;
            className = classObjects(1).className;
            for n = 1:length(objStruct)
            dbStruct = saveOrUpdate(tableName, objStruct(n));
            oClassObjects(n) = DbClass.asClassFromDbStruct(className,dbStruct);
            end
        end
        
        function [ classObject ] = fetchRecords(className)
            %FETCHRECORDS Fetch all db records for className
            % [ classObject ] = fetchDbRecords(className)
            %   className : Sub-class name of DbClass class used for SQL query
            %   classObject : Instance(es) of all records
            classObject=eval([className,'();']);
            dbRecords = fetchRecords(classObject.tableName);
            classObject = DbClass.asClassFromDbStruct(className, dbRecords);
        end
        
        
        function [ classInstance ] = fetchRecordsByModel(modelObject)
            %FETCHRECORDSByMODEL Fetch records matching modelObject properties
            % [ classInstance ] = fetchDbRecordsByModel(modelObject)
            %   modelObject : Instance of DbClass used as template for SQL query
            %   classInstance : DbClass Instance(es) of matching records
            dbRecords = fetchRecords(modelObject.tableName,DbClass.asDbStructFromClass(modelObject));
            classInstance = DbClass.asClassFromDbStruct(modelObject.className, dbRecords);
        end
        
        function  [ classInstance ] = asClass(className, classStruct)
            %ASCLASS Transform a struct class instance of className
            % [ classInstance ] = asClass(className, dbStruct)
            %   className : Sub-class name of DbClass class
            %   classStruct : A struct where fieldnames = propertyNames
            %   classInstance : Instance(es) of class
            tempObj = eval([className,'();']);
            [ ~, propertyNames ] = DbClass.getKeysValues(tempObj);
            classInstance = eval([className,'();']);
            for n = length(classStruct):-1:1
                for ii = 1:length(propertyNames)
                    propertyName = char(propertyNames{ii});
                    if(sum(contains(fnames,propertyName)))
                        classInstance(n).(propertyName) = classStruct(n).(propertyName);
                    end
                end
            end
        end
        
        function  [ classStruct ] = asStruct(classInstance)
            %ASSTRUCT Transform a classInstance to a struct
            % [ classStruct ] = asStruct(classInstance)
            %   classInstance : Instance(es) of class
            %   classStruct : A struct where fieldnames = propertyNames
            [ ~, propertyNames ] = DbClass.getKeysValues(classInstance(1));
            for n = length(classInstance):-1:1
                for ii = 1:length(propertyNames)
                    propertyName = char(propertyNames{ii});
                    classStruct(n).(propertyName) = classInstance(n).(propertyName);
                end
            end
        end
        
        function  [ classTable ] = asTable(classInstance)
            %ASTABLE Transform a classInstance to a table
            % [ classTable ] = asTable(classInstance)
            %   classInstance : Instance(es) of class
            %   classTable : A table where column names are class properties
            classTable = struct2table(DbClass.asStruct(classInstance),'AsArray',true);
        end
                
        function [ columnNames, propertyNames ] = getKeysValues(classObject)
            %GETKEYSVALUES Return columnNames and corresponding propertyNames
            % [ columnNames, propertyNames ] = getKeysValues(classObject)
            %   classObject : Instance of DbClass
            %   columnNames : Cell array of columnNames of the database table
            %   propertyNames : Cell array of property names of classObject
            columnNames = classObject.mapColumns2Properties.keys;
            propertyNames = classObject.mapColumns2Properties.values;
        end
        
    end
    
    %% Used for databse interactions.
    % Marshall property name/value pairs of class to
    % Database table's column name/value pairs
    % and vice versa
    methods (Static, Access='private')
        
        function  [ classInstance ] = asClassFromDbStruct(className, dbStruct)
            %ASCLASSFROMDBSTRUCT Transform database struct from cursor to class instance
            % [ classInstance ] = asClassFromDbStruct(className, dbStruct)
            %   className : Sub-class name of DbClass class
            %   dbStruct : A struct where fieldnames correspond to columnNames
            %   classInstance : Instance(es) of class
            classInstance = eval([className,'();']);
            [ columnNames, propertyNames ] = DbClass.getKeysValues(classInstance);
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
        
        function  [dbStruct] = asDbStructFromClass(classInstance)
            %ASDBSTRUCTFROMCLASS Transform a classInstance to database struct
            % [ dbStruct ] = asDbStructFromClass(classInstance)
            %   classInstance : Instance(es) of class
            %   dbStruct : A struct where fieldnames map to columnNames
            [ columnNames, propertyNames ] = DbClass.getKeysValues(classInstance(1));
            for n = length(classInstance):-1:1
                for ii = 1:length(columnNames)
                    columnName = char(columnNames{ii});
                    propertyName = char(propertyNames{ii});
                    dbStruct(n).(columnName) = classInstance(n).(propertyName);
                end
            end
        end
        
        function  [ classTable ] = asDbTableFromClass(classInstance)
            %ASDBTABLEFROMCLASS Transform a classInstance to a table
            % [ classTable ] = asDbTableFromClass(classInstance)
            %   classInstance : Instance(es) of class
            %   classTable : A table where columnNames map to propertyNames
            classTable = struct2table(DbClass.asDbStructFromClass(classInstance));
        end
        
    end
    
end


