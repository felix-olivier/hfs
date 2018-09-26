function [delAus,delBus,delAls,delBls]=determine_delta(rms,MaxIOBS,Ju,Jl,wavenrJ, Au, Bu, Al, Bl,lock)
%This function returns the uncertainty on the hfs constants by generating
%spectra with artificial noise and calculating the sample standard
%deviation in the best fit hfs constants. rms is the sample standard
%deviation as determined from the observed spectrum.


%% Create pure hfs pattern
[wavenumbers, intensity]=create_hfpat(wavenrJ, Ju, Jl, Au, Bu, Al, Bl); %creates 'pure' hfs pattern
intensity=(MaxIOBS.*intensity)./(max(intensity)); 

%% Add noise to pure pattern
n=500; %add random error for n times
for i=1:n


%error is gaussian with rms as standard deviation.
    for j=1:length(intensity) % add an error in intensity at each point. 
        intensity(j)=intensity(j)+(randn*rms); %add noise to intensity
    end



    [ABfit,~]=fitpure_del_fixI(wavenumbers,intensity,Ju,Jl,wavenrJ,Au*1.1,Bu*1.1,Al*1.1,Bl*1.1, lock); % small ofset in initial values
    saveAB(:,i)=ABfit;


    


end

delAus=std(saveAB(1,:)); %sample standard deviation
delBus=std(saveAB(2,:));
delAls=std(saveAB(3,:));
delBls=std(saveAB(4,:));


