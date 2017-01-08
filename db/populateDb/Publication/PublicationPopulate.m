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
    publications = Publication.saveAllRecords(publications);

end

function [ publication ] = createPublication(line, baseUrl)
    %createPublication
    publication = Publication();
    parts = split(line,'|');
    publication.category=char(parts(1));
    publication.citation=regexprep(char(parts(2)),'\s?\[\s?(pdf|mov|movie)\s?\]','');
    authTitleJournal=@(expr) regexp(expr,'^(?<authors>.*)\s?\(\d{4}\)\.?\s?(?<title>[A-Z].+)\.?\s?(?<journal>[A-Z].+)\.?\s?.*$','once','names');
    atj=authTitleJournal(publication.citation);
    if(length(atj)==1)
        publication.authors=regexprep(atj.authors,'\.','');
        publication.title=atj.title;
        publication.journal=atj.journal;
    else
        disp(publication.citation)
        disp(['authors, title, journal parsing empty'])
    end
    % Note: Avoid DB update for URLs with relative path:
    % Example '../pdfs/filename.pdf'
    pdf=char(parts(3));
    if(contains(pdf,'.pdf'))
        pdf=regexprep(pdf,'\.\./pdfs','/faculty/schall/pdfs');
        pdf_url=[baseUrl(1:end-1),pdf];
        publication.pdf_url=pdf_url;
    end
    p=regexp(char(parts(2)),'\((?<year>[\d]{4})\).*$','once','names');
    if(~isempty(p))
        publication.year=str2double(p.year);
    end
end