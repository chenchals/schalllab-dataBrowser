function bat_process(List_of_Files)
%function bat_process(List_of_Files)
%Script for Batch processing
%***DO not change variable names in this file***
%CALLS: P_MMENU.M, P_MGET.M
%CALLER: TRANSLATEANDANLYZE.M, Command Line
%Author:chenchal.subraveti@vanderbilt.edu
global BatProcess Filelist ListNo
%FEvents 1 to 8 are 1.Correct_; 2.Eot_; 3.FixSpotOff_;
%4.FixSpotOn_; 5.Fixate_; 6.Saccade_; 7.Target_;8.TrialStart_;
%For SORTING from Target_ to Saccade_ and aligning on Target_
%set SortVal=1 for sorting and 0 for unsorted
%set FromVal=7;%Target_:::ToVal=6;%Saccade_:::AlignVal=7; %Target
%DEFAULTS CANNOT BE CHANGED. INSTEAD CHANGE DEFAULT to 0 and set other params.
Correct=1;Eot=2;Fixoff=3;Fixon=4;Fixate=5;Saccade=6;Targeton=7;Trialstart=8;
global DEFAULTS SortVal FromVal ToVal AlignVal PreTimeVal PostTimeVal
global NCells CellNo
global M_SpikeID
BatProcess=1;
Filelist=List_of_Files;
Cell_List=1;
Filelist
for ListNo=1:size(Filelist,1)
   disp(['Batch Processing File  :',deblank(char(Filelist(ListNo,:)))])
   load(deblank(char(Filelist(ListNo,:))),'M_SpikeID','-mat');
   Cell_List=size(M_SpikeID,1);
   disp([' Number of Cells : 'num2str(Cell_List)])
    
   for JJ=1:Cell_List
      disp(['Cell No. ',num2str(JJ), 'Cell ID  ',M_SpikeID(JJ,:)])
   end
   for CellNo=1:Cell_List
      DEFAULTS=1;
      p_mmenu; p_mget 'File';p_mget 'NewCell';p_mget 'Done'; drawnow; p_mget 'Print';
   	p_mget 'Close';   
      DEFAULTS=0;
      SortVal=1;
      FromVal=Targeton;
      ToVal=Saccade;
      AlignVal=Saccade;
      PreTimeVal=-300;
      PostTimeVal=100;
      p_mmenu; p_mget 'File';p_mget 'NewCell';p_mget 'Done'; drawnow; p_mget 'Print';
   	p_mget 'Close';   
   end
end