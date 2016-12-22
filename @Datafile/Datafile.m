classdef Datafile
    %DATAFILE General Variable structure of a datafile
    %   Detailed explanation goes here
    
    properties
        vars;
    end
    
    methods
        % Constructor takes a filename
        function object= Datafile(filename)
            object.vars=loadVariableDefs(filename);
        end
    end
end

