function [CellPackage,total_mean,total_SD,time]=data_process(directory,extension,res1,res2,res3,num_drop,num_nozz,stride,num_bloc,num_cell)
%% main function process data
% This function will process data to build a package of data from the input
% images
%Input:
%directory: The directory of data
%extension: the extension of image file
% res1: printer resolution
% res2: interpolated image resolution
% res3: original image resolution
% num_drop: number of ink drops per nozzles in one cell
%num_nozz: number of nozzles per cell
%stride: distance between two ink drop
%output:
%CellPackage: a struct of database
%total_mean:the mean of all ink drops
%total_SD: the standard deviation of ink drops 
%This function also will plot the total dot profile
%%  imagelist extraction
%extension = "*."+extension;
imagelist = dir(directory+"/"+extension);
tic;
[cells,datalist,worse,second] = data_extract2(imagelist,res3,res2,num_drop,num_nozz,num_cell);
time1 = toc;
save("BasicData.mat","cells","-v7.3");
csvwrite("worse_case.csv",worse);
csvwrite("secondary_case.csv",second);
fprintf("The data has been packed!\nTime used :%.4f sec\n==========================\n",time1)
%% process the data to build database
%establish a cell profile
tic;
[CellProfile,total_mean,total_SD]= dot_profile(cells,datalist,res1,res2,num_drop,num_nozz,num_bloc);
time2 = toc;
fprintf("The cell profile is established!\nTime used:%.4f sec\n==========================\n",time2)
clear datalist
%compute the displacement and update the cell profile
tic;
[hd,vd,vd2,CellProfile] =displacement3(cells,num_drop,num_nozz,stride,res1,res2,CellProfile);
save("CellProfile.mat","CellProfile","-v7.3")
save("Horizontal.mat","hd","-v7.3")
save("Vertical.mat","vd2","-v7.3")
time3 =toc;
fprintf("The displacement has completed!\nTime used:%.4f sec\n==========================\n",time3)
%estiablish histogram
tic;
[h_h,v_h] = create_dist(hd,vd2,cells,num_bloc,num_nozz,num_drop);
save("Horizontal_Hist.mat","h_h","-v7.3")
save("Vertical_Hist.mat","v_h","-v7.3")
time4 = toc;
fprintf("PDF estimmate data has been created!\nTime used:%.4f sec\n==========================\n",time4)
%pack the data into database
%% plot total mean and std
tic;
for i = 1:numel(cells)
    CellPackage(i).CellProfile= CellProfile(i);
    CellPackage(i).BasicData = cells(i);
    CellPackage(i).Horizontal = hd(i);
    CellPackage(i).Vertical = vd2(i);
    CellPackage(i).Raw_Vertical = vd(i);
    CellPackage(i).Cell_ID = i;
    CellPackage(i).Horizontal_Estimate = h_h(i);
    CellPackage(i).Vertical_Estimate = v_h(i);
end
delete BasicData.mat CellProfile.mat Horizontal.mat Vertical.mat Horizontal_Hist.mat Vertical_Hist.mat
time5 = toc;
fprintf("Database is generated\nTime used:%.4f sec\n==========================\n",time5);
time = time1+time2+time3+time4+time5;
fprintf("The data has been processed!\nTotal Time:%.4f sec\n==========================\n",time);

col = size(total_mean,2);
row = size(total_mean,1);
x = linspace(-2,2,col);
y = linspace(2.5,-2.5,row);
figure(1);
[X,Y] = meshgrid(x,y);
%plot mean 
contour(X,Y,total_mean,"ShowText","on")
pbaspect([1 1 1])
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit1 = "Mean dot profile of total cell"; 
title(tit1)
grid on

%plot sd
figure(2);
[X,Y] = meshgrid(x,y);
contour(X,Y,total_SD,"ShowText","on")
pbaspect([1 1 1])
grid on
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit2 = "Standard Deviation dot profile of total cell " ;
title(tit2)
end