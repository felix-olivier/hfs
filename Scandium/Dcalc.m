function D=Dcalc(F,J)
I=7/2; %for Sc

C=F*(F+1)-J*(J+1)-I*(I+1);
upper=(3*C*(C+1)-4*I*J*(I+1)*(J+1));
lower=(8*I*J*(2*I-1)*(2*J-1));


if upper==0
    D=0;
elseif lower==0
    D=0;
else 
    D=upper/lower;
end
    

end