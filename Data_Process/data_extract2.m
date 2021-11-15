function [cells,datalist,worse_case,second] = data_extract2(imagelist,res_o,res_n,num_drop,num_nozz,num_cell)
%% Summary
% extract data for each cell to store the basic data
%input: imagelist: a struct of all interested image
%res_o: original image resolution
%res_n: the interpolated image resolution
%num_drop:number of drops per nozzle in a cell
%num_nozz: number of nozzles in a cells
%output: a struct of cells containing basic data (see documentation)

%% extract data
count =0;
second =[];
worse_case =[];
worse_index =1;
second_index = 1;
for file_index = 1:numel(imagelist)% go through each data file
    if(imagelist(file_index).bytes<1000000)
        continue
    end
    center =[];
    filename1 = string(imagelist(file_index).name);%find the file name
   filename = string(imagelist(file_index).folder)+"/"+string(imagelist(file_index).name);
    %read the cell number
    cell_num = double(string(extractBetween(filename1,4,6)));
    %read the block number
    block_num = double(string(extractBetween(filename1,1,2)));
    %read the image as absorptance 
    image = uint8(255-sub_interpol2(filename,res_o,res_n));
    image_temp = uint8(image);%generate a backup
    %% primary binarization
    %binarize image without dilation
    bin_image = binary_mask(image,0);
    %find the objects in the image
    l = bwlabel(logical(bin_image));
    %filter out background
    k2 = l==0;
    image(k2) = 0;
    % do binarization with some dilation again to find the new binary mask
    bin_image = binary_mask(image,0);
    l =bwlabel(logical(bin_image));
    labels = unique(l);
    % filter out satellites
    for label_index = 1:numel(labels)
        k1 = find(l == labels(label_index));
        if(numel(k1) < 70)
            image(k1) = 0;
        end
    end
     % do binarization without dilation again to find the new binary mask
    bin_image = binary_mask(image,0);
    %do weighted centroid
    stat= regionprops(bin_image,image,"Area","WeightedCentroid");
    ct =1;
     for i =1:numel(stat)
         if(stat(i).Area<1900 && stat(i).WeightedCentroid(2)<535&&stat(i).WeightedCentroid(1)>55 && stat(i).WeightedCentroid(2)>30&&stat(i).WeightedCentroid(1)<930)
            center(ct,1) = stat(i).WeightedCentroid(1);%x
            center(ct,2) = stat(i).WeightedCentroid(2);%y
          %  area(ct) = stat(i).Area;
            ct = ct+1;
         end
     end
    % center = sortrows(center,1);
    
     %% Secondary binarization
   
     if (size(center,1)>84)
         second(second_index,:) = [block_num,cell_num];
         second_index = second_index+1;
         %clear the data
        image = image_temp;
        center =[];
        area =[];
        %find the sateilte
        bin_image = binary_mask(image,0);
        l = bwlabel(logical(bin_image));
        %filter out the sateilte
        for label_index = 1:numel(labels)
           k1 = find(l == labels(label_index));
           if(numel(k1) < 70)
              image(k1) = 0;
           end
        end
        % find the new object
        bin_image = binary_mask(image,0);
        %filter out background before dilation
        l = bwlabel(bin_image);
        k_b = l==0;
        image(k_b) =0;
        %doing binary mask with dilation
        bin_image = binary_mask(image,1);
        stat = regionprops(bin_image,image,"Area","WeightedCentroid");
        ct = 1;
        for i =1:numel(stat)
         if(stat(i).Area<2300 && stat(i).WeightedCentroid(2)<535&&stat(i).WeightedCentroid(1)>55 && stat(i).WeightedCentroid(2)>30&&stat(i).WeightedCentroid(1)<930)
            center(ct,1) = stat(i).WeightedCentroid(1);%x
            center(ct,2) = stat(i).WeightedCentroid(2);%y
            area(ct) = stat(i).Area;
            ct = ct+1;
         end
        end
        
     end
     
     %% worse case, we have to pick between main drop and the large sateilte
     
  if (size(center,1)>84)
      worse_case(worse_index,:)=[block_num,cell_num];
      worse_index = worse_index + 1;
      %fprintf("Worse case happens,b%d,c%d\n",block_num,cell_num)
      center = transpose(center);
      ite =1;
      ind=[];
      for i= 1:size(center,2)
          for j= 1:size(center,2)
              if(i~=j)  
                 dist = center(:,i)-center(:,j);
                 %fprintf("d1;%d,d2:%d\n",dist(1),dist(2))
                  %size(dist)
                 % dist = sqrt(sum(dist.^2));
                  if(abs(dist(1))<40 && abs(dist(2))<40)
                       %fprintf("c11: %d,c12: %d,c21: %d,c22:%d\ndist1::%.4f dist2:%.4f\n",center(1,i),center(2,i),center(1,i),center(2,j),dist(1),dist(2))
                      if(area(i)>area(j))
                      ind(ite)=j;
                      ite = ite+1;
                      else
                          ind(ite) = i;
                          ite= ite+1;
                      end
                  end
              end
          end
      end
      ind =unique(ind);
     center = transpose(center);
     for i = 1:numel(ind)
     center(ind(i),:) =[];
     end
  end
   %size(center)
   %break;
   %catch the bad
  if(size(center,1)~= 84)
      imshow(bin_image)
      hold on
      plot(center(:,1),center(:,2),"g+")
       fprintf("%d,%d,%d\n",cell_num,block_num,size(center,1));
  end
  if(size(worse_case,1)==0)
      worse_case=[-1,-1];
  end
  if(size(second,1)==0)
      second=[-1,-1];
  end
  %% sorting and assign the data
    center = sortrows(center,1);
  %size(center)
   for i= 1:num_drop:num_drop*num_nozz
       ending = i+num_drop-1;
       temp = center(i:ending,:);
       temp = sortrows(temp,2);
       center(i:ending,:) = temp;
       
   end
   
  
   %extract the column centorid
   cells(cell_num).block(block_num).CC = reshape(center(:,1),[num_drop,num_nozz]);
   %sort and extract the row centroid
   cells(cell_num).block(block_num).RC = reshape(center(:,2),[num_drop,num_nozz]);
   %extract filename
   cells(cell_num).block(block_num).Filename = filename;
   %extract label matrix
  % cells(cell_num).block(block_num).Bin_Label = l;
   
   %extract filtered image
   %cells(cell_num).block(block_num).Image = image;
   datalist(cell_num).block(block_num).image = image;
   %assign block number 
   cells(cell_num).block(block_num).BlockNum = block_num;
   %assign cell number
   cells(cell_num).CellNum = cell_num;
   %extract original image(optional)
   %cells(cell_num).block(block_num).Original_I = sub_interpol2(filename,res_o,res_n);
   if(mod(cell_num,num_cell)==0)
       count = count+1;
       fprintf("#%d block has been completed\n",count); 
   end
end
end
