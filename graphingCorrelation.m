function graphingCorrelation(x,meanr11,L,LW)
figure
plot(x/L,meanr11,LW,2)
xlabel('r/L'); ylabel('R_{11}(r)'); title('Auto Correlation Coefficient'); grid;
end