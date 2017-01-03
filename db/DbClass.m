classdef DbClass < handle
    %DBCLASS Abstract class for all daDetailed explanation goes here
    
    properties (Abstract)
        tableName;
        mapColumns2Properties;
    end
    
    methods (Access='protected')
        function  [objStruct] = asDbStruct(object)
            keys = object.mapColumns2Properties.keys;
            values = object.mapColumns2Properties.values;
            for ii=1:length(keys)
                key = char(keys{ii});
                value = char(values{ii});
                objStruct.(key)=object.(value);
            end
        end
        
        function [ object ] = dbSaveOrUpdate(object)
            objStruct = asDbStruct(object);
            dbStruct = saveOrUpdate(object.tableName, objStruct);
            keys = object.mapColumns2Properties.keys;
            values = object.mapColumns2Properties.values;
            for ii=1:length(keys)
                key = char(keys{ii});
                value = char(values{ii});
                object.(value)=dbStruct.(key);
            end
        end
        
    end
    
end

