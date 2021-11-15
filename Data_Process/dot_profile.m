function [CellProfile,total_mean,total_sd]= dot_profile(cells,datalist,res_1,res_2,num_drop,num_nozz,num_bloc)
%% summary
%This function computes mean and standard deviation
%input:
%cells: a struct that contains the basic data from data_extract
%res_1:the printer resolution
%res_2:the sub_pixel resolution
%num_drop: number of drops per nozzle in one cell
%num_nozz: number of nozzles per cell
%output CellProfile: a struct containing cell profile(see documentation)
%% function body
% find the ratio between printer and captured image
ratio = res_2/res_1;
% assign the size of each dot image
row = 5*ratio;
col = 4*ratio;
dot_index =1:num_drop*num_bloc;
dot_index = reshape(dot_index,[num_drop,num_bloc]);
Dot_Data = zeros(num_drop*num_bloc,(row+1)*(col+1));
Dot = zeros(num_drop*num_nozz*num_bloc,(row+1)*(col+1));
%cell_dot = zeros(num_drop*num_nozz,(row+1)*(col+1));
total_index = 1:num_bloc*num_drop*num_nozz;
total_index = reshape(total_index,[num_drop,num_nozz,num_bloc]);
total_holder = zeros(numel(cells),(row+1)*(col+1));
sqdiff = zeros(numel(cells),(row+1)*(col+1));
%cell_index = transpose(1:num_nozz*num_drop);
for i =1 :numel(cells)
    %ct2 =1;%counter for all dots
    %loop over the nozzles in the cell
    for k = 1:num_nozz
        %ct = 1;%counter for one nozzle
        %loop over each block of the cell
       for j = 1:numel(cells(i).block)
           %loop over each ink drop of the nozzle
          for drop_index = 1:num_drop
          % assign the begining and end for each ink drop image
           row_s = round(cells(i).block(j).RC(drop_index,k))- 2.5*ratio;
           row_e = round(cells(i).block(j).RC(drop_index,k))+2.5*ratio;
           col_s = round(cells(i).block(j).CC(drop_index,k))-2*ratio;
           col_e = round(cells(i).block(j).CC(drop_index,k)) +2*ratio;
           dot_col  = double((reshape(datalist(i).block(j).image(row_s:row_e,col_s:col_e),[1,(row+1)*(col+1)])));% slice of dot 
           %stack the ink drop image of each nozzle throughout the data 
           index1 = dot_index(drop_index,j);
           Dot_Data(index1,:) = dot_col;
           index2 = total_index(drop_index,k,j);
           Dot(index2,:)= dot_col;
           %ct = ct+1;%update the index for ink drop of each nozzle
          end      
       end
           CellProfile(i).Nozzle(k).NozzleID = k;%assign nozzle id
           CellProfile(i).Nozzle(k).Cell_ID = i;%assign cell id
           %assign total number of block
           CellProfile(i).Nozzle(k).Total_Block = numel(cells(i).block);
           CellProfile(i).Nozzle(k).Mean  = (reshape(mean(Dot_Data),[row+1,col+1]))./255;
           CellProfile(i).Nozzle(k).SD = (reshape(std(Dot_Data),[row+1,col+1]))./255;
           Dot_Data = zeros(num_drop*num_bloc,(row+1)*(col+1));
          
    end
      CellProfile(i).Mean = (reshape(mean(Dot),[row+1,col+1]))./255;
      total_holder(i,:) = mean(Dot);
      CellProfile(i).SD = (reshape(std(Dot),[row+1,col+1]))./255;
      CellProfile(i).Cell_ID = i;%assign cell id
      Dot = zeros(num_drop*num_nozz*num_bloc,(row+1)*(col+1));
     fprintf("Cell #%d is stacked and completed!\n",i)
end
total_mean = mean(total_holder);
%size(total_mean)
for i =1 :numel(cells)
    %ct2 =1;%counter for all dots
    %loop over the nozzles in the cell
    for k = 1:num_nozz
        %ct = 1;%counter for one nozzle
        %loop over each block of the cell
       for j = 1:numel(cells(i).block)
           %loop over each ink drop of the nozzle
          for drop_index = 1:num_drop
          % assign the begining and end for each ink drop image
           row_s = round(cells(i).block(j).RC(drop_index,k))- 2.5*ratio;
           row_e = round(cells(i).block(j).RC(drop_index,k))+2.5*ratio;
           col_s = round(cells(i).block(j).CC(drop_index,k))-2*ratio;
           col_e = round(cells(i).block(j).CC(drop_index,k)) +2*ratio;
           dot_col  = double((reshape(datalist(i).block(j).image(row_s:row_e,col_s:col_e),[1,(row+1)*(col+1)])));% slice of dot 
           %stack the ink drop image of cell throughout all blocks 
           index2 = total_index(drop_index,k,j);
           Dot(index2,:)= dot_col;
           %ct = ct+1;%update the index for ink drop of each nozzle
          end      
       end
    end
    sqdiff(i,:) = sum((Dot-total_mean).^2,1);
    Dot = zeros(num_drop*num_nozz*num_bloc,(row+1)*(col+1));
end 
total_sd = reshape(sqrt(sum(sqdiff,1)/(num_nozz*num_drop*numel(cells)*num_bloc-1)),[row+1,col+1])/255;
total_mean = reshape(total_mean,[row+1,col+1])/255;
end
