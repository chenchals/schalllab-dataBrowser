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
%             
%             objStruct.person_id = object.id;
%             objStruct.person_firstname = object.firstname;
%             objStruct.person_lastname = object.lastname;
%             objStruct.person_email = object.email;
        
        end
        
    end
    
end

