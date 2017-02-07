function convert(varargin)
%function convert(PDPFile1, MNAPFile2,Extra)
%If more than 2 arguments then 1 st file will be considered as 
%Translated PDP file and 2nd as Translated MNAP file
%they are then merged by MERGE
global Translation
if nargin==1
   File1=varargin{1};
   %infile_=strcat(Filepath,File1);
   [Filepath,Filename,FileExt]=fileparts(File1);
   File1=[Filename,FileExt];
   infile1_=[Filepath,File1];
   fid1 = fopen(infile1_,'r');
   if(fread(fid1,1,'long')== 270153200)
      fclose(fid1);
      Translation='Translated  STRANGER File';
      %Translate only STRANGER FILE
      stranger(Filepath,File1);
   else
   status=fseek(fid1,0,-1);
   if strmatch(fread(fid1,3,'char')','new')
      fclose(fid1);
      Translation='Translated PDP File';
      %Translate only PDP FILE
   	PDPOFile=xpdp2mat(Filepath,PDPFile);
   	trues(PDPOFile);
   end
   end
   if(isempty(Translation))
      disp('Input must be either a PDP or a STRANGER file')
   end
end   
if nargin==2
	File1=varargin{1};
	File2=varargin{2};
   [Filepath,Filename,FileExt]=fileparts(File1);
   File1=[Filename,FileExt];
   Filepath=[Filepath,'\'];
   infile1_=[Filepath,File1];
   [Filepath,Filename,FileExt]=fileparts(File2);
   File2=[Filename,FileExt];
   Filepath=[Filepath,'\'];
   infile2_=[Filepath,File2];
   fid1 = fopen(infile1_,'r');
   fid2 = fopen(infile2_,'r');
   if(fread(fid1,1,'long')== 270153200)
      fclose(fid1);
      MNAPFile=File1;
      disp(['Stranger File : ',Filepath,MNAPFile])
      if strmatch(fread(fid2,3,'char')','new')
         fclose(fid2);
         PDPFile=File2;
         disp(['PDP File   : ',Filepath,PDPFile])
      else
         disp('*ERROR* ',Filepath,File2,' is not a PDP file')   
      end
   end
   status=fseek(fid1,0,-1);
   status=fseek(fid2,0,-1);
   if strmatch(fread(fid1,3,'char')','new')
      fclose(fid1);
      PDPFile=File1;
      disp(['PDP File      : ',Filepath,PDPFile])
      if (fread(fid2,1,'long')==270153200)
         fclose(fid2);
         MNAPFile=File2;
         disp(['Stranger File   : ',Filepath,MNAPFile])
      else
         disp('*ERROR* ',Filepath,File2,' is not a Stranger file')   
      end
   end
   Translation='Translated STRANGER File';
   MNAPOFile=stranger(Filepath,MNAPFile);
   Translation='Translated PDP File';
   PDPOFile=xpdp2mat(Filepath,PDPFile);
   trues(PDPOFile);
   Translation='Translated and Merged PDP and STRANGER Files';
   merge(PDPOFile,MNAPOFile);
end
if nargin==3   
   PDPOFile=varargin{1};
	MNAPOFile=varargin{2};
   Translation='Merged separately translated PDP and STRANGER Files';
   trues(PDPOFile);
   merge(PDPOFile,MNAPOFile);
end
