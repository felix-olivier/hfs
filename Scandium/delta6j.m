function [y]=delta6j(a,b,c)
%this function calculates delta(abc) for the 6j wigner symbol

%use gamma function instead of factorial in case of half integers
A=gamma(a+b-c+1);
B=gamma(a-b+c+1);
C=gamma(b+c-a+1);
D=gamma(a+b+c+1+1);

y=sqrt(A*B*C/D);
end

