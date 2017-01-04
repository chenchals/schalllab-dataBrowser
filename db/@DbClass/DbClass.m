classdef DbClass < handle
    %DBCLASS Abstract class for all daDetailed explanation goes here
    
    properties (Abstract)
        tableName;
        className;
        mapColumns2Properties;
    end
    
    methods (Access = 'protected')
        
        function [ object ] = dbSaveOrUpdate(object)
            objStruct = DbClass.asDbStruct(object);
            dbStruct = saveOrUpdate(object.tableName, objStruct);
            object = DbClass.asObject(object.className,dbStruct);
        end
        
        function [ keys, values ] = getKeysValues(classObject)
            keys = classObject.mapColumns2Properties.keys;
            values = classObject.mapColumns2Properties.values;
        end
        
    end
    
    methods (Static)
        
        function [ object ] = fetchDbRecords(className)
            object=eval([className,'();']);
            dbRecords = fetchRecords(object.tableName);
            object = DbClass.asObject(className, dbRecords);
        end
        
        function  [object] = asObject(className, dbStruct)
            object = eval([className,'();']);
            [ keys, values ] = getKeysValues(object);
            fnames = fieldnames(dbStruct);
            for n = length(dbStruct):-1:1
                for ii = 1:length(keys)
                    key = char(keys{ii});
                    value = char(values{ii});
                    if(sum(contains(fnames,key)))
                        object(n).(value) = dbStruct(n).(key);
                    end
                end
            end
        end
        
        function  [dbStruct] = asDbStruct(object)
            [ keys, values ] = getKeysValues(object(1));
            for n = length(object):-1:1
                for ii = 1:length(keys)
                    key = char(keys{ii});
                    value = char(values{ii});
                    dbStruct(n).(key) = object(n).(value);
                end
            end
        end
        
        function  [asTable] = asTable(object)
            asTable = struct2table(DbClass.asDbStruct(object));
        end
        
    end
end

