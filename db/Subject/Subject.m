classdef Subject < handle
    %Subject Object of class Subject
    
    properties
        id;
        species;
        name;
        name_abbr;
        data_dir;
        is_active;
        dob;
        acquisition_date;
        dod;
        gender;
    end
    
    methods
        % Constructor
        function [ object ] = Subject(id, species, name. name_abbr, data_dir,is_active,dob,acquisition_date,dod,gender)
            object.id=id;
            object.species=species;
            object.name=name;
            object.name_abbr=name_abbr;
            object.data_dir=data_dir;
            object.is_active=is_active;
            object.dob=dob;
            object.acquisition_date=acquisition_date;
            object.dod=dod;
            object.gender=gender;
            
        end
        
        % save or update Person object
        function [ object ] = dbSaveOrUpdate(object)
            objStruct = asDbStruct(object);
            dbStruct = saveOrUpdate('person',objStruct);
            object.id = dbStruct.person_id ;
            object.firstname = dbStruct.person_firstname;
            object.lastname = dbStruct.person_lastname;
            object.email = dbStruct.person_email;
        end
    end
    methods (Access='private')
        % Person table columnnames
        function  [objStruct] = asDbStruct(object)
            objStruct.person_id = object.id;
            objStruct.person_firstname = object.firstname;
            objStruct.person_lastname = object.lastname;
            objStruct.person_email = object.email;
        end
    end
end


