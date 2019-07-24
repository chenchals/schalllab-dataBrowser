function [ output_args ] = CheckRH_MGVars( filename )
% All trials aligned on TargetOnset
% TargetOnset set to 3500
Z=load(filename);
corrTrials=Z.Correct_(Z.Correct_(:,2)==1,2)




end

