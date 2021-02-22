clear all; close all; clc        
%% Load GNR song
figure(1)
[y, Fs] = audioread('GNR.m4a');
tr_gnr = length(y)/Fs; 
% record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Sweet Child O Mine');
p8 = audioplayer(y,Fs); 
playblocking(p8);
%% Filtering for GNR
yT = y';
L = 14;
n = length(yT);
t2 = linspace(0,L,n+1); t = t2(1:n);
k = (1/L)*[0:n/2-1 -n/2:-1];
ks = fftshift(k);
tau = 0:0.1:14;
a = 100;
notes = zeros(1,length(tau));
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*yT;
   Sgt = fft(Sg);
   Sgts = fftshift(abs(Sgt));
   [mv,idx] = max(Sgts);
   notes(j) = abs(ks(idx));
   Sgt_spec(:,j) = Sgts;
end
%% Recreating the music score
scatter(tau,notes);
yticks([277.18,293.66,311.13,349.23,369.99,392,415.3,554.37,698.46,739.99]);
yticklabels({'C^{#}_{4}','D_{4}','D^{#}_{4}','F_{4}','F^{#}_{4}','G_{4}','G^{#}_{4}','C^{#}_{5}','F_{5}','F^{#}_{5}'});
ylim([260 800]);
title('Music score for Sweet Child O Mine')
xlabel('Time in second');
ylabel('Note corresponding to the frequency');
%% Create Spectrogram 
pcolor(tau,ks,guitar)
shading interp
set(gca,'ylim',[0 1000],'Fontsize',12)
colormap(hot)
colorbar
xlabel('time (seconds)'), ylabel('frequency (Hz)')
title('Possible guitar solo for Comfortably Numb with a = 1000 from time 0 to 15 seconds')
%% Load Floyd song
figure(1)
[y, Fs] = audioread('Floyd.m4a');
tr_gnr = length(y)/Fs; 
% record time in seconds
plot((1:length(y))/Fs,y);
xlabel('Time [sec]'); ylabel('Amplitude');
title('Comfortably Numb');
% p8 = audioplayer(y,Fs); 
% playblocking(p8);
%% Initiate the frequency of the each note
yT = y';
yT = yT(1:2635920);
n = length(yT);
L = ceil(tr_gnr);
t2 = linspace(0,L,n+1); t = t2(1:n);
k = (1/L)*[0:n/2-1 -n/2:-1];
ks = fftshift(k);
big_time = 0:0.5:L;
notes = zeros(1,length(big_time));
%% Floyd's clip 0 to 15 sec
tau = 0:0.5:15;
a = 1000;
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*yT;
   Sgt = fft(Sg);
   Sgts = fftshift(abs(Sgt));
   [mv,idx] = max(Sgts);
   notes(j) = abs(ks(idx));
   Sgt_spec1(:,j) = Sgts;
end
%% Floyd's clip 15 to 30 sec
tau = 15.5:0.5:30;
nidx = j+1;
a = 1000;
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*yT;
   Sgt = fft(Sg);
   Sgts = fftshift(abs(Sgt));
   [mv,idx] = max(Sgts);
   notes(nidx) = abs(ks(idx));
   nidx = nidx + 1;
   Sgt_spec2(:,j) = Sgts;
end
%% Floyd's clip 30 to 45 sec
tau = 30.5:0.5:45;
a = 1000;
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*yT;
   Sgt = fft(Sg);
   Sgts = fftshift(abs(Sgt));
   [mv,idx] = max(Sgts);
   notes(nidx) = abs(ks(idx));
   nidx = nidx + 1;
   Sgt_spec3(:,j) = Sgts;
end
%% Floyd's clip 45 to 60 sec
tau = 45.5:0.5:60;
a = 1000;
for j = 1:length(tau)
   g = exp(-a*(t - tau(j)).^2); 
   Sg = g.*yT;
   Sgt = fft(Sg);
   Sgts = fftshift(abs(Sgt));
   [mv,idx] = max(Sgts);
   notes(nidx) = abs(ks(idx));
   nidx = nidx + 1;
   Sgt_spec4(:,j) = Sgts;
end
%% Recreating music score for Floyd
tau = 0:0.5:60;
scatter(tau,notes);
yticks([82.41,92.5,98,110,123.47,146.83,164.81,185,196,246.94]);
yticklabels({'E_{2}','F^{#}_{2}','G_{2}','A_{2}','B_{2}','D_{3}','E_{3}','F^{#}_{3}','G_{3}','B_{3}'});
ylim([60,250]);
title('Music score for Comfortably Numb');
xlabel('Time in seconds');
ylabel('Note corresponding to the frequency');
%% Bass isolation
cent_freq = 1:1:121;
tau = 0:0.5:15;
for j = 1:length(tau)
   Sgts = Sgt_spec1(:,j)';
   currF = notes(cent_freq(j));
   filter = exp(-0.5*(ks - currF).^2);
   Sgtsf = Sgts .* filter;
   bass(:,j) = Sgtsf;
end
%% Guitar solo
cent_freq = 1:1:121;
tau = 0:0.5:15;
for j = 1:length(tau)
    Sgts = Sgt_spec1(:,j)';
    currF = notes(cent_freq(j));
    filter = ks > 255;
    Sgtsf = Sgts .* filter;
    overtone1 = 1 - exp(-0.0001*(ks - currF*2).^2);
    Sgtsf = Sgtsf .* overtone1;
    overtone2 = 1- exp(-0.0001*(ks - currF*3).^2);
    Sgtsf = Sgtsf .* overtone2;
    overtone3 = 1 - exp(-0.0001*(ks - currF*4).^2);
    Sgtsf = Sgtsf .* overtone3;
    overtone4 = 1 - exp(-0.0001*(ks - currF*5).^2);
    Sgtsf = Sgtsf .* overtone4;
    overtone5 = 1 - exp(-0.0001*(ks - currF*6).^2);
    Sgtsf = Sgtsf .* overtone5;
    overtone6 = 1 - exp(-0.0001*(ks - currF*7).^2);
    Sgtsf = Sgtsf .* overtone6;
    guitar(:,j) = Sgtsf;
end