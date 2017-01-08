function downloadPdfs(publications)
    % global conn object is needed
    %pubs=Publication.fetchAllRecords;
        pubs=publications;
    % Use only those pubs that have pdf_url ~= null

    pubs(cellfun(@(x) contains(x,'null'),{pubs.pdf_url})==1)=[];
    [context,filename,ext]=cellfun(@fileparts,{pubs.pdf_url},'UniformOutput',false);
    % for output file:
    year=cellfun(@num2str,{pubs.year},'UniformOutput',false);
    authorsTitle=@(expr) regexp(expr,'^(?<authors>.*)\s?\(\d{4}\)\s?(?<title>.*)$','once','names');
    authorsAndTitle=@(splitArr, index) authorsTitle(char(splitArr(index)));
    splitAtDot=@(x) authorsAndTitle(split(x,'.'),1);
    
    [authors,title]=cellfun(splitAtDot,{pubs.citation},'UniformOutput',false);
    

    wget_urls=cellfun(@(x) ['wget http://',x],{z.pdf_url}','UniformOutput',false);

    % set System command path for wget
    PATH = getenv('PATH');
    %which wget
    setenv('PATH', [PATH ':/usr/local/bin']);
    % execute wget for all elements in cell array
    cellfun(@(x) system(x),wget_urls,'UniformOutput',false);

end

function [ wgetUrl ] = createWgetUrl(publication)
  
  [context,filename,ext] = fileparts(publication.pdf_url)
  pdfFile =[filename,ext];
  year = num2str(publication.year);
  
  splitAt=@(expr, index) char(expr(index));
  split1=@(x) splitAt(split(x,'.'),1);


end