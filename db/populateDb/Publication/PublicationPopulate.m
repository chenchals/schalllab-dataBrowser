function [ publications ] = PublicationPopulate()

    baseUrl='http://www.psy.vanderbilt.edu/';
    % [pageSrc,readStatus] = urlread(pubsPageUrl);
    %Above source is dirty html.  Needs to be cleand with
    % Navigate ot URL
    % Save page source as html
    % Convert to xml and clean- use tidy (on Mac)
    % tidy --output-xml y --indent auto --indent-spaces "2" --wrap 90 -o xxx.xml saved_page.html
    % Open the xml and clean
    %  1. Retain only <body> node
    %  2. Remove all entity Refs
    %  3. Anything else till xml is valid
    % Use xslt transformation to get text
    % Easier with xsltproc on unix systes
    % xsltproc pubs.xsl schall_pubs.xml > schall_pubs.txt
    % must be executed from db/populadeDb/Publication
    xslFile='pubs.xsl';
    xmlFile='schall_pubs.xml';
    dest='schall_pubs.txt';
    [resultFile,~] = xslt(xmlFile,xslFile,dest,'-tostricg')

    % Read the txt file and process fields by '|' seperator
    fid = fopen(dest);
    count=0;
    line = fgetl(fid);
    while ischar(line)
        count=count+1;
        publications(count)=createPublication(line,baseUrl);
        line = fgetl(fid);
    end
    fclose(fid);
    %Uncomment for re-populating
    %publications = Publication.saveAllRecords(publications);

end

function [ publication ] = createPublication(line, baseUrl)
    %createPublication
    publication = Publication();
    parts = split(line,'|');
    publication.category=char(parts(1));
    publication.authors=char(parts(2));
    publication.year=str2double(char(parts(3)));
    publication.title=char(parts(4));
    publication.journal=char(parts(5));
    pdf=char(parts(6));
    % Note: Avoid DB update for URLs with relative path:
    % Example '../pdfs/filename.pdf'
    if(contains(pdf,'.pdf'))
        pdf=regexprep(pdf,'\.\./pdfs','/faculty/schall/pdfs');
        pdf_url=[baseUrl(1:end-1),pdf];
        publication.pdf_url=pdf_url;
    end

end