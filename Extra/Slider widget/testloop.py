import numpy as np
Iqnr=7/2# #nuclear spin quantum nr. 7/2 for Scandium

Ju=1/2
Jl=3/2
wavenrJ=8081.2+0.04
Au=0.075
Al=0.018
Bu=-0.007
Bl=0.005


Fu=np.arange(abs(Iqnr-Ju),Iqnr+Ju+1) #possible values for upper F
Fl=np.arange(abs(Iqnr-Jl),Iqnr+Jl+1) #possible values for lower F




#####################

#wavenr=[]
##transitions=np.matrix
#for j in np.arange(0,len(Fl)):
#    wavenr.append(j)
#    #transitions[j,j]=Fl[j]
#    
#print(wavenr)
    
    
    

# possible transitions. 
transition_index=0#use as index, but also to see total nr of possible transitions.
#transitions=[]#store allowed transitions in this matrix
wavenr=[]#store wavenrs of transitions in here
I=[]
for i in np.arange(0,len(Fu)):
    
    for j in np.arange(0,len(Fl)):
        
        dF=Fu[i]-Fl[j]

        if dF==0 and (Fu[i]+Fl[j])!=0 or abs(dF)==1 and Fu[i]+Fl[j]!=0:#selection rules

            transition_index=transition_index+1
            
            #transitions[1,transition_index]=Fu(i)
            #transitions[2,transition_index]=Fl(j)
            
            ## Find wavenr for ech transition             
            singlewavenr=wavenrJ+(0.5*Au*file.Ccalc(Fu[i],Ju))-(0.5*Al*file.Ccalc(Fl[j],Jl))+(Bu*file.function_calc(Fu[i],Ju))-(Bl*file.function_calc(Fl[j],Jl)) #contains wavenr of each transition
            wavenr.append(singlewavenr)            
            
            ## Intensities
            sixj=file.sixjsymbol(Jl, Fl[j], Fu[i], Ju)
            print(sixj)
            Isingle=(2*Fu[i]+1)*(2*Fl[j]+1)*sixj**2#contains relative intensities for each transition
            I.append(Isingle)
            
print(wavenr,I)