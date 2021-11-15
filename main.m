function [package,mean,sd]=main
% THIS IS FINALLY A REAL MAIN FUNCTION, AND ITS ONLY FUNCTION IS TO HELP YOU
% RUN THE CODE TO BUILD THE CELL-BASED DATABASE
%% build database
[package,mean,sd,time1] = data_process("test_data/*/","*.bmp",600,7200,7663.4,7,12,6,24,402);
fprintf("\n\n==========================\nReading the data\n==========================\n")
tic;
fprintf("Reading the displacement\n==========================\n")
%% read displacement related data
read_displacement(package,7);
read_mean_dis(package,12,402)
read_gmm(package,12,402);
time2 =toc;
tic
fprintf("Reading Displacement is complete!\nTime Used:%.4f sec\n==========================\n",time2);
RMSE_table(package,"total_real.csv");
time = toc;
fprintf("Reading RMSE is complete!\nTime Used:%.4f sec\n==========================\n",time);
fprintf("Reading is complete!\nTime Used:%.4f sec\n==========================\n",time2+time);
tic
%% add some missed info and read them
package = add_id(package,402,12);
save("Database_final.mat","package","-v7.3");
read_loglikelihood(package,12,24);
time5 = toc;
fprintf("Reading log likelihood is complete\nTime Used:%.4f sec\n==========================\n",time5);
total_time = time1+time+time2+time5;
fprintf("\n\n==========================\nEverything is done!\nTotal Time Used: %.4f sec\n==========================\n",total_time)
end