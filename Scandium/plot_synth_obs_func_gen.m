function []=plot_synth_obs_func_gen(Ju, Jl, wavenrJ, Au, Bu, Al, Bl, figureindex, data, Iqnr)
%This function plots both an FTS observed transition and a modelled version
%of this spectrum given some values of Au and Al.

% addpath(genpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs'))
%addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016')

%% Constants
% % % Iqnr=7/1; %nuclear spin quantum nr. 7/2 for Scandium

% hfconstants=[ 5/2  	 5/2  	17465.062	0.009356473	-0.002001385	0.005138055	-0.000215149
% ];
% Ju=hfconstants(1);
% Jl=hfconstants(2);
% wavenrJ=hfconstants(3);
% Au=hfconstants(4);
% %Au=-0.03:0.002:0.03;
% %Au=0.0073:0.0001:0.01;
% Bu=hfconstants(5);
% Al=hfconstants(6);
% %Al=-0.03:0.002:0.03;
% Bl=hfconstants(7);

% Ju=2.5;
% Jl=3.5;
% wavenrJ=4530.765;
% Au=0.0098; 
% Al=0.0079;
% Bu=0.0054;
% Bl=0.0126;
%hfc=[0.010211	0	0.008339503	-0.000302543];
% Au=hfc(1);
% Bu=hfc(2);
% Al=hfc(3);
% Bl=hfc(4);


% Ju=2.5;
% Jl=2.5;
% wavenrJ=4465;
% Au=0.02202; 
% Al=0.0512;
% Bu=-0.01639;
% Bl=-0.00043;



%% modelled spectrum

%% possible F values
Fu=abs(Iqnr-Ju):Iqnr+Ju; %possible values for upper F
Fl=abs(Iqnr-Jl):Iqnr+Jl; %possible values for lower F





%% possible transitions. 
transition_index=0;%use as index, but also to see total nr of possible transitions.
transitions=[];%store allowed transitions in this matrix
wavenr=[];%store wavenrs of transitions in here
for i=1:length(Fu)
    for j=1:length(Fl)
        dF=Fu(i)-Fl(j);
        if dF==0 && (Fu(i)+Fl(j))~=0 || abs(dF)==1 && Fu(i)+Fl(j)~=0;%selection rules
        transition_index=transition_index+1;
        transitions(1,transition_index)=Fu(i);
        transitions(2,transition_index)=Fl(j);
        
        %% Find wavenr for ech transition             
        wavenr(transition_index)=wavenrJ+(0.5*Au*Ccalc_gen(Fu(i),Ju, Iqnr))-(0.5*Al*Ccalc_gen(Fl(j),Jl, Iqnr))+(Bu*Dcalc_gen(Fu(i),Ju, Iqnr))-(Bl*Dcalc_gen(Fl(j),Jl, Iqnr)); %contains wavenr of each transition
        
        %% Intensities
        sixj=sixjsymbol_gen(Jl, Fl(j), Fu(i), Ju, Iqnr);
        I(transition_index)=(2*Fu(i)+1)*(2*Fl(j)+1)*sixj^2;%contains relative intensities for each transition
        end
    end
end

%% Line width
T=500; % put in temperature in K 
FWHM=7.16*10^-7*wavenrJ*sqrt(T/45)*1.38; %calculates FWHM from Doppler width
stdev=FWHM/2.3548; %std dev. found 2,4548 on wolfram

%% Creating lines
%range=(min(wavenr)-(10*stdev)):0.0005:(max(wavenr)+(10*stdev)); % this is the range of wavenrs that be tested.
range=(min(wavenr)-1):0.0005:(max(wavenr)+1);
% range=(wavenrJ-0.75):0.0005:(wavenrJ+0.75); % f0r this particuar line

yvalues=[];
for k=1:transition_index; % for each transition create a Gaussian profile.
    Iuse=normpdf(range, wavenr(k), stdev);
    yvalues(k,:)=Iuse*I(k); % in the end contains intensity values for each hf lines on seperate row
end 

Itot=sum(yvalues); %lines are not in seperate rows anymore, only total intensity

%% Observed data
%data = dlmread('ScData18.txt', ','); %Read entire file
% % % % data = dlmread('ScData18_SNR.txt', ','); %Read entire file
wavenrOBS=data(:,1);
IOBS=data(:,2);

mask = (wavenrOBS >= min(range)) & (wavenrOBS<=max(range)); %select only the transition
wavenrOBS=wavenrOBS(mask);
IOBS=IOBS(mask);

%normalize modelled intensity
Itot=Itot*max(IOBS)/max(Itot);

%plot both synthetic (in green) and observed spectrum (in red)
if nargin==7
    figureindex=1;
end
figure(figureindex)
plot(range, Itot, 'g', wavenrOBS, IOBS, '.')
% hold on
% plot(wavenrOBS,IOBS)
xlabel('Wavenumber')
ylabel('Intensity')
legend('synthetic','observed')
% hold off


%% plot for thesis
width = 3;     % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize

figure(100)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties


plot(range, Itot, 'k', wavenrOBS, IOBS, 'r.','LineWidth',lw,'MarkerSize',msz)
h_legend=legend('Synthetic','Observed');

set(h_legend,'FontSize',20);
% hold on
% plot(wavenrOBS,IOBS)
hold on
plot(wavenrOBS,IOBS, '-g' ,'LineWidth',0.5)
xlabel('Wavenumber (cm^{-1})','FontSize',20 )
ylabel('SNR','FontSize',20)

hold off


%% %% %%%% ringing img %%%%%%%%%%%%%%

% 
% mask2 = (wavenrOBS >= 38.5-1) & (wavenrOBS<=38.5+1); %select only the transition
% wavenrnotnoise=wavenrOBS(mask2);
% Inotnoise=IOBS(mask2);
% 
% figure(101)
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
% set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
% 
% 
% plot(wavenrnotnoise, Inotnoise, 'k.','LineWidth',lw,'MarkerSize',msz)
% 
% 
% 
% hold on
% plot(wavenrnotnoise,Inotnoise, '-g' ,'LineWidth',0.5)
% xlabel('Wavenumber (cm^{-1})','FontSize',20 )
% ylabel('SNR','FontSize',20)
% 
% hold off
