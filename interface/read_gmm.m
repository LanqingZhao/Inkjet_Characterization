function read_gmm(pack,num_nozz,num_cell)
%% SUMMARY
%This function takes database,number of nozzles per cell, and the number of
%cells as input and save the bic and mean displacement from 4 different
%Gaussian Mixture Model.
filename1 ="bic_lr.csv";
filename2 ="bic_gf.csv";
filename3 ="mean_lr.csv";
filename4= "mean_gf.csv";
mean1 = zeros(num_nozz*num_cell,14);
mean2 = zeros(num_nozz*num_cell,14);
b1 = zeros(num_nozz*num_cell,14);
b2 = zeros(num_nozz*num_cell,14);
ct = 1;
for i = 1:numel(pack)
    for j= 1:num_nozz
        %cell number assigned
        mean1(ct,1) = i;
        mean2(ct,1) = i;
        b1(ct,1) = i;
        b2(ct,1) = i;
        %nozzle number assigned
        mean1(ct,2) = j;
        mean2(ct,2) = j;
        b1(ct,2) = j;
        b2(ct,2) = j;
        %assign mean and bic for linear regression
        %mean
        mean1(ct,3) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM3.mean;
        mean1(ct,4) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM3.mean;
        mean1(ct,5) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM4.mean;
        mean1(ct,6) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM4.mean;
        mean1(ct,7) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM5.mean;
        mean1(ct,8) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM5.mean;
        mean1(ct,9) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM6.mean;
        mean1(ct,10) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM6.mean;
        mean1(ct,11) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM7.mean;
        mean1(ct,12) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM7.mean;
        mean1(ct,13) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM8.mean;
        mean1(ct,14) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM8.mean;
        %bic
        b1(ct,3) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM3.Model.BIC;
        b1(ct,4) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM3.Model.BIC;
        b1(ct,5) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM4.Model.BIC;
        b1(ct,6) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM4.Model.BIC;
        b1(ct,7) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM5.Model.BIC;
        b1(ct,8) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM5.Model.BIC;
        b1(ct,9) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM6.Model.BIC;
        b1(ct,10) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM6.Model.BIC;
        b1(ct,11) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM7.Model.BIC;
        b1(ct,12) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM7.Model.BIC;
        b1(ct,13) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.GMM8.Model.BIC;
        b1(ct,14) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM8.Model.BIC;
        %assign mean and bic for grid fit
        %mean
        mean2(ct,3) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM3.mean;
        mean2(ct,4) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM3.mean;
        mean2(ct,5) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM4.mean;
        mean2(ct,6) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM4.mean;
        mean2(ct,7) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM5.mean;
        mean2(ct,8) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM5.mean;
        mean2(ct,9) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM6.mean;
        mean2(ct,10) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM6.mean;
        mean2(ct,11) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM7.mean;
        mean2(ct,12) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM7.mean;
        mean2(ct,13) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM8.mean;
        mean2(ct,14) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM8.mean;
        %bic
        b2(ct,3) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM3.Model.BIC;
        b2(ct,4) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM3.Model.BIC;
        b2(ct,5) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM4.Model.BIC;
        b2(ct,6) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM4.Model.BIC;
        b2(ct,7) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM5.Model.BIC;
        b2(ct,8) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM5.Model.BIC;
        b2(ct,9) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM6.Model.BIC;
        b2(ct,10) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM6.Model.BIC;
        b2(ct,11) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM7.mean;
        b2(ct,12) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM7.mean;
        b2(ct,11) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.GMM8.mean;
        b2(ct,12) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM8.mean;
        ct = ct+1;
    end
    fprintf("Complete reading bic of cell#%d\n",i)
end
csvwrite(filename1,b1)
csvwrite(filename2,b1)
csvwrite(filename3,mean1)
csvwrite(filename4,mean2)
end
