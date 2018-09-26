%Find a relation between delta A,B and signal to noise
clear all
close all

%addpath('C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\Matlab\From laptop\thesis progrm 08 11 2016\R and stdev relation')
addpath(genpath('C:\Users\Felix\Desktop\Thesis full program 16 jan 2017\Base programs'))
%addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016\R and stdev relation')

%% Inputs
Ju=5/2;
Jl=5/2;
wavenrJ=4198.874;
Au=0.005; 
Al=-0.005;
Bu=0;
Bl=0;

stdevnoise=0.006628; %found 0.00586 from FTS file, should I vary this nr with wavenr??

maxIOBS=logspace(log10(stdevnoise), log10(stdevnoise*7500));



%% Create pure hf pattern
[wavenumbers, intensity]=create_hfpat(wavenrJ, Ju, Jl, Au, Bu, Al, Bl); %creates 'pure' hf pattern
%intensity=(maxIOBS.*intensity)./(max(intensity)); %1.7856 is specific for this transition, fix this later!
% figure(5)
% plot(wavenumbers,intensity)
% 
% figure(6)
% plot_synth_obs_func_fordel(wavenumbers, intensity, Ju, Jl, wavenrJ, Au, Bu, Al, Bl)

index_del=0;
for k=1:length(maxIOBS)
    SN=maxIOBS./stdevnoise;
    

        
    n=200; %add random error for n times
    n=30;
    for i=1:n
        
        intensity=(maxIOBS(k).*intensity)./(max(intensity)); 

   
    %error is gaussian with stdev as standard deviation.
        for j=1:length(intensity) % add an error in intensity at each point. 
            intensity(j)=intensity(j)+(randn*stdevnoise); %add noise to intensity
        end

        
        lock=[0 0 1 0 1 0 0 0];
        [ABfit]=fitpure_del_fixI(wavenumbers,intensity,Ju,Jl,wavenrJ,(Au),(Bu),(Al),(Bl),lock);
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
        

    end
    index_del=index_del+1;
%     delAus(index_del)=mean(delAu);
%     delBus(index_del)=mean(delBu);
%     delAls(index_del)=mean(delAl);
%     delBls(index_del)=mean(delBl);
    
%     Aufitmean(index_del)=mean(saveAB(1,:));
%     Bufitmean(index_del)=mean(saveAB(2,:));
%     Alfitmean(index_del)=mean(saveAB(3,:));
%     Blfitmean(index_del)=mean(saveAB(4,:));

    Au_std(index_del)=std(saveAB(1,:));
    Bu_std(index_del)=std(saveAB(2,:));
    Al_std(index_del)=std(saveAB(3,:));
    Bl_std(index_del)=std(saveAB(4,:));
    
    '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    k
    'out of'
    length(maxIOBS)
    '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
    
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

% figure(1)
% plot(stdevnoise,delAus, 'o')

% figure(2)
% plot(SN,delAus, 'o')
% xlabel('Signal to noise ratio')
% ylabel('Delta Au')
% % figure(3)
% % plot(stdevnoise,delAls, 'o')
% 
% figure(4)
% xlabel('Signal to noise ratio')
% ylabel('Delta Al')
% plot(SN,delAls, 'o')

% % figure(7)
% % plot(stdevnoise,delBus, 'o')
% figure(8)
% plot(SN,delBus, 'o')
% xlabel('Signal to noise ratio')
% ylabel('Delta Bu')
% % figure(9)
% % plot(stdevnoise,delBls, 'o')
% 
% figure(10)
% plot(SN,delBls, 'o')
% xlabel('Signal to noise ratio')
% ylabel('Delta Bl')

% figure(11)
% plot(stdevnoise, Au_std, '.')
% figure(12)
% plot(stdevnoise, Al_std, '.')
% figure(13)
% plot(stdevnoise, Bu_std, '.')
% figure(14)
% plot(stdevnoise, Bl_std, '.')

figure(15)
plot(SN, Au_std, '.')
xlabel('Signal to noise ratio')
ylabel('Delta Au (stdev)')

figure(16)
plot(SN, Al_std, '.')
xlabel('Signal to noise ratio')
ylabel('Delta Al (stdev)')


%% for presentation
% Defaults
width = 3;     % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 10;       % MarkerSize

figure(1)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', 13, 'LineWidth', alw); %<- Set properties
plot(SN, Au_std, 'o')
xlabel('Signal to noise ratio','FontSize',20)
ylabel('\Delta A_u','FontSize',20)
xlim([-300 8000])
ylim([-0.001 0.014])

% title('Scandium line in spectrum of Alpha Boo')

figure(2)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', 13, 'LineWidth', alw); %<- Set properties
plot(SN, Al_std, 'o')
xlabel('Signal to noise ratio','FontSize',20)
ylabel('\Delta A_l (stdev)','FontSize',20)


% title('Scandium line in spectrum of Alpha Boo')

figure(3)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', 13, 'LineWidth', alw); %<- Set properties
loglog(SN, Au_std, 'o')
xlabel('Signal to noise ratio','FontSize',20)
ylabel('\Delta A_u','FontSize',20)


% title('Scandium line in spectrum of Alpha Boo')

figure(4)
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', 13, 'LineWidth', alw); %<- Set properties
loglog(SN, Al_std, 'o')
xlabel('Signal to noise ratio','FontSize',20)
ylabel('\Delta A_l','FontSize',20)


% title('Scandium line in spectrum of Alpha Boo')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% figure(17)
% plot(SN, Bu_std, '.')
% xlabel('Signal to noise ratio')
% ylabel('Delta Bu (stdev)')
% 
% figure(18)
% plot(SN, Bl_std, '.')
% xlabel('Signal to noise ratio')
% ylabel('Delta Bl (stdev)')

% % figure(19)
% % plot(1./SN, Au_std, '.')
% % xlabel('1 over Signal to noise ratio')
% % ylabel('Delta Au (stdev)')
% % 
% % figure(20)
% % plot(1./SN, Al_std, '.')
% % xlabel('1 over Signal to noise ratio')
% % ylabel('Delta Al (stdev)')
% % 
% % figure(21)
% % plot(1./SN, Bu_std, '.')
% % xlabel('1 over Signal to noise ratio')
% % ylabel('Delta Bu (stdev)')
% % 
% % figure(22)
% % plot(1./SN, Bl_std, '.')
% % xlabel('1 over Signal to noise ratio')
% % ylabel('Delta Bl (stdev)')
