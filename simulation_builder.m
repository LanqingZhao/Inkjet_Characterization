function [Nozzle_Bag]= simulation_builder(package,row_bloc1,row1,row2,stride,nozz_num,total)
%% Summary
%rearray the order of nozzle as the one inside the printhead
%It takes database package
ct1=0;
%% correct the order of cell
for shift = 1:row1
    for j = 0:stride-1
    ct1 =ct1+1;
    sim_data(ct1).Cell_ID = ct1;
    sim_data(ct1).Old_ID = package(j*row1+shift).Cell_ID;
    sim_data(ct1).Cell_Profile = package(j*row1+shift).CellProfile;
    sim_data(ct1).HD = package(j*row1+shift).Horizontal_Estimate;
    sim_data(ct1).VD = package(j*row1+shift).Vertical_Estimate;
    end
    ct1 =ct1+stride;
end
start = row_bloc1+1;
ct1=6;
for shift = start:start+row2-1
    for j = 0:stride-1
    ct1 =ct1+1;
    sim_data(ct1).Cell_ID = ct1;
    sim_data(ct1).Old_ID = package(j*row2+shift).Cell_ID;
    sim_data(ct1).Cell_Profile = package(j*row2+shift).CellProfile;
    sim_data(ct1).HD = package(j*row2+shift).Horizontal_Estimate;
    sim_data(ct1).VD = package(j*row2+shift).Vertical_Estimate;
    end
    ct1 = ct1+stride;
end
ct =0;
%% rearrage the data order
for start = 1:stride:total
for ct1 = 1:nozz_num
   for i =start:start+stride-1%1-12
      ct = ct+1;
      Nozzle_Bag(ct).Cell_ID = sim_data(i).Cell_ID;
      Nozzle_Bag(ct).Old_CellID = sim_data(i).Old_ID;
      Nozzle_Bag(ct).Nozzle_ID =ct;
      Nozzle_Bag(ct).Old_NozzleID = sim_data(i).Cell_Profile.Nozzle(ct1).NozzleID;
      Nozzle_Bag(ct).Dot_Profile.Mean = sim_data(i).Cell_Profile.Nozzle(ct1).Mean;
      Nozzle_Bag(ct).Dot_Profile.SD = sim_data(i).Cell_Profile.Nozzle(ct1).SD;
      Nozzle_Bag(ct).HD = sim_data(i).HD.Nozzle(ct1);
      Nozzle_Bag(ct).VD = sim_data(i).VD.Nozzle(ct1);
   end
end
fprintf("cell#%i tuple is complete\n",start)
end
%save("Nozzle_Bag.mat","Nozzle_Bag","-v7.3")
end