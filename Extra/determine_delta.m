function [delAus,delBus,delAls,delBls]=determine_delta(rms,MaxIOBS,Ju,Jl,wavenrJ, Au, Bu, Al, Bl,lock)
%this function returns the uncertainty on A and B given the rms of the
%noise.

%addpath('C:\Users\Felix\Desktop\MSc Astrophysics Lund\Thesis\Matlab\thesis progrm 08 11 2016\R and stdev relation')
addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016\R and stdev relation')
%SN=MaxIOBS./rms;

%% create pure hf pattern
[wavenumbers, intensity]=create_hfpat(wavenrJ, Ju, Jl, Au, Bu, Al, Bl); %creates 'pure' hf pattern
intensity=(MaxIOBS.*intensity)./(max(intensity)); %1.7856 is specific for this transition, fix this later!

%% add noise to pure pattern
n=500; %add random error for n times
for i=1:n


%error is gaussian with rms as standard deviation.
    for j=1:length(intensity) % add an error in intensity at each point. 
        intensity(j)=intensity(j)+(randn*rms); %add noise to intensity
    end



    [ABfit,~]=fitpure_del_fixI(wavenumbers,intensity,Ju,Jl,wavenrJ,Au*1.1,Bu*1.1,Al*1.1,Bl*1.1, lock);
    %[resnorm(i), R(i), RSS(i), difference(i,:),x]=fitpure(intensity, wavenumbers, wavenrJ, Ju, Jl, Au, Bu, Al, Bl);
    %R=R squared, coefficient of determination. RSS=residuals squared
    %summed. difference=change after LS fit. x=newly found parameters.
    
    saveAB(:,i)=ABfit;

%     delAu(i)=abs(ABfit(1)-Au);
%     delBu(i)=abs(ABfit(2)-Bu);
%     delAl(i)=abs(ABfit(3)-Al);
%     delBl(i)=abs(ABfit(4)-Bl);

    %Imodsave(i,:)=Imod;
    


end

% delAus=mean(delAu);
% delBus=mean(delBu);
% delAls=mean(delAl);
% delBls=mean(delBl);

delAus=std(saveAB(1,:));
delBus=std(saveAB(2,:));
delAls=std(saveAB(3,:));
delBls=std(saveAB(4,:));


