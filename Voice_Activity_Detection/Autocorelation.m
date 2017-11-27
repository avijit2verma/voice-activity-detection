function [r] = pr7_Autocorelation(x)
    L=length(x);
    for i=1:1:L
        r(i)=0;
        for j=1:1:(L-i+1)
            r(i)= r(i)+x(j)*x(j+i-1);
        end
        
       
    end
    
    r=r./r(1);
end
