%fit all aboussaids HF constants

%addpath('C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\Matlab\10102016 matlab program full', 'C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\Matlab\thesis progrm 08 11 2016', 'C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\Matlab\thesis progrm 08 11 2016\R and stdev relation')
addpath(genpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs'))
% % % addpath('C:\Users\Felix\OneDrive\Thesis\Initial values')
addpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Fitting routine')
% addpath('C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\tijdelijk\1 april 2017')
addpath('C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\tijdelijk\10 april 2017\recorded lines')

%% read obs data

% data_nb=dlmread('nb2910_noheader.txt');
% wavenrOBS=data_nb(:,1);
% IOBS=data_nb(:,2);

%data = dlmread('ScData18_cal_SNR.txt', ','); %Reads entire file
wavenrOBS=data(:,1);
IOBS=data(:,2);


%read abussaids data
%abu=dlmread('abu.txt');
% abu=xlsread('knownknown.xlsx');


% inputdata=dlmread('UKGOOD.txt', '	');
% % inputdata=dlmread('UKcheck.txt', '	');
% inputdata=dlmread('KKgood.txt', '	');
% inputdata=dlmread('pipeline.txt', '	');

% % Data = fileread('check.txt');
% % Data = strrep(Data, ',', '.');
% % FID = fopen('check2.txt', 'w');
% % fwrite(FID, Data, 'char');
% % fclose(FID);

%inputdata=dlmread('all_secondfit.txt', '	'); %this is used since 27feb2017
% inputdata=dlmread('finalfit.txt'); %used on 30maart2017
% inputdata=dlmread('getuncert_refit2.txt');
% inputdata=dlmread('IV_forrecorded.txt');
inputdata=dlmread('fitoneline.txt');

% inputdata=dlmread('check2.txt', '	');
% inputdata=dlmread('test2.txt', '	');


abu=inputdata;
% Ju=inputdata(:,1);
% Jl=inputdata(:,2);
% wavenrJ=inputdata(:,3);
% Au=inputdata(:,4);
% Bu=inputdata(:,5);
% Al=inputdata(:,6);
% Bl=inputdata(:,7);
IV_tobe=inputdata(:,1:8); %1:7??
wavenrOLD=inputdata(:,8);
origin=inputdata(:,10);
interest=inputdata(:,11);

uncert=0; %set this to 1 if you want to get uncertainties.
letplot=1; %set this to 1 if you want to see resultings fits in plots.
a=size(abu);
height=a(1);


warnings=NaN(height,7);
for q=1:height
    tolock=abu(q,9);
        if tolock==0
            lock=[0,0,0,0,0,0,0];%lock nothing
        elseif tolock==1
            lock=[0,0,1,0,1,0,0];%lock B values
        elseif tolock==2
            lock=[0,0,0,0,0,1,0];%lock width
        elseif tolock==3
            lock=[0,0,1,0,1,1,0];%lock B values and width
        elseif tolock==4
            lock=[0,1,1,0,1,0,0];%fit Al only
        elseif tolock==5
            lock=[0,0,1,1,1,0,0];%fit Au only
        elseif tolock==6
            lock=[0,1,1,1,1,0];%fit wavenrJ only
        elseif tolock==8
            lock=[0,0,1,0,0,0];%fit wavenrJ only
        elseif tolock==10
            lock=[0,1,1,1,1,1,0];
            
                                
            
        
        end
%     figureindex=(2*q)-1;
    
    %[x(i,:), HF_constants(i)]=LSQcurvefit_lock_uncert_abussaid(Ju,Jl,wavenrJ,Au,Bu,Al,Bl,uncert,figureindex,lock);
    %[x(q,:), HF_constants(q)]=LSQcurvefit_lock_uncert_abussaid(abu(q,1), abu(q,2), abu(q,3), abu(q,4), abu(q,5), abu(q,6), abu(q,7),0,figureindex);
    
    %works::[x,HF]=LSQcurvefit_lock_uncert_abussaid(abu(q,1), abu(q,2), abu(q,3), abu(q,4), abu(q,5), abu(q,6), abu(q,7),0,figureindex);
    
%     plot_synth_obs_func_forAbou(abu(q,1), abu(q,2), abu(q,3), abu(q,4), abu(q,5), abu(q,6), abu(q,7), (figureindex+height*2))
    %plot_synth_obs_func_forAbou(abu2(q,1), abu2(q,2), abu2(q,3), abu2(q,4), abu2(q,5), abu2(q,6), abu2(q,7), figureindex+height*2)
%     plot_synth_obs_func_noread(abu(q,1), abu(q,2), abu(q,3), abu(q,4), abu(q,5), abu(q,6), abu(q,7),q, wavenrOBS, IOBS)
    [betweener, HF(q,1:4),HF_uncert(q,1:4), lineprop(q,1:2),x]=LSQcurvefit_lock_uncert_fixI_noread_new(abu(q,1), abu(q,2), abu(q,3), abu(q,4), abu(q,5), abu(q,6), abu(q,7),wavenrOBS, IOBS,q,uncert,letplot,lock);
%     LSQcurvefit_lock_uncert_fixI_noread(abu(q,1), abu(q,2), abu(q,3), abu(q,4), abu(q,5), abu(q,6), abu(q,7),wavenrOBS, IOBS,q,uncert, 0);
    warnings(q,1:length(betweener))=betweener;
    HF(q,5)=wavenrOLD(q);
    HF(q,6)=origin(q);
    savewave(q)=x(1);
    
    if interest(q) == 1
        HF_int(q,1:4)=[HF(q,1) ,HF_uncert(q,1),HF(q,2) ,HF_uncert(q,2)];
        
        
    elseif interest(q)==0
            HF_int(q,1:4)=[HF(q,3) ,HF_uncert(q,3),HF(q,4) ,HF_uncert(q,4)];
    end
        
            
            %saveHF(:,figureindex:figureindex+1)=HF;

    
end


%% write into results file to check for consistancy (could also put this in previous loop)
tobecomeresults=dlmread('wavenrsOLD.txt', '	');
tobecomeresults(1:length(tobecomeresults),2:7)=NaN;
allwarn=dlmread('wavenrsOLD.txt', '	');
allwarn(1:length(tobecomeresults),2:8)=NaN;
for j=1:length(tobecomeresults)
    testvalue=tobecomeresults(j);
    for k=1:height
        if testvalue==HF(k,5)
            tobecomeresults(j,2:7)=HF(k,1:6);
            allwarn(j,2:8)=warnings(k,1:7);
        end
    end
end

% xlswrite('combineintotable5.xlsx',tobecomeresults);

tobecomeresults2=dlmread('wavenrsOLD.txt', '	');
tobecomeresults2(1:length(tobecomeresults2),2:7)=NaN;
for j=1:length(tobecomeresults2)
    testvalue=tobecomeresults2(j);
    for k=1:height
        if testvalue==HF(k,5)
            tobecomeresults2(j,1:7)=IV_tobe(k,1:7);
        end
    end
end

% xlswrite('combineintotable6.xlsx',tobecomeresults2);

if uncert==1
    tobecomeresults3=dlmread('wavenrsOLD.txt', '	');
    tobecomeresults3(1:length(tobecomeresults3),4)=NaN;
    for j=1:length(tobecomeresults3)
        testvalue=tobecomeresults3(j);
        for k=1:height
            if testvalue==HF(k,5)
                tobecomeresults3(j,1:4)=HF_uncert(k,1:4);
            end
        end
    end
end


%% test for sc overlaps
overlaps=dlmread('scoverlaps.txt');
y=1;
for e=1:length(overlaps)
    for r=1:length(tobecomeresults)
        if overlaps(e)==tobecomeresults(r,1)
            overlapwarn(r)=1;
            
        else
%             overlapwarn(y)=0;
        end
        
    end
%     y=y+1;
end
% overlapwarn=overlapwarn';

%add maxIOBS 
tobecomeresults4=dlmread('wavenrsOLD.txt', '	');
tobecomeresults4(1:length(tobecomeresults4),2:3)=NaN;
for j=1:length(tobecomeresults4)
    testvalue=tobecomeresults4(j);
    for k=1:height
        if testvalue==HF(k,5)
            tobecomeresults4(j,2:3)=lineprop(k,1:2);
        end
    end
end


%% make recorded table
recorded=cell(230, 3);
for i=1:length(savewave)
    recorded{i,1}=savewave(i);
    recorded{i,2}=lineprop(i,1);
    recorded{i,3}=lineprop(i,2);
end


