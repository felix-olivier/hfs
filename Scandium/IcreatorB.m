function [Itot, xbar, ybar]=IcreatorB(Ju, Jl, wavenrJ, Au, Bu, Al, Bl, wavenrs, stdev,lift, MaxIOBS)
%this function creates a model of the intensity for some range of wavenumbers.


Iqnr=7/2; %nuclear spin quantum nr. 7/2 for Scandium %9/2 for Nb!


%% Possible F values
Fu=abs(Iqnr-Ju):Iqnr+Ju; %possible values for upper F
Fl=abs(Iqnr-Jl):Iqnr+Jl; %possible values for lower F

%% Allowed transitions. 
transition_index=0;%use as index, but also to see total nr of possible transitions.
transitions=[];%store allowed transitions in this matrix
wavenr=[];%store wavenrs of transitions in here
for i=1:length(Fu)
    for j=1:length(Fl)
        dF=Fu(i)-Fl(j);
        if dF==0 && Fu(i)+Fl(j)~=0 || abs(dF)==1 && Fu(i)+Fl(j)~=0;%selection rules
        transition_index=transition_index+1;
        transitions(1,transition_index)=Fu(i);
        transitions(2,transition_index)=Fl(j);
        
        %% Find wavenr for each transition             
        wavenr(transition_index)=wavenrJ+(0.5*Au*Ccalc(Fu(i),Ju))-(0.5*Al*Ccalc(Fl(j),Jl))+(Bu*function_calc(Fu(i),Ju))-(Bl*function_calc(Fl(j),Jl)); %contains wavenr of each transition
        
        %% Relative Intensities
        sixj=sixjsymbol(Jl, Fl(j), Fu(i), Ju);
        I(transition_index)=(2*Fu(i)+1)*(2*Fl(j)+1)*sixj^2;%contains relative intensities for each transition
        end
    end
end

%% Gaussian for each hfs transition
yvalues=[];
for k=1:transition_index; % for each transition create a Gaussian profile.
    Iuse=normpdf(wavenrs, wavenr(k), stdev);
    yvalues(k,:)=Iuse*I(k); % in the end contains intensity values for each hf lines on seperate row
end 
Itot=sum(yvalues); %lines are not in seperate rows anymore, only total intensity

% normalize intensity 
Itot=Itot.*MaxIOBS/max(Itot);
%Lift continuum (caused by blackbody radiation)
Itot=Itot+lift;


%return line centres for plots
xbar=[];
ybar=[];

for k=1:transition_index;
    xbar(k,:)=[wavenr(k),wavenr(k)];
    ybar(k,:)=[0, I(k)*MaxIOBS/(2*max(I))]; %not actual intensities, just scalin
end
