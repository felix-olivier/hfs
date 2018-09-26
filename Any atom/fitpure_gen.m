function [ABfit,Imod]=fitpure_gen(wavenrOBS, IOBS, Ju,Jl,wavenrJ,Au,Bu,Al,Bl, lock, Iqnr)

% max intensity for normalization
MaxIOBS=max(IOBS);

%% Model
fun=@(x,wavenrOBS) IcreatorB_gen(Ju, Jl, x(1), x(2), x(3), x(4), x(5), wavenrOBS, x(6), x(7),x(8), Iqnr);


%% Initial guesses
%line width
T=500; %Temperature in K 
FWHM=7.16*10^-7*wavenrJ*sqrt(T/45)*1.38; %calculates FWHM from Doppler width
stdev=FWHM/2.3548;


x0=[wavenrJ, Au, Bu, Al, Bl, stdev, 0, MaxIOBS]; %initial guesses
lb=[-Inf,-0.2,-0.03,-0.2,-0.03,stdev*0.5,-Inf,-Inf]; %if lock is not given, no boundaries
ub=[+Inf,+0.2,+0.03,+0.2,+0.03,stdev*1.5,+Inf,+Inf];

%% lock parameters
if nargin == 10

    
    lock2=find(lock); %input parameter 'lock' is an array of zeros and 1s. 1 means locking this parameter
    lb(lock2)=x0(lock2);
    ub(lock2)=x0(lock2);
end

%% Least Squares minimization
[x, ~]=lsqcurvefit(fun,x0,wavenrOBS,IOBS,lb,ub);
ABfit=x(2:5);

Imod=fun(x,wavenrOBS); 

