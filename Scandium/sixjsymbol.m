function I=sixjsymbol(j1, j3, l1, l3)
%Calculate sixjsymbol with j2=7/2 and l2=1.


j2=7/2;
l2=1;
A=delta6j(j1,j2,j3)*delta6j(j1,l2,l3)*delta6j(l1,j2,l3)*delta6j(l1,l2,j3);

lowerk=max(max(j1+j2+j3, j1+l2+l3), max(l1+j2+l3, l1+l2+j3));
upperk=min(min(j1+j2+l1+l2, j2+j3+l2+l3), j3+j1+l3+l1);



B=0;
for k=lowerk:upperk; %steps of 1

    C=(((-1)^k)*factorial(k+1))/(factorial(k-j1-j2-j3)*factorial(k-j1-l2-l3)*factorial(k-l1-j2-l3)*factorial(k-l1-l2-j3));

    D=1/(factorial(j1+j2+l1+l2-k)*factorial(j2+j3+l2+l3-k)*factorial(j3+j1+l3+l1-k));
    E=C*D;
    B=B+E;
end
I=A*B;

