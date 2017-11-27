clc; clear all; close all;

[x,fs]=wavread('arctic_a0001.wav');
%% preprocessing-----------
x=resample(x,8000,fs);
fs=8000;
x=x(:,1);   
x=x./max(abs(x)); %------- normalization-----------
x=x-mean(x);  %------mean subtration----------
% figure;plot(x);grid on;
x=awgn(x,30,'measured'); 
%% Mannual reference markngs
ref{1}=[1651 3500 5635 6850 9258 11090 14950 18570 21800 23600;... %first row starting points
       3200 5400 6800 8770 10010 13820 16840 21300 22580 26650];   %second row ending points		

% ref{1}=[154	1880 4100; 1450	3540 4376];			
% ref{2}=[1 2290 2650 3644; 2100 2480 3200 4376];
% ref{3}=[177	1202 2757 4110; 1078 1885 3880 4376];

tmpp=ref{1};
vseg=[];
uvseg=1:length(x);

for kkk=1:size(tmpp,2)
  vr=tmpp(1,kkk):tmpp(2,kkk);
  vseg=[vseg vr];
  uvseg(vr)=0;
end
uvseg(uvseg==0)=[];

%% Overlapped windowing

L = length(x);
Bl = floor(0.03*fs); % 30 ms long window
for i=L+1:L+1+Bl
    x(i)=0;
end

for i=1:L
    
    Start = i;
    End = i+Bl-1;
    xB = x(Start:End); % current frame
    
    r = Autocorelation(xB);
    Rxx1(i) = r(2);    % feature extraction
    Rxx2(i) = r(3);
    
end

x=x(1:L);

%% threshold computation
n=fs*10e-3;


%% end point detection

[Gr1,SPr1,EPr1,vr1,uvr1]= gate(Rxx1,0.2);  %start point and end point detection
[Gr2,SPr2,EPr2,vr2,uvr2]= gate(Rxx2,0.2);

%% performance measure


[Pcv4,Pcn4,Pc4,Pf4,S4,PP4]=performance_mesures(vseg,uvseg,vr1,uvr1);
[Pcv5,Pcn5,Pc5,Pf5,S5,PP5]=performance_mesures(vseg,uvseg,vr2,uvr2);




%% Plot results



figure;
subplot(3,1,1);plot(x);hold on;plot(Gr1,'r');ylabel('speech');grid on;axis tight;
subplot(3,1,2);plot(Rxx1);hold on;plot(0.2+Rxx1.*0,'r');ylabel('Rxx1');grid on;axis tight;
subplot(3,1,3);plot(x.*Gr1');ylabel('VAD');xlabel('sample no');grid on;axis tight;
hold on;scatter(SPr1,0.*SPr1);hold on;scatter(EPr1,0.*EPr1,'r');

figure;
subplot(3,1,1);plot(x);hold on;plot(Gr2,'r');ylabel('speech');grid on;axis tight;
subplot(3,1,2);plot(Rxx2);hold on;plot(0.2+Rxx2.*0,'r');ylabel('Rxx2');grid on;axis tight;
subplot(3,1,3);plot(x.*Gr2');ylabel('VAD');xlabel('sample no');grid on;axis tight;
hold on;scatter(SPr2,0.*SPr2);hold on;scatter(EPr2,0.*EPr2,'r');


