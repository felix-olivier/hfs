import file
import numpy as np

def plot_synth(Ju, Jl, wavenrJ, Au, Bu, Al, Bl, figureindex):
##This function plots both an FTS observed transition and a modelled version
##of this spectrum given some values of Au and Al.

#addpath(genpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs'))
##addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016')

#Constants
    Iqnr=7/2# #nuclear spin quantum nr. 7/2 for Scandium


# modelled spectrum

# possible F values
    Fu=np.arange(abs(Iqnr-Ju),Iqnr+Ju) #possible values for upper F
    Fl=np.arange(abs(Iqnr-Jl),Iqnr+Jl) #possible values for lower F





    # possible transitions. 
    transition_index=0#use as index, but also to see total nr of possible transitions.
    transitions=[]#store allowed transitions in this matrix
    wavenr=[]#store wavenrs of transitions in here
    for i in np.arange(1,length(Fu)):
        for j in np.arange(1,length(Fl)):
            dF=Fu(i)-Fl(j)
            if dF==0 & (Fu(i)+Fl(j))!=0 | abs(dF)==1 & Fu(i)+Fl(j)!=0:#selection rules
                transition_index=transition_index+1
                transitions(1,transition_index)=Fu(i)
                transitions(2,transition_index)=Fl(j)
                
                ## Find wavenr for ech transition             
                wavenr(transition_index)=wavenrJ+(0.5*Au*Ccalc(Fu(i),Ju))-(0.5*Al*Ccalc(Fl(j),Jl))+(Bu*function_calc(Fu(i),Ju))-(Bl*function_calc(Fl(j),Jl)) #contains wavenr of each transition
                
                ## Intensities
                sixj=sixjsymbol(Jl, Fl[j], Fu[i], Ju)
                I(transition_index)=(2*Fu(i)+1)*(2*Fl(j)+1)*sixj^2#contains relative intensities for each transition

    
    ## Line width
    T=500 # put in temperature in K 
    FWHM=7.16*10^-7*wavenrJ*sqrt(T/45)*1.38 #calculates FWHM from Doppler width
    stdev=FWHM/2.3548 #std dev. found 2,4548 on wolfram
    
    ## Creating lines
    #range=(min(wavenr)-(10*stdev)):0.0005:(max(wavenr)+(10*stdev)) # this is the range of wavenrs that be tested.
    therange=np.arange((min(wavenr)-1),(max(wavenr)+1),0.0005)
    
    
    yvalues=np.matrix('')
    for k in np.arange(1,transition_index): # for each transition create a Gaussian profile.
        Iuse=normpdf(therange, wavenr(k), stdev)
        yvalues[k,:]=Iuse*I(k) # in the end contains intensity values for each hf lines on seperate row

    
    Itot=sum(yvalues) #lines are not in seperate rows anymore, only total intensity
    
    ## Observed data
    data = load('ScData18.txt', delimiter=',') #Read entire file
    #data = dlmread('ScData18_SNR.txt', ',') #Read entire file
    data=np.matrix(data)    
    wavenrOBS=data[:,1]
    IOBS=data[:,2]
    
    mask = (wavenrOBS >= min(therange)) & (wavenrOBS<=max(therange)) #select only the transition
    
    wavenrOBS=wavenrOBS[mask]
    IOBS=IOBS[mask]
    
    #normalize modelled intensity
    Itot=Itot*max(IOBS)/max(Itot)
    
    #plot both synthetic (in green) and observed spectrum (in red)
    if figureindex==nan:
        figureindex=1
    
    figure(figureindex)
    plot(range, Itot, 'g', wavenrOBS, IOBS, '.')
    # hold on
    # plot(wavenrOBS,IOBS)
    xlabel('Wavenumber')
    ylabel('Intensity')
    legend('synthetic','observed')
    # hold off
    
