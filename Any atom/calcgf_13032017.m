addpath(genpath('C:\Users\Felix\OneDrive\Thesis full program 16 jan 2017\Base programs'))
%working program on 13/03/2017


%% import data
%import hfs_gf_13032017 as data (all as cell)
%import hfs_gf_13032017 as calcdata (numbers as matrix)
Jl=calcdata(:,3);
Ju=calcdata(:,4);
wavenrJ=calcdata(:,1);
Au=calcdata(:,5);
Bu=calcdata(:,6);
Al=calcdata(:,7);
Bl=calcdata(:,8);
loggf=calcdata(:,2);


allresults=cell(597+length(calcdata),8);
allresults2=cell(597,13);
allresults3=cell(597,13);
counter1=1;
counter2=1;
counter3=1;
%start
for i=1:length(calcdata)
    
    %calculate hf log gf given Ju Jl
    %calculate hf wavenrs
    output=hfgf_calc(Jl(i),Ju(i),wavenrJ(i),Au(i), Bu(i), Al(i), Bl(i), loggf(i));
    
    %put in table
    
    results(counter1:(counter1+length(output)-1),1:5)=output;
    
    counter1=counter1+length(output);
    
    allresults(counter2,1)={data{i,1}};
    allresults(counter2,2)={data{i,12}};
    allresults(counter2,3)={data{i,13}};
    allresults(counter2,4)={data{i,14}};
    allresults(counter2,5)={data{i,9}};
    allresults(counter2,6)={data{i,10}};
    allresults(counter2,7)={data{i,11}};
    allresults(counter2,8)={data{i,2}};
    
    for j=1:(length(output))
        allresults(counter2+j,4)={output(j,3)};
        allresults(counter2+j,5)={output(j,1)};
        allresults(counter2+j,6)={output(j,2)};
        allresults(counter2+j,7)={output(j,4)};
        allresults(counter2+j,8)={output(j,5)};
    end
    
    
    
    %allresults2
    for j=1:length(output)
        allresults2(counter2+j-1,9)={data{i,1}};
        allresults2(counter2+j-1,1)={data{i,12}};
        allresults2(counter2+j-1,2)={data{i,13}};
        allresults2(counter2+j-1,3)={data{i,14}};
        allresults2(counter2+j-1,5)={data{i,9}};
        allresults2(counter2+j-1,6)={data{i,10}};
        allresults2(counter2+j-1,7)={data{i,11}};
        allresults2(counter2+j-1,11)={data{i,2}};
        allresults2(counter2+j-1,12)={data{i,15}};
        
        allresults2(counter2+j-1,10)={output(j,3)};
        allresults2(counter2+j-1,4)={output(j,1)};
        allresults2(counter2+j-1,8)={output(j,2)};
        allresults2(counter2+j-1,12)={output(j,4)};
        allresults2(counter2+j-1,13)={output(j,5)};
    end
    
    
    for j=1:length(output)
        allresults3(counter2+j-1,7)={data{i,1}};
        allresults3(counter2+j-1,1)={data{i,12}};
        allresults3(counter2+j-1,2)={data{i,13}};
        allresults3(counter2+j-1,3)={data{i,14}};
        allresults3(counter2+j-1,4)={data{i,9}};
        allresults3(counter2+j-1,5)={data{i,10}};
        allresults3(counter2+j-1,6)={data{i,11}};
        allresults3(counter2+j-1,8)={data{i,2}};
        allresults3(counter2+j-1,9)={data{i,15}};
        
        allresults3(counter2+j-1,12)={output(j,3)};
        allresults3(counter2+j-1,10)={output(j,1)};
        allresults3(counter2+j-1,11)={output(j,2)};
        allresults3(counter2+j-1,13)={output(j,4)};
        allresults3(counter2+j-1,14)={output(j,5)};
    end
    
    
    counter2=counter2+length(output);
end



%% remove openvolgende config
for q=1:length(allresults3)
    for w=1:length(allresults3)
        if q>w && isequal(allresults3{q,1},allresults3{w,1})&& isequal(allresults3{q,2},allresults3{w,2})&& isequal(allresults3{q,3},allresults3{w,3})&& isequal(allresults3{q,4},allresults3{w,4})&& isequal(allresults3{q,5},allresults3{w,5})&& isequal(allresults3{q,6},allresults3{w,6})
            allresults3{q,1}=[];
            allresults3{q,2}=[];
            allresults3{q,3}=[];
            allresults3{q,4}=[];
            allresults3{q,5}=[];
            allresults3{q,6}=[];
            allresults3{q,7}=[];
            allresults3{q,8}=[];
            allresults3{q,9}=[];
            
        end
        
    end
    
end