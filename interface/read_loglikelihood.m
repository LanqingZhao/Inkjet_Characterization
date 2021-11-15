function read_loglikelihood(package,num_nozz,num_block)
%% Summary 
%This function reads log likelihood of each gmm and bic of kde
%% Function Body
like = zeros(num_nozz*num_block,16);
like2 = zeros(num_nozz*num_block,16);
b = zeros(num_nozz*num_block,6);
ct = 1;
% read the data
for i = 1:numel(package)
    for j = 1:num_nozz
        like(ct,1) =i;
        like2(ct,1)= i;
        like(ct,2) = j;
        like2(ct,2) =j;
        b(ct,1) =i;
        b(ct,2) = j;
        %lr loglikelihood
        like(ct,3) = package(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.loglikelihood;
        like(ct,4) = package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.loglikelihood;
        like(ct,5) = -package(1).Horizontal_Estimate.Nozzle(1).Linear_Regression.GMM3.Model.NegativeLogLikelihood;
        like(ct,6) = -package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM3.Model.NegativeLogLikelihood;
        like(ct,7) = -package(1).Horizontal_Estimate.Nozzle(1).Linear_Regression.GMM4.Model.NegativeLogLikelihood;
        like(ct,8) = -package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM4.Model.NegativeLogLikelihood;
        like(ct,9) = -package(1).Horizontal_Estimate.Nozzle(1).Linear_Regression.GMM5.Model.NegativeLogLikelihood;
        like(ct,10) = -package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM5.Model.NegativeLogLikelihood;
        like(ct,11) = -package(1).Horizontal_Estimate.Nozzle(1).Linear_Regression.GMM6.Model.NegativeLogLikelihood;
        like(ct,12) = -package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM6.Model.NegativeLogLikelihood;
        like(ct,13) = -package(1).Horizontal_Estimate.Nozzle(1).Linear_Regression.GMM7.Model.NegativeLogLikelihood;
        like(ct,14) = -package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM7.Model.NegativeLogLikelihood;
        like(ct,15) = -package(1).Horizontal_Estimate.Nozzle(1).Linear_Regression.GMM8.Model.NegativeLogLikelihood;
        like(ct,16) = -package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.GMM8.Model.NegativeLogLikelihood;
        %gf loglikelihood
        like2(ct,3) = package(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.loglikelihood;
        like2(ct,4) = package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.loglikelihood;
        like2(ct,5) = -package(1).Horizontal_Estimate.Nozzle(1).Grid_Fit.GMM3.Model.NegativeLogLikelihood;
        like2(ct,6) = -package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM3.Model.NegativeLogLikelihood;
        like2(ct,7) = -package(1).Horizontal_Estimate.Nozzle(1).Grid_Fit.GMM4.Model.NegativeLogLikelihood;
        like2(ct,8) = -package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM4.Model.NegativeLogLikelihood;
        like2(ct,9) = -package(1).Horizontal_Estimate.Nozzle(1).Grid_Fit.GMM5.Model.NegativeLogLikelihood;
        like2(ct,10) = -package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM5.Model.NegativeLogLikelihood;
        like2(ct,11) = -package(1).Horizontal_Estimate.Nozzle(1).Grid_Fit.GMM6.Model.NegativeLogLikelihood;
        like2(ct,12) = -package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM6.Model.NegativeLogLikelihood;
        like2(ct,13) = -package(1).Horizontal_Estimate.Nozzle(1).Grid_Fit.GMM7.Model.NegativeLogLikelihood;
        like2(ct,14) = -package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM7.Model.NegativeLogLikelihood;
        like2(ct,15) = -package(1).Horizontal_Estimate.Nozzle(1).Grid_Fit.GMM8.Model.NegativeLogLikelihood;
        like2(ct,16) = -package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.GMM8.Model.NegativeLogLikelihood;
        %read bic for kde
        b(ct,3) = package(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.BIC;
        b(ct,4) = package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.BIC;
        b(ct,5) = package(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.BIC;
        b(ct,6) = package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.BIC;
        ct = ct+1;
    end
end
% save the data
csvwrite("loglh_lr.csv",like)
csvwrite("loglh_gf.csv",like2)
csvwrite("bic_kde.csv",b)
end
