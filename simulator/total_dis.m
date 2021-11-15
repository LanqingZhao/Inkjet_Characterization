mean1 = csvread("ev_of_lr.csv");
mean2 = csvread("ev_of_gf.csv");
mean3 = csvread("mean_lr.csv");
mean4 = csvread("mean_gf.csv");
k= find(abs(mean2(:,3))<1/12);
n1 =numel(k)/4824*100;
n2 = 100-n1;
fprintf("GF:Abs mean H displacement less than 1 simulated pixel is %.3f percent\n",n1)
fprintf("GF:Abs mean H displacement equal to or more than 1 simulated pixel is %.3f percent\n",n2)
k= find(abs(mean2(:,3))<2/12);
n1 =numel(k)/4824*100;
n2 = 100-n1;
fprintf("GF:Abs mean H displacement less than 2 simulated pixel is %.3f percent\n",n1)
fprintf("GF:Abs mean H displacement equal to or more than 2 simulated pixel is %.3f percent\n",n2)
k= find(abs(mean2(:,3))<3/12);
n1 =numel(k)/4824*100;
n2 = 100-n1;
fprintf("GF:Abs mean H displacement less than 3 simulated pixel is %.3f percent\n",n1)
fprintf("GF:Abs mean H displacement equal to or more than 3 simulated pixel is %.3f percent\n",n2)
% vertical
k= find(abs(mean2(:,4))<1/12);
n1 =numel(k)/4824*100;
n2 = 100-n1;
fprintf("GF:Abs V displacement less than 1 simulated pixel is %.3f percent\n",n1)
fprintf("GF:Abs V displacement equal to or more than 1 simulated pixel is %.3f percent\n",n2)
k= find(abs(mean2(:,4))<2/12);
n1 =numel(k)/4824*100;
n2 = 100-n1;
fprintf("GF:Abs V displacement less than 2 simulated pixel is %.3f percent\n",n1)
fprintf("GF:Abs V displacement equal to or more than 2 simulated pixel is %.3f percent\n",n2)
k= find(abs(mean2(:,4))<3/12);
n1 =numel(k)/4824*100;
n2 = 100-n1;
fprintf("GF:Abs V displacement less than 3 simulated pixel is %.3f percent\n",n1)
fprintf("GF:Abs V displacement equal to or more than 3 simulated pixel is %.3f percent\n",n2)
figure(1)
histogram(mean4(:,3),"BinMethod","fd")
xlabel("Displacement(printer addressable pixel)")
ylabel("Freq")
title("GMM5 Mean distribution of Horizontal displacement:gf")
figure(2)
histogram(mean4(:,4),"BinMethod","fd")
xlabel("Displacement(printer addressable pixel)")
ylabel("Freq")
title("GMM5 Mean distribution of Vertical displacement:gf")