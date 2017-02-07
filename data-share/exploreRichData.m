function [ Events, dict ] = exploreRichData( dataStruct)
% Explore Rich's Data (MG)

    %%
    Events=[];
    dict=[];
    if(isempty(dataStruct))
       %dataStruct=load('/Users/subravcr/teba-local/RichCodeTest/Data/_D20130807005-RH_MG.mat');
       dict=testDictionary();
       [fn,fp]=uigetfile;
       dataStruct=load([fp fn],'-mat');
       %return
    end
    dict = getDictionary();
    Events=struct();
    nTrials=length(dataStruct.TrialStart_);
    % Replace nana to 0 as Map will not take NaN
    c=dataStruct.Correct_(:,2); c(isnan(c))=0;
    Events.Outcome=dict.outcome(c, dataStruct.Errors_);
    Events=addFieldIfExists(dataStruct,'TrialStart_',Events,'TrialStart');
    Events=addFieldIfExists(dataStruct,'FixOn_',Events,'FixOn');
    Events=addFieldIfExists(dataStruct,'FixAcqTime_',Events,'FixAcqTime');
    Events=addFieldIfExists(dataStruct,'FixTime_Jit_',Events,'FixTimeJitter');
    Events=addFieldIfExists(dataStruct,'Decide_',Events,'AutoSaccadeLatency');
    Events=addFieldIfExists(dataStruct,'JuiceOn_',Events,'JuiceOn');
    Events=addFieldIfExists(dataStruct,'BellOn_',Events,'BellOn');
    Events=addFieldIfExists(dataStruct,'MG_Hold_',Events,'MGHold');
    %flatten Target_ variable
    Events=mergeStructs(Events,dict.flattenTarget(dataStruct.Target_));
    %Stimuli variable (array) - no translation is done
    Events.Stimuli=dataStruct.Stimuli_;

end

function [targStruct]=addFieldIfExists(srcStruct,srcFieldname, targStruct, targFieldname)
% if a fieldname exists in srcStruct then add that field to srcStruct
   if(isfield(srcStruct, srcFieldname))
       targStruct.(targFieldname)=srcStruct.(srcFieldname)(:,1);
   end
end
    

%% Dictionary for Rich Heitz's Data
function [ dict ] = getDictionary()
    % Define dictionary
    dict.varnameMap=containers.Map();
    
    dict.correctMap=containers.Map(0:1,...
        {'Incorrect','Correct'});
    dict.errorMap=containers.Map(1:7,...
        {'CatchError','HoldError','LatencyError','TargetHoldError','SaccadeDetectionError',...
        'CorrectButTooFastInSLOW','CorrectButTooSlowInFAST'});
    dict.targetMap=containers.Map(1:14,...
        {'TargetOnset','TargetLocation','TargetColor','TargetBrightness','TargetSize',...
        'TargetSetSize','Unused7','Unused8','TaskType', 'HoldTime','TargetHomoOrHeterogenous', 'TargetEccentricity'...
       'TargetHoldTime','CatchTimeMax'});
   
    % Lookups fx
    dict.correctLookup=@(c) dict.correctMap(c);
    dict.errorLookup=@(c,e) [dict.correctMap(c) '-' dict.errorMap(e)];
    dict.outcome=@(c,e) getOutcome(c,e);
    dict.flattenTarget=@(t) flattenTarget(t);
    
    %
    function [ Outcome ]= getOutcome(corrects, errors)
        [errR,errC]=find(errors==1);
        Outcome=arrayfun(dict.correctLookup,corrects,'UniformOutput',false);
        Outcome(errR,1)=arrayfun(dict.errorLookup,corrects(errR),errC,'UniformOutput',false);
    end
    %
    function [ targStr ]= flattenTarget(target)
        targStr=struct();
        for ii=1:size(target,2)
            targStr.(dict.targetMap(ii))=target(:,ii);
        end
    end

end

function [structM]=mergeStructs(structA,structB)
  % No duplicate field check is done
   structM=structA;
   fnames=fieldnames(structB);
   for ii=1:length(fnames)
       fn=char(fnames(ii));
       structM.(fn)=structB.(fn);
   end
end



function [d] = testDictionary()
   
    % Example useage
    % SEARCH.Correct_(1:10,2) =
    corrects=[
        0
        0
        1
        0
        0
        1
        0
        1
        1
        1
        ];
    % SEARCH.Errors_(1:10,:) =
    errors = [
        NaN   NaN   NaN   NaN     1   NaN   NaN
        NaN   NaN   NaN   NaN     1   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN     1   NaN   NaN
        NaN   NaN   NaN   NaN     1   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN     1   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN
        ];
     
    d=getDictionary();
    
    o=d.outcome(corrects, errors)
    
    
    %Target_
    target=[
        3500           2           1         140           8           2         NaN         NaN           2         600           0           5         812         NaN
        3500           2           1         140           8           2         NaN         NaN           2         600           0           5         753         NaN
        3500           6           1         140           8           2         NaN         NaN           2         600           0           5         781         NaN
        3500           3           1         140           8           2         NaN         NaN           2         600           0           5         791         NaN
        3500           5           1         140           8           2         NaN         NaN           2         600           0           5         691         NaN
        3500           0           1         140           8           2         NaN         NaN           2         600           0           5         798         NaN
        3500           2           1         140           8           2         NaN         NaN           2         600           0           5         668         NaN
        3500           2           1         140           8           2         NaN         NaN           2         600           0           5         811         NaN
        3500           2           1         140           8           2         NaN         NaN           2         600           0           5         697         NaN
        3500           2           1         140           8           2         NaN         NaN           2         600           0           5         782         NaN
    
     ];
 
     
     
 
 
end



%Notes:
% Why are there Stimuli_ with 2 non-zero values for MG trials?
% example:
% [sr,sc]=find(Stimuli_==31)
% Stimuli_(unique(sr),:)




