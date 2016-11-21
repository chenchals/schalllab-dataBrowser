classdef Datafile
    %UNTITLED Summary of this class goes here
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

