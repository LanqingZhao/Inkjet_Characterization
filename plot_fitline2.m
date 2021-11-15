function plot_fitline2(package,cell_id,block_id,drop_num,nozz_num,res_o,res_n,visible)
%% summary
%This function plots the fitted line of only grid fit and linear regression
%methods ONLY
%input:
%package: database
%cell_id : cell id
%block_id block id
% drop_num: number of ink drops per nozzle
%nozz_num: number of nozzles per cell
%visible: TRUE(1) OR False(1) for whether to display the figure

if ~exist("fit_figures", "dir")
    mkdir fit_figures
end
mkdir fit_figures/LR
mkdir fit_figures/GF
%% first method
   
   h1= figure(1);
   if(~visible)
       set(h1,"Visible","off")
   end
    imshow(sub_interpol2(package(cell_id).BasicData.block(block_id).Filename,res_o,res_n))
    hold on
    for i = 1:nozz_num
       plot(package(cell_id).CellProfile.IndividualProfile(block_id).Displacement1.Horizontal_Fit(:,i),package(cell_id).BasicData.block(block_id).RC(:,i),'r-')
       hold on
    end
    plot(package(cell_id).BasicData.block(block_id).CC,package(cell_id).BasicData.block(block_id).RC,'g+')
    hold on
    tit1 = "Vertically Fitted line of cell " + string(cell_id)+ " in block:" +string(block_id)+" LR";
    title(tit1)
    filename1 = "fit_figures/LR/LR_Horizontal_cell_"+string(cell_id)+"_"+string(block_id)+".png";
    saveas(h1,filename1)
    %plot vertically fitted line 
    h2 = figure(2);
    if(~visible)
       set(h2,"Visible","off")
   end
    imshow(sub_interpol2(package(cell_id).BasicData.block(block_id).Filename,res_o,res_n))
    hold on
    for i = 1:drop_num
        plot(package(cell_id).BasicData.block(block_id).CC(i,:),package(cell_id).CellProfile.IndividualProfile(block_id).Displacement1.Vertical_Fit(i,:),'b-')
        hold on
    end
    plot(package(cell_id).BasicData.block(block_id).CC,package(cell_id).BasicData.block(block_id).RC,'g+')
    hold on
    tit2 = "Horizontally Fitted line of cell " + string(cell_id)+ " in block:" +string(block_id)+" LR";
    title(tit2)
    filename2 = "fit_figures/LR/LR_Vertical_cell_"+string(cell_id)+"_"+string(block_id)+".png";
    saveas(h2,filename2)
    
    %% the second method
   h3 = figure(3);
   if(~visible)
       set(h3,"Visible","off")
   end
   imshow(sub_interpol2(package(cell_id).BasicData.block(block_id).Filename,res_o,res_n))
    hold on
    for i = 1:nozz_num
        plot(package(cell_id).CellProfile.IndividualProfile(block_id).Displacement2.Horizontal_Fit(:,i),package(cell_id).CellProfile.IndividualProfile(block_id).Displacement2.Vertical_Fit(:,i),'r-')
        hold on
    end
    plot(package(cell_id).BasicData.block(block_id).CC,package(cell_id).BasicData.block(block_id).RC,'g+')
    hold on
    for i = 1:drop_num
        plot(package(cell_id).CellProfile.IndividualProfile(block_id).Displacement2.Horizontal_Fit(i,:),package(cell_id).CellProfile.IndividualProfile(block_id).Displacement2.Vertical_Fit(i,:),'b-')
        hold on
    end
    
    tit3 = "Fitted grid of cell " + string(cell_id)+ " in block:" +string(block_id)+" GF";
    title(tit3)
     filename3 = "fit_figures/GF/GF_cell_"+string(cell_id)+"_"+string(block_id)+".png";
    saveas(h3,filename3)
end 