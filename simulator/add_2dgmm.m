function  gmm_2d = add_2dgmm(Nozzle_Bag)
%% Summary
%This function will supplment the model by creating an additional 2d model
%based on vertical and horizontal displacement from the Nozzle_Bag
tic;
for i = 1:numel(Nozzle_Bag)
    combined_lr = [Nozzle_Bag(i).HD.Linear_Regression.Original_Data;Nozzle_Bag(i).VD.Linear_Regression.Original_Data];
    combined_gf = [Nozzle_Bag(i).HD.Grid_Fit.Original_Data;Nozzle_Bag(i).VD.Grid_Fit.Original_Data];
    x = combined_lr;
    gm4 =fitgmdist(transpose(x),4,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    gmm_2d(i).Linear_Regression.GMM4 = gm4;
    gm5 =fitgmdist(transpose(x),5,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    gmm_2d(i).Linear_Regression.GMM5 = gm5;
    gm6 =fitgmdist(transpose(x),6,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    gmm_2d(i).Linear_Regression.GMM6 = gm6;
    x = combined_gf;
    gm4 =fitgmdist(transpose(x),4,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    gmm_2d(i).Grid_Fit.GMM4 = gm4;
    gm5 =fitgmdist(transpose(x),5,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    gmm_2d(i).Grid_Fit.GMM5 = gm5;
    gm6 =fitgmdist(transpose(x),6,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    gmm_2d(i).Grid_Fit.GMM6 = gm6;
    fprintf("Complete 2d gmm for nozzle # %i\n",i)
end
time = toc;
fprintf("Time used: %.3f sec\n",time)
end