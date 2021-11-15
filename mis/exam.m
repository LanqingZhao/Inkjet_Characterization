function exam(package,mode,cell,id)
%% Summary
%This function takes a package of data and plot the histogram of
%displacement
%Input
%package: database
%num_nozz:number of nozzle
%num_drop:number of drop fired in individual cell
%mode: 1 for column,2 for row,3 for total row and column
%optional input for mode 1 and 2
%cell: cell id
%id: for 1 nozzle id, 2 is row id
%function body
%% plot horizontal displacement of both linear regression and grid fit
if (mode==1)
    figure(1)
    histogram(package(cell).Horizontal_Histogram(id).Linear_Regression.Original_Data,"BinMethod","fd","Normalization","probability")
    title("Histogram of Horizontal Displacement cell:"+string(cell)+"Nozzle:"+string(id)+":FD")
    xlabel("Displacement")
    ylabel("Normalized Frequency")
    figure(2)
    histogram(package(cell).Horizontal_Histogram(id).Linear_Regression.Original_Data,"BinWidth",0.5/12,"Normalization","probability")
     title("Histogram of Horizontal Displacement cell:"+string(cell)+"Nozzle:"+string(id)+":BW")
    xlabel("Displacement")
    ylabel("Normalized Frequency")
    
%% plot vertical displacement
elseif(mode==2)
    figure(1)
    histogram(package(cell).Vertical_Histogram(id).Linear_Regression.Original_Data,"BinMethod","fd","Normalization","probability")
    title("Histogram of Vertical Displacement cell:"+string(cell)+"Row:"+string(id)+":FD")
    xlabel("Displacement")
    ylabel("Normalized Frequency")
    figure(2)
    histogram(package(cell).Vertical_Histogram(id).LinearRegression.Original_Data,"BinWidth",0.5/12,"Normalization","probability")
    title("Histogram of Vertical Displacement cell:"+string(cell)+"Row:"+string(id)+":BW")
    xlabel("Displacement")
    ylabel("Normalized Frequency")
end
end