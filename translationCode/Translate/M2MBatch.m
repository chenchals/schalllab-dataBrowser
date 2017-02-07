% M2MBatch
% translate PDP and Stranger files into Matlab format and combines them into one file

clear all
p_global

DO_CONVERT = 1; DO_STRANGER = 1; DO_PLX = 1; DO_MERGE = 0; DO_ADD_LFP = 1;

file_path = 'c:\data\convert\';
q='''';c=',';qcq=[q c q];

list=[];

list_sf=dir('c:\data\convert\*ef.*');
list_a=dir('c:\data\convert\*acc.*');
list = [list_sf; list_a];

if (DO_CONVERT == 1)
    
    for i=1:length(list)
        disp('CONVERTING PDP->MATLAB...') 
        ifile_=deblank(list(i).name);
        Updp2mat(file_path,ifile_);
        clear global      
    end
    
end

list=dir('c:\data\convert\*.str');

if (DO_STRANGER == 1)
    
    for i=1:length(list)
        disp('CONVERTING STR->MATLAB...') 
        ifile_=deblank(list(i).name);
        stranger(file_path,ifile_);
        clear global      
    end
    
end

plx_list=dir('c:\data\convert\*.plx');

if (DO_PLX == 1)
    
    for i=1:length(plx_list)
        disp('CONVERTING PLX->MATLAB...') 
        ifile_=deblank(plx_list(i).name);
        plx2mat(file_path,ifile_);
        clear global      
    end
    
end

m_list=dir('c:\data\convert\*_s.*');

if (DO_MERGE == 1)
    
    for i=1:length(m_list)
        disp('MERGE')
        mnap_file=deblank(m_list(i).name);
        pdp_file = mnap_file; pdp_file(8) = 'p';
        %         plx_file = mnap_file; plx_file(8) = 'x';
        mnap_file = strcat('c:\data\convert\',mnap_file);
        pdp_file = strcat('c:\data\convert\',pdp_file);
        %         plx_file = strcat('c:\data\convert\',plx_file);
        if( exist(pdp_file) & exist(mnap_file) )
            if exist(plx_file)
                merge(pdp_file,mnap_file,plx_file);
            else
                merge(pdp_file,mnap_file);
            end
        end
        clear global   
    end
    
end

list_m =dir('c:\data\convert\*_m.*');
list_f =dir('c:\data\convert\*_f.*');
list_all = [list_m; list_f];

if (DO_ADD_LFP == 1)
    
    for i=1:length(list_all)
        disp('ADD LFP TO M-FILES')
        mnap_file=deblank(list_all(i).name);
        plx_file = mnap_file; plx_file(8) = 'x';
        mnap_file = strcat('c:\data\convert\',mnap_file);
        plx_file = strcat('c:\data\convert\',plx_file);
        if( exist(plx_file) & exist(mnap_file) )
            load(plx_file,'Eot_plx','-mat');
            load(mnap_file,'M_Eot','-mat');
            Diff = find(abs(M_Eot(:,1) - Eot_plx(:,1)) >= 2);
            if isempty(Diff)
                load(plx_file,'LFP_1','-mat');
                save(mnap_file,'LFP_1','-append');
            end
        end
    end
    clear global
    
end



