function read_mean_dis(pack,num_nozz,num_cell)
%This function takes package, number of nozzles, and the number of
%blocks and save the expected value of displacment each nozzles as a csb
%file for both linear regression and grid fit
filename1 = "ev_of_lr.csv";
filename2 = "ev_of_gf.csv";
tot1 = zeros(num_nozz*num_cell,4);
tot2 = zeros(num_nozz*num_cell,4);
ct =1;
for i = 1:numel(pack)
    for j= 1:num_nozz
        tot1(ct,1) = i;
        tot2(ct,1) = i;
        tot1(ct,2) = j;
        tot1(ct,3) = pack(i).Horizontal_Estimate.Nozzle(j).Linear_Regression.EV;
        tot1(ct,4) = pack(i).Vertical_Estimate.Nozzle(j).Linear_Regression.EV;
        tot2(ct,2) = j;
        tot2(ct,3) = pack(i).Horizontal_Estimate.Nozzle(j).Grid_Fit.EV;
        tot2(ct,4) = pack(i).Vertical_Estimate.Nozzle(j).Grid_Fit.EV;
        ct = ct+1;
    end
    fprintf("Complete Reading mean of KDE for cell#%i\n",i)
end
csvwrite(filename1,tot1)
csvwrite(filename2,tot2)
end