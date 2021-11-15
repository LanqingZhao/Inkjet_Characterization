function [h_h,v_h] = create_dist(hd,vd,cells,num_block,nozz_num,drop_num)
%% This function performs estimation of pdf
for i =1:numel(cells)
    for j = 1:nozz_num
    %store the horizontal displacement of LR
    %apply fd rule
    h_h(i).Nozzle(j).Linear_Regression.Original_Data = reshape(hd(i).Displacement(1).Nozzle(j).Horizontal_L1,[1,drop_num*num_block]); 
    [N_l,edge_l] = histcounts(reshape(hd(i).Displacement(1).Nozzle(j).Horizontal_L1,[1,drop_num*num_block]),"BinMethod","fd","Normalization","pdf");
    h_h(i).Nozzle(j).Linear_Regression.N =N_l;
    h_h(i).Nozzle(j).Linear_Regression.edge_l =edge_l;
    %% doing kernel density estimate
    x=reshape(hd(i).Displacement(1).Nozzle(j).Horizontal_L1,[1,drop_num*num_block]);
    bandwidth = 1.06*min(std(x),iqr(x)/1.34);
    pd = fitdist(transpose(x),'Kernel','Kernel','normal',"Width",bandwidth);
    h_h(i).Nozzle(j).Linear_Regression.KDE = pd;
    h_h(i).Nozzle(j).Linear_Regression.EV = mean(pd);
    h_h(i).Nozzle(j).Linear_Regression.Var = var(pd);
    h_h(i).Nozzle(j).Linear_Regression.PDF = pdf(pd,x);
    % do k mixture gaussian with k=5,6 ,7,or 8
    %% k=5
    gm5 =fitgmdist(transpose(x),5,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Linear_Regression.GMM5.Model = gm5;
    h_h(i).Nozzle(j).Linear_Regression.GMM5.mean = gm5.ComponentProportion * gm5.mu;
    %% k=6
    gm6 =fitgmdist(transpose(x),6,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Linear_Regression.GMM6.Model = gm6;
    h_h(i).Nozzle(j).Linear_Regression.GMM6.mean = gm6.ComponentProportion * gm6.mu;
    %% K=8
    gm8 = fitgmdist(transpose(x),8,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Linear_Regression.GMM8.Model = gm8;
    h_h(i).Nozzle(j).Linear_Regression.GMM8.mean = gm8.ComponentProportion * gm8.mu;
    %% K=7
    gm7 = fitgmdist(transpose(x),7,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Linear_Regression.GMM7.Model = gm7;
    h_h(i).Nozzle(j).Linear_Regression.GMM7.mean = gm7.ComponentProportion * gm7.mu;
    %% k=3 
    gm3 =fitgmdist(transpose(x),3,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Linear_Regression.GMM3.Model = gm3;
    h_h(i).Nozzle(j).Linear_Regression.GMM3.mean = gm3.ComponentProportion * gm3.mu;
    %% k=4
    gm4 =fitgmdist(transpose(x),4,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Linear_Regression.GMM4.Model = gm4;
    h_h(i).Nozzle(j).Linear_Regression.GMM4.mean = gm4.ComponentProportion * gm4.mu;
    %% store horizontal displacement of GF
    h_h(i).Nozzle(j).Grid_Fit.Original_Data = reshape(hd(i).Displacement(2).Nozzle(j).Horizontal_L1,[1,drop_num*num_block]); 
    [N_g,edge_g] = histcounts(reshape(hd(i).Displacement(2).Nozzle(j).Horizontal_L1,[1,drop_num*num_block]),"BinMethod","fd","Normalization","pdf");
    h_h(i).Nozzle(j).Grid_Fit.N =N_g;
    h_h(i).Nozzle(j).Grid_Fit.edge =edge_g;
    %% do kde for grid fit
    x=reshape(hd(i).Displacement(2).Nozzle(j).Horizontal_L1,[1,drop_num*num_block]);
    bandwidth = 1.06*min(std(x),iqr(x)/1.34);
    pd = fitdist(transpose(x),'Kernel','Kernel','normal',"Width",bandwidth);
    h_h(i).Nozzle(j).Grid_Fit.KDE = pd;
    h_h(i).Nozzle(j).Grid_Fit.EV = mean(pd);
    h_h(i).Nozzle(j).Grid_Fit.Var = var(pd);
    h_h(i).Nozzle(j).Grid_Fit.PDF = pdf(pd,x);
    %% do k mixture gaussian with k=5,6 ,7,or 8
    gm5 =fitgmdist(transpose(x),5,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Grid_Fit.GMM5.Model = gm5;
    h_h(i).Nozzle(j).Grid_Fit.GMM5.mean = gm5.ComponentProportion * gm5.mu;
    %% k=6
    gm6 =fitgmdist(transpose(x),6,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Grid_Fit.GMM6.Model = gm6;
    h_h(i).Nozzle(j).Grid_Fit.GMM6.mean = gm6.ComponentProportion * gm6.mu;
    %% K=8
    gm8 = fitgmdist(transpose(x),8,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Grid_Fit.GMM8.Model = gm8;
    h_h(i).Nozzle(j).Grid_Fit.GMM8.mean = gm8.ComponentProportion * gm8.mu;
    %% K=7
    gm7 = fitgmdist(transpose(x),7,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Grid_Fit.GMM7.Model = gm7;
    h_h(i).Nozzle(j).Grid_Fit.GMM7.mean = gm7.ComponentProportion * gm7.mu;
    %% k=3
    gm3 =fitgmdist(transpose(x),3,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Grid_Fit.GMM3.Model = gm3;
    h_h(i).Nozzle(j).Grid_Fit.GMM3.mean = gm3.ComponentProportion * gm3.mu;
    %% k=4
    gm4 =fitgmdist(transpose(x),4,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    h_h(i).Nozzle(j).Grid_Fit.GMM4.Model = gm4;
    h_h(i).Nozzle(j).Grid_Fit.GMM4.mean = gm4.ComponentProportion * gm4.mu; 
    %% Vertical Displacement 
        %Linear Regression
    v_h(i).Nozzle(j).Linear_Regression.Original_Data = reshape(vd(i).Displacement(1).Nozzle(j).Vertical_L1,[1,num_block*drop_num]);
    [N_l,edge_l] = histcounts(reshape(vd(i).Displacement(1).Nozzle(j).Vertical_L1,[1,num_block*drop_num]),"BinMethod","fd","Normalization","pdf");
    v_h(i).Nozzle(j).Linear_Regression.N =N_l;
    v_h(i).Nozzle(j).Linear_Regression.edge_l =edge_l;
    %% do kde for lr
    x=reshape(vd(i).Displacement(1).Nozzle(j).Vertical_L1,[1,drop_num*num_block]);
    bandwidth = 1.06*min(std(x),iqr(x)/1.34);
    pd = fitdist(transpose(x),'Kernel','Kernel','normal',"Width",bandwidth);
    v_h(i).Nozzle(j).Linear_Regression.KDE = pd;
    v_h(i).Nozzle(j).Linear_Regression.EV = mean(pd);
    v_h(i).Nozzle(j).Linear_Regression.Var = var(pd);
    v_h(i).Nozzle(j).Linear_Regression.PDF = pdf(pd,x);
    %% do k mixture gaussian with k=5,6 ,7,or 8
    gm5 =fitgmdist(transpose(x),5,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Linear_Regression.GMM5.Model = gm5;
    v_h(i).Nozzle(j).Linear_Regression.GMM5.mean = gm5.ComponentProportion * gm5.mu;
    %% k=6
    gm6 =fitgmdist(transpose(x),6,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Linear_Regression.GMM6.Model = gm6;
    v_h(i).Nozzle(j).Linear_Regression.GMM6.mean = gm6.ComponentProportion * gm6.mu;
    %% K=8
    gm8 = fitgmdist(transpose(x),8,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Linear_Regression.GMM8.Model = gm8;
    v_h(i).Nozzle(j).Linear_Regression.GMM8.mean = gm8.ComponentProportion * gm8.mu;
    %% K=7
    gm7 = fitgmdist(transpose(x),7,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Linear_Regression.GMM7.Model = gm7;
    v_h(i).Nozzle(j).Linear_Regression.GMM7.mean = gm7.ComponentProportion * gm7.mu;
    %% k=3 
    gm3 =fitgmdist(transpose(x),3,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Linear_Regression.GMM3.Model = gm3;
    v_h(i).Nozzle(j).Linear_Regression.GMM3.mean = gm3.ComponentProportion * gm3.mu;
    %% k=4
    gm4 =fitgmdist(transpose(x),4,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Linear_Regression.GMM4.Model = gm4;
    v_h(i).Nozzle(j).Linear_Regression.GMM4.mean = gm4.ComponentProportion * gm4.mu;
    %% Grid fit
    v_h(i).Nozzle(j).Grid_Fit.Original_Data = reshape(vd(i).Displacement(2).Nozzle(j).Vertical_L1,[1,num_block*drop_num]);
    [N_g,edge_g] = histcounts(reshape(vd(i).Displacement(2).Nozzle(j).Vertical_L1,[1,num_block*drop_num]),"BinMethod","fd","Normalization","pdf");
    v_h(i).Nozzle(j).Grid_Fit.N =N_g;
    v_h(i).Nozzle(j).Grid_Fit.edge =edge_g;
    x=reshape(vd(i).Displacement(2).Nozzle(j).Vertical_L1,[1,drop_num*num_block]);
    %% kde
    bandwidth = 1.06*min(std(x),iqr(x)/1.34);
    pd = fitdist(transpose(x),'Kernel','Kernel','normal',"Width",bandwidth);
    v_h(i).Nozzle(j).Grid_Fit.KDE =pd;
    v_h(i).Nozzle(j).Grid_Fit.EV =mean(pd);
    v_h(i).Nozzle(j).Grid_Fit.Var = var(pd);
    v_h(i).Nozzle(j).Grid_Fit.PDF = pdf(pd,x);
    %%  do k mixture gaussian with k=5,6 ,7,or 8
    gm5 =fitgmdist(transpose(x),5,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Grid_Fit.GMM5.Model = gm5;
    v_h(i).Nozzle(j).Grid_Fit.GMM5.mean = gm5.ComponentProportion * gm5.mu;
    %% k=6
    gm6 =fitgmdist(transpose(x),6,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Grid_Fit.GMM6.Model = gm6;
    v_h(i).Nozzle(j).Grid_Fit.GMM6.mean = gm6.ComponentProportion * gm6.mu;
    %% K=8
    gm8 = fitgmdist(transpose(x),8,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Grid_Fit.GMM8.Model = gm8;
    v_h(i).Nozzle(j).Grid_Fit.GMM8.mean = gm8.ComponentProportion * gm8.mu;
    %% K=7
    gm7 = fitgmdist(transpose(x),7,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Grid_Fit.GMM7.Model = gm7;
    v_h(i).Nozzle(j).Grid_Fit.GMM7.mean = gm7.ComponentProportion * gm7.mu;
    %% k=3
    gm3 =fitgmdist(transpose(x),3,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Grid_Fit.GMM3.Model = gm3;
    v_h(i).Nozzle(j).Grid_Fit.GMM3.mean = gm3.ComponentProportion * gm3.mu;
    %% k=4
    gm4 =fitgmdist(transpose(x),4,'CovarianceType','full',"RegularizationValue",1e-6,'Options',statset('Display','off','MaxIter',10000,'TolFun',1e-5));
    v_h(i).Nozzle(j).Grid_Fit.GMM4.Model = gm4;
    v_h(i).Nozzle(j).Grid_Fit.GMM4.mean = gm4.ComponentProportion * gm4.mu;
    end
    fprintf("The pdf estimate of #%d cell is done\n",i)
end