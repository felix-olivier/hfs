import math
import numpy as np

def sixjsymbol(j1, j3, l1, l3):
#%calculate sixjsymbol with j2=7/2 and l2=1.
    

    
    j2=3.5
    
    l2=1
    A=delta6j(j1,j2,j3)*delta6j(j1,l2,l3)*delta6j(l1,j2,l3)*delta6j(l1,l2,j3)
    lowerk=max(max(j1+j2+j3, j1+l2+l3), max(l1+j2+l3, l1+l2+j3))
    upperk=min(min(j1+j2+l1+l2, j2+j3+l2+l3), j3+j1+l3+l1)
    
    
    B=0

    for k in np.arange(lowerk, upperk+1):# %steps of 1??

        C=(((-1)**k)*math.factorial(k+1))/float((math.factorial(k-j1-j2-j3)*math.factorial(k-j1-l2-l3)*math.factorial(k-l1-j2-l3)*math.factorial(k-l1-l2-j3)))
    
        D=float(1)/(math.factorial(j1+j2+l1+l2-k)*math.factorial(j2+j3+l2+l3-k)*math.factorial(j3+j1+l3+l1-k))
     
        E=C*D
        B=B+E

    I=A*B
    return I

def delta6j(a,b,c):
#%this is a function to calculate delta(abc) for the 6j wigner symbol
    #print(a,b,c)
    A=math.gamma(a+b-c+1)
    B=math.gamma(a-b+c+1)
    
    C=math.gamma(b+c-a+1)
    D=math.gamma(a+b+c+1+1)
    
    y=math.sqrt(A*B*C/float(D))
    return y

def Ccalc(F,J):
    I=3.5# %for Sc
    C=F*(F+1)-J*(J+1)-I*(I+1)
    return C
    
def function_calc(F,J):
    I=3.5
    
    C=F*(F+1)-J*(J+1)-I*(I+1)
    upper=(3*C*(C+1)-4*I*J*(I+1)*(J+1))
    lower=(8*I*J*(2*I-1)*(2*J-1))
    
    
    if upper==0:
        D=0
    elif lower==0:
        D=0
    else: 
        D=upper/float(lower)
    
        
    
    return D