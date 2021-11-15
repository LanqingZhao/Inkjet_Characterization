function read_displacement(package,num_drop)
%% summary 
%This function reads displacement of package from cell , nozzle, and row
%and store them in 3  folder in .csv
%input: package dot profile database

%check whether the three folders exist and clean up the data
%WARNING :the previous data will be removed 
%% function body
if ~exist("cell_displacement", "dir") 
    mkdir cell_displacement/gf
    mkdir cell_displacement/lr
else
    delete cell_displacement/gf/*.csv
    delete cell_displacement/lr/*.csv
end
if ~exist("nozzle_displacement","dir")
    mkdir nozzle_displacement/gf
    mkdir nozzle_displacement/lr
else
    delete nozzle_displacement/gf/*.csv
    delete nozzle_displacement/lr/*.csv
end
if ~exist("row_displacement","dir")
    mkdir row_displacement/gf
    mkdir row_displacement/lr
else
    delete row_displacement/gf/*.csv
    delete row_displacement/lr/*.csv
end
%store the cell displacement 
%index1 = transpose(1:num_drop*num_nozz);
index2 = transpose(1:num_drop);
%index3 = 1:num_nozz;
for i = 1:numel(package)
    lr =[];
    grf = [];
   for j = 1:numel(package(i).CellProfile.IndividualProfile)
  
       %filename1 = "cell_displacement/lr/lr_displacement_c"+string(i)+"b"+string(j)+".csv";
       %csvwrite(filename1,[index1,round(package(i).CellProfile.IndividualProfile(j).Displacement1.Pair_Displacement,4)])
       lr = [lr,package(i).CellProfile.IndividualProfile(j).Displacement1.Pair_Displacement];
       %filename3 = "cell_displacement/gf/gf_displacement_c"+string(i)+"b"+string(j)+".csv";
      % csvwrite(filename3,[index1,round(package(i).CellProfile.IndividualProfile(j).Displacement2.Pair_Displacement,4)])
       grf = [grf,package(i).CellProfile.IndividualProfile(j).Displacement2.Pair_Displacement];
   end
   %stack one cell number displacement
   filename1 = "cell_displacement/lr/lr_displacement_c"+string(i)+".csv";
   csvwrite(filename1,lr);
   filename1 = "cell_displacement/gf/gf_displacement_c"+string(i)+".csv";
   csvwrite(filename1,grf);
   %store the column displacement 
   for k=1:numel(package(i).Horizontal.Displacement(1).Nozzle)
       filename5 ="nozzle_displacement/lr/lrc"+string(i)+"n"+string(k)+".csv";
       filename6 ="nozzle_displacement/gf/gfc"+string(i)+"n"+string(k)+".csv";
       csvwrite(filename5,[index2,round(package(i).Horizontal.Displacement(1).Nozzle(k).Horizontal_L1,4)])
       csvwrite(filename6,[index2,round(package(i).Horizontal.Displacement(2).Nozzle(k).Horizontal_L1,4)])
   
   %store the row displacement 
   
       filename7 ="row_displacement/lr/rlrc"+string(i)+"n"+string(k)+".csv";
       filename8 ="row_displacement/gf/rgfc"+string(i)+"n"+string(k)+".csv";
       csvwrite(filename7,[index2,round(package(i).Vertical.Displacement(1).Nozzle(k).Vertical_L1,4)])
       csvwrite(filename8,[index2,round(package(i).Vertical.Displacement(2).Nozzle(k).Vertical_L1,4)])
   end
   fprintf("The displacement of Cell#%d is read\n",i)
end

end
