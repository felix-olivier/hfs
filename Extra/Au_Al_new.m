%Find a relation between delta A,B and signal to noise
clear all
close all

%addpath('C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\Matlab\From laptop\thesis progrm 08 11 2016\R and stdev relation')
% addpath(genpath('C:\Users\Felix\Desktop\Thesis full program 16 jan 2017\Base programs'))
addpath(genpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs'))
% addpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs\Base')
addpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Sensitivity\Aj Bj value\New test')
addpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Fitting routine')
%addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016\R and stdev relation')

%% Inputs
Ju=5/2;
Jl=5/2;
wavenrJ=4114.903;
%Au=-4.598*10^-3; %big errorbars
%Al=0.00513;
Bu=0;
Bl=0;

Au=-0.025:0.004:0.025; 
Al=-0.025:0.004:0.025;
% Au=-0.025:0.008:0.025; %higher resolution later
% Al=-0.025:0.008:0.025;

% Au=-0.015:0.003:0.015; %higher resolution later
% Al=-0.015:0.003:0.015;

% stdevnoise=0.006627522; %found 0.00586 from FTS file, should I vary this nr with wavenr??
stdevnoise=1;

data = dlmread('Scdata18_cal_SNR.txt', ','); %Read entire file
wavenrOBS=data(:,1);
IOBS=data(:,2);

mask = (wavenrOBS >= (wavenrJ-0.5)) & (wavenrOBS<=(wavenrJ+0.5)); %select only the transition
wavenrOBS=wavenrOBS(mask);
IOBS=IOBS(mask);
SN=2000;
maxIOBS=SN;

% maxIOBS=max(IOBS);
% SN=maxIOBS./stdevnoise;

%% Create pure hf pattern
%[wavenumbers, intensity]=create_hfpat(wavenrJ, Ju, Jl, Au, Bu, Al, Bl); %creates 'pure' hf pattern

tic
index_del=0;
for k=1:length(Au)
    for q=1:length(Al)
        [wavenumbers, intensity]=create_hfpat(wavenrJ, Ju, Jl, Au(k), Bu, Al(q), Bl); %creates 'pure' hf pattern



        n=100;%add random error for n times (30 at least)
        for i=1:n

            intensity=(maxIOBS.*intensity)./(max(intensity)); 


        %error is gaussian with stdev as standard deviation.
            for j=1:length(intensity) % add an error in intensity at each point. 
                intensity(j)=intensity(j)+(randn*stdevnoise); %add noise to intensity
            end
            
            figure(k) %%%%%%%%%%%%%%% remove this
            plot(wavenumbers,intensity) %%%%%%%%

%             ABfit=fitpure_del_fixI(wavenumbers,intensity,Ju,Jl,wavenrJ,(0.9*Au(k)),(0.9*Bu),(0.9*Al(q)),(0.9*Bl));
            ABfit=fitpure_del_fixI(wavenumbers,intensity,Ju,Jl,wavenrJ,(Au(k)-0.001),(Bu-0.001),(Al(q)-0.001),(Bl-0.001));
            
            %fitpure returns hfs constants, Best fit resulting intensity and
            %wavenrs with a higher resolution
            %fitpure_del is exactly the same as LSQcurvefit_lock_uncert but
            %takes the observed spectrum as inputs instead of reading these in.

            %[resnorm(i), R(i), RSS(i), difference(i,:),x]=fitpure(intensity, wavenumbers, wavenrJ, Ju, Jl, Au, Bu, Al, Bl);
            %R=R squared, coefficient of determination. RSS=residuals squared
            %summed. difference=change after LS fit. x=newly found parameters.

            saveAB(:,i)=ABfit;

    %         delAu(i)=abs(ABfit(1)-Au);
    %         delBu(i)=abs(ABfit(2)-Bu);
    %         delAl(i)=abs(ABfit(3)-Al);
    %         delBl(i)=abs(ABfit(4)-Bl);

            %Imodsave(i,:)=Imod; %why save this?

        end
        index_del=index_del+1;


        Au_std(index_del)=std(saveAB(1,:));
        Bu_std(index_del)=std(saveAB(2,:));
        Al_std(index_del)=std(saveAB(3,:));
        Bl_std(index_del)=std(saveAB(4,:));



    %     figure(index_del+10)
    %     plot_synth_obs_func_fordel(wavenumbers, intensity, Ju, Jl, wavenrJ, Au, Bu, Al, Bl)
    %     
    %     Imodmean=mean(Imodsave);
    %     figure(10+2*index_del)
    %     plot(wavenrstotest, Imodmean)
    %     hold on
    %     plot(wavenumbers, intensity, '.')
    %     hold off
    end
    k
    'out of'
    length(Au)
end
tm=toc;
nrfits=6*6*3;
tperfit=tm/nrfits;
othertme=tperfit*200*21*21;
% figure(15)
% plot(Au, Au_std, '.')
% xlabel('Value Au')
% ylabel('Delta Au (stdev)')
% 
% figure(16)
% plot(Au, Al_std, '.')
% xlabel('Value Au')
% ylabel('Delta Al (stdev)')
% 
% figure(17)
% plot(Au, Bu_std, '.')
% xlabel('Value Au')
% ylabel('Delta Bu (stdev)')
% 
% figure(18)
% plot(Au, Bl_std, '.')
% xlabel('Value Au')
% ylabel('Delta Bl (stdev)')
% 
% 

%% %%%%%%%%%%%%%%%%%%%%%%% %%
x=Al;
y=Au;

z1=vec2mat(Al_std,length(Al));
z2=vec2mat(Au_std,length(Al));
z3=vec2mat(Bl_std,length(Al));
z4=vec2mat(Bu_std,length(Al));


figure(1)
contourf(x,y,z1)
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Al')

figure(2)
surf(x,y,z1,'EdgeColor','None');
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Al')

figure(3)
contourf(x,y,z2)
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Au')

figure(4)
surf(x,y,z2,'EdgeColor','None');
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Au')

figure(5)
contourf(x,y,z3)
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Bl')

figure(6)
surf(x,y,z3,'EdgeColor','None');
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Bl')

figure(7)
contourf(x,y,z4)
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Bu')

figure(8)
surf(x,y,z4,'EdgeColor','None');
xlabel('Al')
ylabel('Au')
zlabel('Uncertainty on Bu')

