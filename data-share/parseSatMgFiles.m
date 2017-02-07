% Save Rich's data as Events
function [] = parseSatMgFiles()
   global conn;
   %Create folder with monk abbr, and filename no ext for each file for
   %data sharing
   outFolder='/Volumes/schalllab/data-share/';
   
   mgStudy=Study;
   mgStudy.data_dir='%SAT%';
   mgStudy.description='MG';
   mgStudy.person_initials='RH';
   mgS=Study.fetchMatchingRecords(mgStudy);
   for ii=length(mgS):-1:1
       try
           fp=mgS(ii).data_dir;
           fn=mgS(ii).data_file;
           oDirMonk=mgS(ii).subject_initials;
           [~,oDirFile,~]=fileparts(fn);
           F=load([fp,filesep,fn],'-mat');
           ev=exploreRichData(F);
           saveToEvents(outFolder,oDirMonk,oDirFile,ev);
           log(ii).message = [fp,filesep,fn,' Successful '];
           disp(log(ii))
       catch err
           log(ii).message = [fp,filesep,fn,' ****Processing failed****'];
           log(ii).stack = char(join(cellfun(@(f,n,l) ...
                ['file: ',f(max(strfind(f,'/'))+1:end),' -function: ',n,' -line:',num2str(l)]...
                , {err.stack.file}', {err.stack.name}' ,{err.stack.line}','UniformOutput',false)...
                ,' ; '));
            disp(log(ii))
            continue;
       end
       
   end
   save('data-share-summary-log.mat','log');
end

function [] = saveToEvents(oDir,oDirMonk,oDirFile,ev)
   fp=[oDir,oDirMonk,filesep,oDirFile,filesep];
   fn='Events.mat';
   if (~exist(fp,'dir'))
       mkdir(fp);
   end
   save([fp fn], '-mat', 'ev');
end