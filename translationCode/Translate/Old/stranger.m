function outfile_=stranger(str_file_path,str_file)
%function outfile_=stranger(str_file_path,str_file)
%Translates the stranger file.
%CALLS: None
%CALLER: CONVERT.M, Command line
%Example: O=stranger('c:\fecfef\','f_fef000.str')
%Author: %chenchal.subraveti@vanderbilt.edu

global Translation
%Initialize structures
SampleHeader.Name='';SampleHeader.Type=0;SampleHeader.Nitems=0;
SampleHeader.Dataoffset=0;SampleHeader.Itemsize=0;
SampleHeader.Res1=0;SampleHeader.Res2=0;
NeuronHeader=SampleHeader;
EventHeader=SampleHeader;
EventList='';
%Map Events
Event_01='M_TrialStart';
Event_02='M_Eot';
Event_03='M_FixSpotOn';
Event_04='M_FixSpotOff';
Event_05='M_Success';
Event_06='M_TargetOn';
Event_07='M_TargetOff';
%Initialize variables
M_TrialStart=0; M_Eot=0; M_FixSpotOn=0; M_FixSpotOff=0; M_Success=0; 
M_TargetOn=0; M_TargetOff=0; M_SpikeID=0; Cells=[]; Eves=[]; 
M_SpikeID='';
Neurons=0;
Events=0;
%Get the file to process
%[ifile_ file_path] = uigetfile('f:\*.*');
ifile_=str_file;
file_path=str_file_path;
if file_path(length(file_path))~='\'
   file_path=[file_path,'\'];
end
len_f=length(ifile_);
if ((ifile_(1)=='h')&(ifile_(2)=='s')) %for SEF recordings from HOAGI
   ofile_name='hogsef_s.';
elseif ((ifile_(1)=='h')&(ifile_(2)=='a')) %for ACC recordings from HOAGI
   ofile_name='hogacc_s.';
end

%ofile_=strcat(ifile_(1:min(len_f-4,6)),'_m',ifile_(len_f-3:len_f));
ofile_ext=char(ifile_(find(ifile_>=48 &ifile_<=57)));
infile_= strcat(file_path,ifile_);
outfile_= strcat(file_path,ofile_name,ofile_ext);
fid = fopen(infile_,'r');
DocHeader.Code=fread(fid,1,'long');
if(DocHeader.Code ~= 270153200)
   disp('INPUT MUST BE A STRANGER FILE');
   break;
end
DocHeader.Title=deblank(char(fread(fid,128,'char')'));
DocHeader.Tick=fread(fid,1,'long');
DocHeader.Beg=fread(fid,1,'long');
DocHeader.End=fread(fid,1,'long');
%frame_start,frame_end,Event_01-Event_07,no.of neurons
DocHeader.Samples=fread(fid,1,'long');
DocHeader.Res1=fread(fid,1,'long');
DocHeader.Res2=fread(fid,1,'long');
i=1;
for nn=1:DocHeader.Samples
   SampleHeader(i).Name=deblank(char(fread(fid,32,'char')'));
   SampleHeader(i).Type=fread(fid,1,'long');
   SampleHeader(i).Nitems=fread(fid,1,'long');
   SampleHeader(i).Dataoffset=fread(fid,1,'long');
   SampleHeader(i).Itemsize=fread(fid,1,'long');
   SampleHeader(i).Res1=fread(fid,1,'long');
   SampleHeader(i).Res2=fread(fid,1,'long');
   if(SampleHeader(i).Type == 0 & SampleHeader(i).Nitems > 0 )
      Neurons=Neurons+1;
      M_SpikeID(Neurons,1:length(SampleHeader(i).Name))=(SampleHeader(i).Name);
      NeuronHeader(Neurons)=SampleHeader(i);
      i=i+1;
   elseif(SampleHeader(i).Type == 1 & SampleHeader(i).Nitems > 0)
      Events=Events+1;
      EventHeader(Events)=SampleHeader(i);
      i=i+1;
   end
end
disp(['Neurons  ',num2str(Neurons),'  ;  Events   ',num2str(Events)])

if ((Neurons>0)&(Events>3)) 
   EventList=char(EventHeader.Name);
   TotalTrials=EventHeader(strmatch('Event_01',EventList)).Nitems;
   k=0;l=0;
   temp=[];
   disp(strcat('Total Trials : ',num2str(TotalTrials)));
   disp(strcat('Time Resolution: ',num2str(DocHeader.Tick/1000),'msec'));
   disp('Making space for {Eves} variable')
   %Eves=zeros(Events,max([SampleHeader(Neurons+1:Neurons+Events).Nitems]));
   Eves1=zeros(Events,TotalTrials);
   Eves=zeros(Events,TotalTrials);
   disp('Reading Events...')
   for k=1:Events
      fseek(fid,EventHeader(k).Dataoffset,-1);
      Eves(k,1:EventHeader(k).Nitems)=(fread(fid,EventHeader(k).Nitems,'long'))'.*(DocHeader.Tick/1000);
   end
   disp('Processing Events...');
   if(Events >=4)%There must be atleast 4 events:Frame_Start, Frame_End, Event_01, Event_02
      for k=1:TotalTrials
         %disp(strcat('Trial No  :',num2str(k), '/',num2str(TotalTrials)));
         temp1=Eves(strmatch('Event_01',EventList),k);
         temp2=Eves(strmatch('Event_02',EventList),k);
         eval(strcat(Event_01,'(k)=','temp1;'));
         eval(strcat(Event_02,'(k)=','temp2-temp1;'));
         if (Events>4)
            var=strmatch('Event_03',EventList);
            temp=Eves(var,(Eves(var,:)>temp1 & Eves(var,:)<temp2));
            vartemp=max([(min(temp-temp1)) 0]);
            eval(strcat(Event_03,'(k)=','vartemp;'));
            clear var temp vartemp
            if (Events>5)
               var=strmatch('Event_04',EventList);
               temp=Eves(var,(Eves(var,:)>temp1 & Eves(var,:)<temp2));
               vartemp=max([(min(temp-temp1)) 0]);
               eval(strcat(Event_04,'(k)=','vartemp;'));
               clear var temp vartemp
               if(Events>6)
                  var=strmatch('Event_05',EventList);
                  temp=Eves(var,(Eves(var,:)>temp1 & Eves(var,:)<temp2));
                  vartemp=max([(min(temp-temp1)) 0]);
                  eval(strcat(Event_05,'(k)=','vartemp;'));
                  clear var temp vartemp
                  if(Events>7)
                     var=strmatch('Event_06',EventList);
                     temp=Eves(var,(Eves(var,:)>temp1 & Eves(var,:)<temp2));
                     vartemp=max([(min(temp-temp1)) 0]);
                     eval(strcat(Event_06,'(k)=','vartemp;'));
                     clear var temp vartemp
                     if(Events>8)
                        var=strmatch('Event_07',EventList);
                        temp=Eves(var,(Eves(var,:)>temp1 & Eves(var,:)<temp2));
                        vartemp=max([(min(temp-temp1)) 0]);
                        eval(strcat(Event_07,'(k)=','vartemp;'));
                        clear var temp vartemp
                     end
                  end
               end
            end
         end
      end
   end
   clear('Eves')
   M_TrialStart=M_TrialStart'; M_Eot=M_Eot';M_FixSpotOn=M_FixSpotOn';
   M_FixSpotOff=M_FixSpotOff'; M_Success=M_Success'; M_TargetOn=M_TargetOn';
   if(~isempty(M_TargetOff))
      M_TargetOff=M_TargetOff';
      save (outfile_,'M_TrialStart','M_Eot','M_FixSpotOn','M_FixSpotOff',...
         'M_Success', 'M_TargetOn', 'M_TargetOff','M_SpikeID','Translation');
   elseif(isempty(M_TargetOff))
      save (outfile_,'M_TrialStart','M_Eot','M_FixSpotOn','M_FixSpotOff',...
         'M_Success', 'M_TargetOn','M_SpikeID','Translation');
   else
   end
   disp('Reading Spike data...')
   for n=1:Neurons
      disp(strcat('Neuron   :::',M_SpikeID(n,:)));
      fseek(fid,NeuronHeader(n).Dataoffset,-1);
      Cells=((fread(fid,NeuronHeader(n).Nitems,'long'))').*(DocHeader.Tick/1000);
      for k=1:TotalTrials
         temp=Cells((Cells > M_TrialStart(k) & Cells < M_Eot(k)+M_TrialStart(k)));
         if(~isempty(temp))
            temp=temp-M_TrialStart(k);
            eval(strcat(M_SpikeID(n,:),'(k,1:length(temp))=','temp;'));
            %            temp=[];
         else
            temp=0;
            eval(strcat(M_SpikeID(n,:),'(k,1:length(temp))=','temp;'));
            %disp(strcat('No spikes between TrialStart and Eot for ::',M_SpikeID(n,:),':::TrialNo', num2str(k)));
         end
         %modified to reduce array length
         Cells=Cells(Cells>=M_Eot(k)+M_TrialStart(k));
         temp=[];
      end %
      
      eval(strcat('save(','outfile_,''', M_SpikeID(n,:), ''',''-append'')'))
      %disp('setting Cells to []')
      Cells=[];
      eval(strcat('clear(''',M_SpikeID(n,:),''')'));
   end
   fclose(fid);
   disp(strcat('Wrote File    : ',outfile_));

   
else
   disp('File does not contain sufficient Data. Translation aborted.')
end

return