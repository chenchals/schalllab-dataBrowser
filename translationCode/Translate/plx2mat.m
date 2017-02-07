function outfile = plx2mat(file_path,ifile_)
% Translates the PLX file to MAT format
%
% by erik.emeric@vanderbilt.edu
% last changed: 01-21-03

% 0. Input and Output
q='''';c=',';qcq=[q c q];
% if been used outside the BATCH mode
if nargin<2
    [ifile_,file_path] = uigetfile('c:\*.plx','Choose PLX File to Process');
    if isequal(ifile_,0)|isequal(file_path,0)
        disp('File not found')
        return
    else
        disp(['File ', file_path, ifile_, ' found'])
    end
end
infile = strcat(file_path,ifile_);

% piece 'ofile_name' together
MonkArea = ifile_(1:6); FileNum = ifile_(7:9);
ofile_ = strcat(MonkArea,'_x.',FileNum);
outfile = strcat(file_path,ofile_);

% 1. get data from PLX file
% 1.1. analog channels
[adfreq_1, n, ts, fn, lfp_1] = plx_ad(infile, 0);
% LFP recording from first (and so far only) electrode
clear ts fn n
lfp_1(lfp_1 == 0) = (range(lfp_1))/10000;
ADconvert1 = 1000/adfreq_1;
lfp_1 = lfp_1.*ADconvert1;

% 1.2. event TrialStart_
% Event #8 is 'trial start' 
[tsfreq_8, n, TrialStart_plx, sv] = plx_event_ts(infile, 8);
clear sv n
TSconvert8 = 1000/tsfreq_8;
TrialStart_plx = round(TrialStart_plx.*TSconvert8);
TrialStart_plx = TrialStart_plx';

% 1.3. event TrialStart_
% Event #2 is 'end of trial' 
[tsfreq_2, n, Eot_plx, sv] = plx_event_ts(infile, 2);
clear sv n
TSconvert2 = 1000/tsfreq_2;
Eot_plx = round(Eot_plx.*TSconvert2);
Eot_plx = Eot_plx';

% go through recorded AD data and cut up trials
cT = 1;
while cT < length(TrialStart_plx)
    TrialLength = TrialStart_plx(cT+1)-TrialStart_plx(cT);
    LFP_1(cT,1:TrialLength) = lfp_1(TrialStart_plx(cT):TrialStart_plx(cT+1)-1);
    %plot([1:TrialLength],lfp_1(TrialStart_plx(cT):TrialStart_plx(cT+1)-1))
    cT = cT+1;
end
TrialLength = Eot_plx(cT)-TrialStart_plx(cT);
LFP_1(cT,1:TrialLength+1) = lfp_1(TrialStart_plx(cT):Eot_plx(cT));

% get length of trials
Eot_plx = Eot_plx - TrialStart_plx;


% save it
save(outfile,'LFP_1','TrialStart_plx','Eot_plx','-mat')

