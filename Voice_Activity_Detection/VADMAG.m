clc; clear all; close all;

[x,fs]=wavread('arctic_a0001.wav');
%% preprocessing-----------
x=resample(x,8000,fs);
fs=8000;
x=x(:,1);  

x=x./max(abs(x)); %------- normalization-----------
x=x-mean(x);  %------mean subtration----------
figure;plot(x);ylabel('Normalized voice magnitude');xlabel('Sample no');grid on;axis tight;
x=awgn(x,30,'measured'); 
%% Mannual reference markings
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
    
    mag(i) = sum(abs(xB)); % feature extraction
end

x=x(1:L);

%% threshold computation
n=fs*10e-3;
% mag_th= adaptive_th(mag,n);
mag_th= threshold(mag);
%% end point detection
[Gmag,SPmag,EPmag,vmag,uvmag]= gate(mag,mag_th);


%% performance measure

[Pcv1,Pcn1,Pc1,Pf1,S1,PP1]=performance_mesures(vseg,uvseg,vmag,uvmag);



%% Plot results



figure;
subplot(3,1,1);plot(x);hold on;plot(Gmag,'r');ylabel('speech');grid on;axis tight;
subplot(3,1,2);plot(mag);hold on;plot(mag_th+mag.*0,'r');ylabel('AE');grid on;axis tight;
subplot(3,1,3);plot(x.*Gmag');ylabel('VAD');xlabel('sample no');grid on;axis tight;
hold on;scatter(SPmag,0.*SPmag);hold on;scatter(EPmag,0.*EPmag,'r');

