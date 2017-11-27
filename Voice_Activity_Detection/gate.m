function [z,SP,EP,vseg,uvseg]= gate(x,th)
z=0.*x; %-----gate generation for speech signal-------
SP=[]; %----voiced speech segment starting points
EP=[]; %----voiced speech segment ending points

for i=1:length(x)
    
    if(x(i)>=th)
        z(i)=1;
    else
        z(i)=0; 
    end
end


for i=1:length(z)-1
   
   
        if (z(i+1)-z(i))==1
        SP=[SP i];
        end
        
        if (z(i+1)-z(i))==-1
        EP=[EP i];
        end
  
    
end

%%
if SP(1)>EP(1)
    SP=[1 SP];
end

if length(SP)>length(EP)
    EP=[EP length(x)];
end

%
tmpp=[SP;EP];
vseg=[];  % STARTING POINTS OF VOICED FRAMES BETWEEN DETECTED STARTING POINTS AND ENDING POINTS
uvseg=1:length(x); % STARTING POINTS OF NOISE FRAMES DETECTED BETWEEN  ENDING POINTS AND STARTING POINTS

for kkk=1:size(tmpp,2)
    
  vr=tmpp(1,kkk):tmpp(2,kkk);
  vseg=[vseg vr];
  uvseg(vr)=0;
  
end

uvseg(uvseg==0)=[];

end