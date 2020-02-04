function graphingStats(x,t,u,tke,L,LW)
figure
plot(x/L,mean(u,2),LW,2);
xlabel('x/L'); ylabel('<U>'); grid;
figure
plot(x/L,var(u,0,2),LW,2);
xlabel('x/L'); ylabel('Variance (u)'); grid;
figure
plot(x/L,skewness(u,1,2),LW,2);
xlabel('x/L'); ylabel('Skewness (u)'); grid;
figure
plot(x/L,kurtosis(u,1,2),LW,2);
xlabel('x/L'); ylabel('Kurtosis (u)'); grid;
figure
semilogy(t,tke,LW,2);
xlabel('t'); ylabel('TKE'); grid;
end