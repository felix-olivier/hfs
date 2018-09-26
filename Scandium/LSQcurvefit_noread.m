function [warnings, HF_constants,HF_uncert,lineprop, x]=LSQcurvefit_read(Ju,Jl,wavenrJ,Au,Bu,Al,Bl,wavenrOBS, IOBS, lock, uncert,letplot)
%This function fits the spectrum of hfs multiplet and returns the best fit
%hfs constants. (...)
%for plots set letplot=1. For uncertainties set uncert=1.

%% Read data: Observed spectrum: 
data = dlmread('ScData18.txt', ','); %Reads entire file
wavenrOBS=data(:,1); %observed wavenumbers
IOBS=data(:,2); %observed intensities

%% Select data: Extract hfs multiplet from observed spectrum.
mask = (wavenrOBS >= (wavenrJ-0.8)) & (wavenrOBS<=(wavenrJ+0.8)); %select only the transition
wavenrOBS=wavenrOBS(mask);
IOBS=IOBS(mask);


%% Model: Generating a synthetic spectrum of the hfs multiplet.
fun=@(x,wavenrOBS) IcreatorB_lift_fixI(Ju, Jl, x(1), x(2), x(3), x(4), x(5), wavenrOBS, x(6), x(7),x(8));
%anonamous function for the syntethic spectrum.

%% Initial values
%line width guess
T=500; % Temperature in K 
FWHM=7.16*10^-7*wavenrJ*sqrt(T/45)*1.38; %calculates FWHM from Doppler width
stdev=FWHM/2.3548; %std FWHM relation, see Wolfram Alpha

liftguess=0;
MaxIOBS=max(IOBS);
x0=[wavenrJ, Au, Bu, Al, Bl, stdev, liftguess, MaxIOBS]; %initial guesses parameter

%% locking parameters
%standard boundaries for free parameters
lb=[-Inf,-0.2,-0.03,-0.2,-0.03,stdev*0.5,-Inf,-Inf];
ub=[+Inf,+0.2,+0.03,+0.2,+0.03,stdev*1.5,+Inf,+Inf];

if nargin == 13    
    lock2=find(lock); %input parameter 'lock' is an array of zeros and 1s. 1 means locking this parameter
    lb(lock2)=x0(lock2);
    ub(lock2)=x0(lock2);
end

%% Least Squares minimization
[x, ~]=lsqcurvefit(fun,x0,wavenrOBS',IOBS',lb,ub); % this executes the fit.

% Generate synthetic spectrum with the found best fit parameters.
Imodres=fun(x,wavenrOBS); 


%% Compare synthetic and observed spectra with new HF constants
if letplot==1
    width = 3;     % Width in inches
    height = 3;    % Height in inches
    alw = 0.75;    % AxesLineWidth
    fsz = 11;      % Fontsize
    lw = 1.5;      % LineWidth
    msz = 8;       % MarkerSize

    figureindex=1;
    figure(figureindex)
    pos = get(gcf, 'Position');
    set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
    set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
    
    figure(figureindex) %plot observed spectrum
    plot(wavenrOBS, IOBS, '.r' ,'LineWidth',lw,'MarkerSize',msz*1.2)
    hold on

    minwav=min(wavenrOBS);
    maxwav=max(wavenrOBS);
    wavenrstotest=minwav:0.0038/10:maxwav;%get a higher resolution on calculated values

    [Imod,xbar,ybar]=fun(x,wavenrstotest); 
    plot(wavenrstotest, Imod, 'k', 'LineWidth',lw*0.9,'MarkerSize',msz*1.2) % plot synthetic spectrum
    
    xlabel('Wavenumber (cm^-^1)', 'FontSize',16)
    ylabel('SNR', 'FontSize',16)
    h_legend=legend('Observed','Synthetic');
    set(gca,'fontsize',14)
    set(h_legend,'FontSize',18);

    %add bars at line centre
    for i=1:size(xbar,1)
        hold on
        plot(xbar(i,:), ybar(i,:), 'b', 'LineWidth',lw*0.6,'MarkerSize',msz)
        hold on
    end

    hold off
    
    figure(figureindex+1) % residual plot
    pos = get(gcf, 'Position');
    set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
    set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
    
    Res=IOBS-Imodres';
    plot(wavenrOBS, Res, '.', 'MarkerSize',msz*1.2)
    
    xlabel('Wavenumber (cm^-^1)', 'FontSize',16)
    ylabel('Residual', 'FontSize',16)
    set(gca,'fontsize',14) 
 
    
end



% %% plot initial values as well
% if letplot==1
%     figure(figureindex) %initial guess fit
%     plot(wavenrOBS, IOBS, '.')
%     hold on
%     [Iini,xbar,ybar]=fun(x0,wavenrOBS);
%     plot(wavenrOBS, Iini, 'r')
%     xlabel('Wavenumber')
%     ylabel('Intensity')
%     legend('observed','synthetic')
%     
%     %add bars at line centre
%     for i=1:size(xbar,1)
%         hold on
%         plot(xbar(i,:), ybar(i,:), 'g')
%         hold on
%     end
%     
%     hold off
% 
% end



%% Uncertainties on the hfs constants
%if not asked for uncertainty, set to NaN
delAu=NaN; %uncertainty on Au
delBu=NaN;
delAl=NaN;
delBl=NaN;

if uncert==1
    rms2=0.006628; % noise level was determined from observed spectrum
    
    [delAu,delBu,delAl,delBl]=determine_delta(rms2,MaxIOBS,Ju,Jl,x(1),x(2),x(3),x(4),x(5), lock); %use maxIOBS iso. x(8)
    %returns uncertainty on hfs constants

end

%return hfs constants and uncertainties
HF_constants=[x(2), x(3), x(4), x(5)];
HF_uncert=[delAu, delBu,delAl,delBl];



%% check if large changes
changes=x-x0;
warnings=1+find(abs(changes(2:6)>0.003));
warnings(length(warnings)+1:7)=NaN;

%% line properties
[~,xbar,~]=fun(x,wavenrOBS);
hfwidth=max(xbar(:,1))-min(xbar(:,1))+x(6);
resolved=hfwidth./(x(6)*length(xbar(:,1))*0.5);
lineprop=[MaxIOBS, resolved];

