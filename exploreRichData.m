function [ Events ] = exploreRichData( dataStruct)
% Explore Rich's Data (MG)

    %%
    if(isempty(dataStruct))
       %dataStruct=load('/Users/subravcr/teba-local/RichCodeTest/Data/_D20130807005-RH_MG.mat');
       testDictionary();
       return
    end
    dict = getDictionary();
    Events=struct();
    nTrials=length(dataStruct.TrialStart_);
    Events.FixOn=dataStruct.FixOn_(:,1);
    Events.FixAcqTime=dataStruct.FixAcqTime_(:,1);
    Events.TargetOnset=dataStruct.Target_(:,1);
    Events.Decide=dataStruct.Decide_(:,1);
    Events.BellOn=dataStruct.BellOn_(:,1);
    Events.JuiceOn=dataStruct.JuiceOn_(:,1);
    Events.MGHold=dataStruct.MG_Hold_(:,1);
    Events.Outcome=dict.outcome(dataStruct.Correct_(:,2), dataStruct.Errors_);

end

function [ dict ] = getDictionary()
    % Define dictionary
    dict.correct=containers.Map([0,1],{'Incorrect','Correct'});
    dict.correctLookup=@(c) dict.correct(c);
    dict.errors=containers.Map(1:7,{'CatchError','HoldError','LatencyError','TargetHoldError','SaccadeDetectionError','CorrectButTooFastInSLOW','CorrectButTooSlowInFAST',});
    dict.errorLookup=@(c,e) [dict.correct(c) '-' dict.errors(e)];
    dict.outcome=@(c,e) getOutcome(c,e);
    
    function [ Outcome ]= getOutcome(corrects, errors)
        [errR,errC]=find(errors==1);
        Outcome=arrayfun(dict.correctLookup,corrects,'UniformOutput',false);
        Outcome(errR,1)=arrayfun(dict.errorLookup,corrects(errR),errC,'UniformOutput',false);
    end
end




function [] = testDictionary()
   
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
    

end



%Notes:
% Why are there Stimuli_ with 2 non-zero values for MG trials?
% example:
% [sr,sc]=find(Stimuli_==31)
% Stimuli_(unique(sr),:)




