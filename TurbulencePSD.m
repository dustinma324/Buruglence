clear all; close all; clc;
LW = 'LineWidth';

%% File Reading
val = 1;
switch val
    case 1
        ncfile = './DNS_8192.nc';
end

x = ncread(ncfile,'x');
t = ncread(ncfile,'t');
u = ncread(ncfile,'u');
tke = ncread(ncfile,'tke');

dx = x(2)-x(1);
nt = numel(t);
nx = numel(x);
L = 2*pi();
tavg_start = 1001;
step = 10;

%% Mean across time
meanUt = mean(u,1);

% figure
% plot(meanUt,LW,2);
% xlabel('t'); ylabel('<U(t)>'); title('Finding time of statistical independence'); grid;
disp("Burgulence is White in time, mean of normal gaussian distribution is 0")
%graphingStats(x,t,u,tke,L,LW)

%% Auto correlation (For the averaged timesteps)
% This page helped (https://dsp.stackexchange.com/questions/60125/psd-from-autocorrelation-in-matlab)

pwR = [];
R11 = [];
n = length(x);
meanU = mean(u(:,tavg_start:end),2);    % time average from t=100(s) to 200(s)
for i = tavg_start:step:nt
    U11 = double(u(:,i)-meanU);
    Ucorr = xcorr(U11); % Output will be 2*length(Ucorr)
    %R11 = [R11 Ucorr(n:end)];   % Grabbing Auto Correlation
    N = 2^nextpow2(length(Ucorr));  % Go up a power because now I am using symmetrical data for fft
    R_fft = fft(Ucorr,N)/(N^2);
    pwR = [pwR abs(R_fft)];   % The N^2 is still unknown as to why
end
%meanR11 = mean(R11,2);
meanpwR = mean(pwR,2);

%graphingCorrelation(x,meanR11,L,LW)

figure(200)
%hold on
loglog(meanpwR(2:n/2+1),LW,2);
grid on;


%% Power Density (Through Convolution way)
n = length(x); %Nx

pwr = [];
meanU = mean(u(:,tavg_start:end),2);
for i = tavg_start:step:nt
    U_fft = fft(u(:,i)-meanU,n)/n;
    pwr = [pwr U_fft.*conj(U_fft)]; % Convolution of fft function with the autocorrelation
end
meanpwR = mean(pwr,2);

figure(200)
hold on
loglog(meanpwR(2:n/2+1),LW,2);
title('PSD'); ylabel('E(k)'); xlabel('k');
grid on;

%% Legend

hold on
k1 = [1:1e3];
k2 = [1e2:8192];
loglog(k1,k1.^(-1.5)*0.001,'k--',LW,1.5)
loglog(k2,k2.^(-2.75),'k-.',LW,1.5)
axis([1e0 1e4 1e-12 1e-2])
%legend('DNS 16384','DNS 8192','Dynamic Smag 2048','k^{-1.50}','k^{-2.75}')
legend('autocorrelation','convolution','m = -1.50','m = -2.75')
