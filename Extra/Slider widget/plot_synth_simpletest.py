import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import file
import numpy as np
import math

def plot_synth_simpletest(Ju, Jl, wavenrJ, Au, Bu, Al, Bl):
##This function plots both an FTS observed transition and a modelled version
##of this spectrum given some values of Au and Al.

#addpath(genpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs'))
##addpath('C:\Users\Felix\Desktop\thesis prgrm part 08 11 2016\thesis progrm 08 11 2016')

#Constants
    Iqnr=3.5# #nuclear spin quantum nr. 7/2 for Scandium
    
#    Ju=0.5
#    Jl=1.5
#    wavenrJ=8081.2+0.04
#    Au=0.075
#    Al=0.018
#    Bu=-0.007
#    Bl=0.005
    
    
    
    # modelled spectrum
    
    # possible F values
    Fu=np.arange(abs(Iqnr-Ju),Iqnr+Ju+1) #possible values for upper F
    Fl=np.arange(abs(Iqnr-Jl),Iqnr+Jl+1) #possible values for lower F
    
#    print Fu
#    print Fl
    
    
    transition_index=0#use as index, but also to see total nr of possible transitions.
    transitionsu=[]#store allowed transitions in this matrix
    transitionsl=[]    
    wavenr=[]#store wavenrs of transitions in here
    I=[]
    
    for i in np.arange(0,len(Fu)):
        
        
        for j in np.arange(0,len(Fl)):
            
            dF=Fu[i]-Fl[j]
    
            if dF==0 and (Fu[i]+Fl[j])!=0 or abs(dF)==1 and Fu[i]+Fl[j]!=0:#selection rules
#                print(Fu[i],Fl[j], Ju, Jl)
                transition_index=transition_index+1
                
                transitionsu.append(Fu[i])
                transitionsl.append(Fl[j])
                
                #transitions[0,transition_index]=Fu[i]
                #transitions[1,transition_index]=Fl[j]
                
                ## Find wavenr for ech transition             
                singlewavenr=wavenrJ+(0.5*Au*file.Ccalc(Fu[i],Ju))-(0.5*Al*file.Ccalc(Fl[j],Jl))+(Bu*file.function_calc(Fu[i],Ju))-(Bl*file.function_calc(Fl[j],Jl)) #contains wavenr of each transition
                wavenr.append(singlewavenr)            
                
                ## Intensities
                sixj=file.sixjsymbol(Jl, Fl[j], Fu[i], Ju)
#                print(sixj)
                Isingle=(2*Fu[i]+1)*(2*Fl[j]+1)*sixj**2#contains relative intensities for each transition
                I.append(Isingle)
#                
    transitions=np.vstack((transitionsu, transitionsl))
    print(transition_index)

#####################EXTRA###################
#    # possible transitions. 
#    transition_index=0#use as index, but also to see total nr of possible transitions.
#    transitions=np.matrix#store allowed transitions in this matrix
#    wavenr=np.array#store wavenrs of transitions in here
#    I=np.array
#    for i in np.arange(0,len(Fu)):
#        for j in np.arange(0,len(Fl)):
#            dF=Fu[i]-Fl[j]
#            print dF
#            if dF==0 and (Fu[i]+Fl[j])!=0 or abs(dF)==1 and Fu[i]+Fl[j]!=0:#selection rules
#                print 'y'                
#                transition_index=transition_index+1
#                
#                transitions[1,transition_index]=Fu(i)
#                transitions[2,transition_index]=Fl(j)
#                
#                ## Find wavenr for ech transition             
#                wavenr[transition_index]=wavenrJ+(0.5*Au*file.Ccalc(Fu(i),Ju))-(0.5*Al*file.Ccalc(Fl(j),Jl))+(Bu*file.function_calc(Fu(i),Ju))-(Bl*file.function_calc(Fl(j),Jl)) #contains wavenr of each transition
#                
#                ## Intensities
#                sixj=file.sixjsymbol(Jl, Fl(j), Fu(i), Ju)
#                I[transition_index]=(2*Fu(i)+1)*(2*Fl(j)+1)*sixj^2#contains relative intensities for each transition
#####################EXTRA###################
    
    ## Line width
    T=500 # put in temperature in K 
    FWHM=7.16*10**-7*wavenrJ*math.sqrt(T/45)*1.38 #calculates FWHM from Doppler width
    stdev=FWHM/2.3548 #std dev. found 2,4548 on wolfram
 
    
    ## Creating lines
    #range=(min(wavenr)-(10*stdev)):0.0005:(max(wavenr)+(10*stdev)) # this is the range of wavenrs that be tested.

    therange=np.arange((min(wavenr)-1),(max(wavenr)+1+0.0038),0.0038)
    
    yvalues=np.zeros(len(therange))
    for k in np.arange(0,transition_index): # for each transition create a Gaussian profile.
        Iuse=mlab.normpdf(therange, wavenr[k], stdev)    
        Iuse=Iuse*I[k]/float(max(Iuse))
        yvalues=yvalues+Iuse
        
    
    
    plt.plot(therange,yvalues)
    plt.show()

    
#
#    
#    #plot both synthetic (in green) and observed spectrum (in red)
#
#    
#
#    mp.plot(range, Itot)
#    # hold on
#    # plot(wavenrOBS,IOBS)
#    #xlabel('Wavenumber')
#    #ylabel('Intensity')
#    #legend('synthetic','observed')
#    # hold off
    
