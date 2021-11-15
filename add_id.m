function package = add_id(package,number_cell,nozzle)
%% SUMMARY
%add nozzle id and log likelihood value for cell
%only valid for our test database
for i = 1:number_cell
    package(i).Horizontal_Estimate.Cell_ID = i;
    package(i).Vertical_Estimate.Cell_ID = i;
    for j = 1:nozzle
        package(i).Horizontal_Estimate.Nozzle(j).Nozzle_ID = j;
        package(i).Vertical_Estimate.Nozzle(j).Nozzle_ID = j;
        package(i).Horizontal_Estimate.Nozzle(j).Nozzle_ID = j;
        package(i).Vertical_Estimate.Nozzle(j).Nozzle_ID = j;
        %bic computation
        package(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.BIC = log(168)*169-2*(sum(log(package(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.PDF)));
        package(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.BIC = log(168)*169-2*(sum(log(package(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.PDF)));
        package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.BIC = log(168)*169-2*(sum(log(package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.PDF)));
        package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.BIC = log(168)*169-2*(sum(log(package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.PDF)));
        %log likelihood
        package(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.loglikelihood= (sum(log(package(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.PDF)));
        package(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.loglikelihood = (sum(log(package(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.PDF)));
        package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.loglikelihood = (sum(log(package(i).Vertical_Estimate.Nozzle(j).Linear_Regression.PDF)));
        package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.loglikelihood = (sum(log(package(i).Vertical_Estimate.Nozzle(j).Grid_Fit.PDF)));
    end
    fprintf("LogL Complete cell#%i\n",i)
end
end