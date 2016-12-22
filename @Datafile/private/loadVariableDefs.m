function [ dataStruct ] = loadVariableDefs( filename )

    dataStruct=struct();
    if (iscell(filename))
        filename=char(filename);
    end
    if (isequal(matfinfo(filename),'MAT-file'))
        
        dataStruct.('filename')=filename;
        vars=whos(matfile(filename));
        for varIndx=length(vars):-1:1
            dataStruct.(vars(varIndx).name)=vars(varIndx).size;
         end
%         header=load(filename,'-mat','Header_');
%         if (isstruct(header))
%             headerFields=fieldnames(header.Header_);
%             for j=length(headerFields):-1:1
%                 fieldName=char(join({'Header_',char(headerFields(j))},''));
%                 dataStruct.(fieldName)=getfield(header.Header_,char(headerFields(j)));
%             end
%         elseif isempty(header)
%             dataStruct.Header_= 'NA';
%         else
%             dataStruct.Header_=header;
%         end 
    end
end

