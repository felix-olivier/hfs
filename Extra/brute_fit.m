%This programs does a brute fit to look for initial guesses of A and B.
% If hf constants are unknown for upper or lower or both levels, make an
% array of Au values to test
close all
addpath(genpath('C:\Users\Felix\Desktop\Thesis full program 16 jan 2017\Base programs'))
addpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs\Base')
%addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016')
% Ju=5/2;
% Jl=5/2;
% wavenrJ=4198.874;
% Au=9.667*10^-3;
% Bu=0;
% % Al=0.00513;
% % Bl=-2.15*10^-4;
% Al=-0.03:0.002:0.03;
% % Al=0.004:0.001:0.006;
% Bl=0.00;

hfconstants=[1/2  	 3/2  	7631.6	0.07	0	0.019907105	-0.001834603
];
Ju=hfconstants(1);
Jl=hfconstants(2);
wavenrJ=hfconstants(3);
Au=hfconstants(4);
Au=-0.03:0.002:0.03;
Au=0.06:0.003:0.08;

Bu=hfconstants(5);

Al=hfconstants(6);
Al=-0.03:0.002:0.03;
Al=0.015:0.0015:0.025;
% Al=0.01:0.0004:0.018;
Bl=hfconstants(7);




%% read data
%% Observed data
%data = dlmread('ScData18.txt', ','); %Read entire file
% data = dlmread('ScData18_cal_SNR.txt', ','); %Reads entire file
wavenrOBS=data(:,1);
IOBS=data(:,2);

mask = (wavenrOBS >= (wavenrJ-0.5)) & (wavenrOBS<=(wavenrJ+0.5)); %select only the transition
wavenrOBS=wavenrOBS(mask);
IOBS=IOBS(mask);

%% plot synthetic
figureindex=0;
for i=1:length(Au)
    for j=1:length(Al)
        for k=1:length(Bu)
            for l=1:length(Bl)
                figureindex=figureindex+1;
                plot_synth_obs_func_forBruteFit(Ju, Jl, wavenrJ, Au(i), Bu(k), Al(j), Bl(l), wavenrOBS, IOBS, figureindex)
            end
        end      
    end
end
