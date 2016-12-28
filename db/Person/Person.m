classdef Person
    %PERSON Object of class Person
    
    properties
        id;
        firstname;
        lastname;
        email;
    end
    
    methods
        % Constructor
        function object = Person(id, firstname, lastname, email)
            object.id = id;
            object.firstname = firstname;
            object.lastname = lastname;
            object.email = email;
        end
    end
    methods (Static)
        % Person table columnnames
        function  [pStruct] = getDbStruct(personObject)
            pStruct.person_id = personObject.id;
            pStruct.person_firstname = personObject.firstname;
            pStruct.person_lastname = personObject.lastname;
            pStruct.person_email = personObject.email;
         end
    end
end


