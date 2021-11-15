function [mean,sd]=plot_profile(mode,package,cell_id,block_id,nozz_id)
%%Summary 
% dot profile reading interface
%Input: 
%mode: TotalCell: 1. total cell profile of one cell
%2. SingleCell: one cell in one block
%3. SingleNozzle: one nozzle in total
%cell_id: Cell ID
%block_id: block ID (set to 0 for SingleNozzle mode)
%nozzle_id: nozzle ID
%output:
%mean: the mean the user wants to read
%sd: the sd the user wants to read
%% function body
% read the size of input
row = size(package(cell_id).CellProfile.Mean,1);
col = size(package(cell_id).CellProfile.Mean,2);
x = linspace(-3,3,col);
y = linspace(3,-3,row);

%plot mode1
if(strcmp(mode,"TotalCell"))
figure(1);
[X,Y] = meshgrid(x,y);
%plot mean and return mean
contour(X,Y,package(cell_id).CellProfile.Mean,"ShowText","on")
pbaspect([1 1 1])
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit1 = "Mean dot profile of total cell" + string(cell_id);
title(tit1)
grid on
mean = package(cell_id).CellProfile.Mean;
%plot sd and return sd
figure(2);
[X,Y] = meshgrid(x,y);
contour(X,Y,package(cell_id).CellProfile.SD,"ShowText","on")
pbaspect([1 1 1])
grid on
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit2 = "Standard Deviation dot profile of total cell " +string(cell_id); 
title(tit2)
sd  = package(cell_id).CellProfile.SD;
figure(3)
imshow(uint8((1-mean)*255))
tit3 = "Mean Image of total cell" + string(cell_id);
title(tit3)
%plot mode2
elseif(strcmp(mode,"SingleCell"))
    %plot mean and return mean
 figure(1);
[X,Y] = meshgrid(x,y);
contour(X,Y,package(cell_id).CellProfile.IndividualProfile(block_id).Mean,"ShowText","on")
pbaspect([1 1 1])
grid on
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit1 = "Mean dot profile of cell" + string(cell_id) + " of block "+string(block_id);
title(tit1)
mean = package(cell_id).CellProfile.IndividualProfile(block_id).Mean;
%plot sd and return sd
figure(2);
[X,Y] = meshgrid(x,y);
contour(X,Y,package(cell_id).CellProfile.IndividualProfile(block_id).SD,"ShowText","on")
pbaspect([1 1 1])
grid on
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit2 = "Standard Deviation dot profile of cell" + string(cell_id) + " of block "+string(block_id);
title(tit2)
sd = package(cell_id).CellProfile.IndividualProfile(block_id).SD;
figure(3)
tit3 = "Mean Image profile of cell" + string(cell_id)+ "of block"+ string(block_id);
imshow(uint8((1-mean)*255))
title(tit3)
%plot mode3
elseif(strcmp(mode,"SingleNozzle"))
    %plot mean and return mean
    figure(1);
[X,Y] = meshgrid(x,y);
contour(X,Y,package(cell_id).CellProfile.Nozzle(nozz_id).Mean,"ShowText","on")
pbaspect([1 1 1])
grid on
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit1 = "Mean dot profile of nozzle" + string(nozz_id)+ "in cell"+ string(cell_id);
title(tit1)
mean = package(cell_id).CellProfile.Nozzle(nozz_id).Mean;
%plot sd and return sd
figure(2);
[X,Y] = meshgrid(x,y);
contour(X,Y,package(cell_id).CellProfile.Nozzle(nozz_id).SD,"ShowText","on")
pbaspect([1 1 1])
grid on
xlabel("column in printer pixel")
ylabel("row in printer pixel")
tit2 = "Standard Deviation dot profile of nozzle" + string(nozz_id)+"in cell"+ string(cell_id);
title(tit2)
sd = package(cell_id).CellProfile.Nozzle(nozz_id).SD;
figure(3)
tit3 = "Mean image of nozzle" + string(nozz_id)+ " in cell"+ string(cell_id);
imshow(uint8((1-mean)*255))
title(tit3)
%return error if caught 
else
    error("The mode is not compatiable")
end
end