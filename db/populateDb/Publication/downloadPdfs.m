function [ wget_urls ] = downloadPdfs(outputDir)
    % global conn object is needed
    pubs=Publication.fetchAllRecords;
    % Use only those pubs that have pdf_url ~= null
    pubs(cellfun(@(x) contains(x,'null'),{pubs.pdf_url})==1)=[];
     % for output file:
      
    wget_urls=arrayfun(@createWgetUrl, pubs,'UniformOutput',false);
    %cd(outputDir);
    % set System command path for wget
    PATH = getenv('PATH');
    %which wget
    setenv('PATH', [PATH ':/usr/local/bin']);
    % execute wget for all elements in cell array
    %cellfun(@(x) system(x),wget_urls,'UniformOutput',false);

end

function [ wgetUrl ] = createWgetUrl(publication)
  
  pdfFile =publication.pdf_url;
  year = num2str(publication.year);
  authors = regexprep(publication.authors,'[\s&\.]','');
  authors = regexprep(authors,',','-');
  title = regexprep(publication.title,'[,:\.\(\[\]\)"&]','');
  title = regexprep(title,'\s','-');
  title = title(1:end-1);
  oFile=[year,'-',authors,'-',title,'.pdf'];
  wgetUrl = ['wget ',pdfFile,' -O ',oFile];

end