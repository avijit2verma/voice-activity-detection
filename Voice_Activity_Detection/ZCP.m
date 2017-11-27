function[N] = ZCP(x)
    N=0;t=0;
    for i=1: (length(x)-1)
        a=x(i);
        b=x(i+1);
        if(a*b<=0)
            N=N+1;
        end
       
    end
  N=N/length(x);
end