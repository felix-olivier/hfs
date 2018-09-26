function D=Dcalc_gen(F,J, Iqnr)
% % % % % % I=7/2; %for Sc

C=F*(F+1)-J*(J+1)-Iqnr*(Iqnr+1);
upper=(3*C*(C+1)-4*Iqnr*J*(Iqnr+1)*(J+1));
lower=(8*Iqnr*J*(2*Iqnr-1)*(2*J-1));


if upper==0
    D=0;
elseif lower==0
    D=0;
else 
    D=upper/lower;
end
    

end