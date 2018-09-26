function [wavenumbers, intensity, resolved]=create_hfpat(wavenrJ, Ju, Jl, Au, Bu, Al, Bl)
%this function generates the spectrum of a hfs multiplet given:
%central wavelength, Au, Bu, Al, Bl, Ju, Jl.

I=7/2; %nuclear spin quantum nr. 7/2 for Scandium


%% Possible F values
Fu=abs(I-Ju):I+Ju; %possible values for upper F
Fl=abs(I-Jl):I+Jl; %possible values for lower F


%% Allowed transitions. 
transition_index=0;%use as index, and total nr of allowed transitions.
transitions=[];%store allowed transitions
wavenr=[];%store wavenrs of hfs transitions
for i=1:length(Fu)
    for j=1:length(Fl)
        dF=Fu(i)-Fl(j);
        if dF==0 && Fu(i)+Fl(j)~=0 || abs(dF)==1 && Fu(i)+Fl(j)~=0;%selection rules
        transition_index=transition_index+1;
        transitions(1,transition_index)=Fu(i);
        transitions(2,transition_index)=Fl(j);
        
        %% Find wavenr for ech transition             
        wavenr(transition_index)=wavenrJ+(0.5*Au*Ccalc(Fu(i),Ju))-(0.5*Al*Ccalc(Fl(j),Jl))+(Bu*function_calc(Fu(i),Ju))-(Bl*function_calc(Fl(j),Jl)); %contains wavenr of each transition
        
        %% Intensities
        sixj=sixjsymbol(Jl, Fl(j), Fu(i), Ju);
%         sixj;
        I(transition_index)=(2*Fu(i)+1)*(2*Fl(j)+1)*sixj^2;%contains relative intensities for each transition
        end
    end
end

%range of wavenumbers to test
wavenumbers=(min(wavenr)-1):0.0038:(max(wavenr)+1);



%% Line width
T=500; % put in temperature in K 
FWHM=7.16*10^-7*wavenrJ*sqrt(T/45)*1.38; %calculates FWHM or Doppler width
width=FWHM/2.3548; %std dev. found 2,4548 on wolfram


yvalues=[]; %this will be the intensity values for a single hf line
for k=1:transition_index; % for each transition create a Gaussian profile.
    Iuse=normpdf(wavenumbers, wavenr(k), width);
    yvalues(k,:)=Iuse*I(k); % in the end contains intensity values for each hf lines on seperate row. multiplied by their relative intensity
end 

intensity=sum(yvalues); %lines are not in seperate rows anymore, only total intensity.



hfwidth=max(wavenr)-min(wavenr)+width;
resolved=hfwidth./(width*length(wavenr));
