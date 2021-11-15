function [points] = connected_comp(b,image)
%% The summary of the code
%% step 3 : find the objects from background and generate centroid
%input a binary mask and original image
%output: 

%points:a struct that contains all object
%field:
%Location: linear index of the object pixel
%Pixel: pixel value in original image (converted to double)
%Row: row location of the object pixel
%Col: column location of the object pixel
%Area: area of the object
%ID: the id number of object
%TotalPixel: the sum of absorptance(0,255) of the object
%RC: row coordiate of the weighted centroid
%CC: column coordiate of the weighted centroid
%FO: first occurance in linear index 

%This function takes two input: the binary mask of the image and the
%original image and outputs the map of the object and the summary of each
%object including area,total pixel values, and the cooridate of 
%the weighted centroid.This function applies 8 connectivity search and
%disjoint-union data structure algorithm.

%The idea of 8-connectivity search in a binary image comes from wikipedia
%and André Ødegårdstuen's code. The disjoint-union search algorithm has
%some similar purpose of André Ødegårdstuen's code but implements very differently from
%André Ødegårdstuen's code. The idea is to link all raw labels with its
%minimum equivalent labels and reloop the ordered set of raw label to check
%adjancey of all raw label 

%% initalize the variables

temp = logical(1-b); %convert the input to opposite color
%obtain row and column of the input
row = size(b,1);
col = size(b,2);
%zero padding
b(1:row+2,1:col+2) =0;
b(2:row+1,2:col+1) = temp;
%initalize the label matrix
l = zeros(row+2,col+2);
%initalize label counter
label_ct =0;
%initalize label dictionary: key: the raw label encoded as the index
%value:the minimum equivalent label
label_dictionary =[];
%The below code uses built in map, which is slow.
%label_dictionary = containers.Map('KeyType','int64','ValueType','int64');

%% find the raw label union and connect the disjoint union

for i = 2:row+1
    for j = 2:col+1
        
        if(b(i,j))%find the foreground 
            % find the neighbor 
            adj = [b(i-1,j+1),b(i-1,j),b(i-1,j-1),b(i,j-1)];
            %check whether the neighbors are foreground or background
            [~,k,check] = find(adj == 1);
        
            if(isempty(check))%if neighbors are all background
                %assign a new label
            label_ct= label_ct+1;
            label_dictionary(label_ct) = label_ct;% create a new label key in dictionary
            l(i,j)= label_ct;% assign the raw label
            else% if the foreground exists around neighbors
                % extract the neighbors
            adj_label = [l(i-1,j+1),l(i-1,j),l(i-1,j-1),l(i,j-1)];
            %find the index of neighbors
            label = adj_label(k);
            %find the unique values of labels among the neighbors
            label = unique(label);
           %assign minimum value of labels to the center elements of label
           %array
           min_label = min(label);
           l(i,j) = min_label;
           %relabel the value of dictionary key as the value of minimun
           %code above from André Ødegårdstuen's idea and wikipedia
           %code below is written by me
           %label so that the equivalent labels are connected 
           for index = 1:numel(label)
                label_dictionary(label(index)) = label_dictionary(min_label);
                %the min_label reference may not be necessary
           end
        
            end
        end
        
    end
end

%connect the disjoint union
for i = 1:numel(label_dictionary)
    for j = i+1:numel(label_dictionary)
        
        % if the value of one element j in dictionary is equal to key of
        % i, reassign the value of j equal to the value of i to link two
        % vertices
        if(label_dictionary(j) ==i) 
            label_dictionary(j) = label_dictionary(i);
           
        end
        
    end
end

%% swap the label as unique connected componets
%relabel the raw label as its value in dictionary
for i = 2:row+1
    for j = 2:col+1
        if(b(i,j)==1)
        l(i,j) = label_dictionary(l(i,j));
        end
    end
end
%remove the zero padding
l = l(2:row+1,2:col+1);
%find the all values in dictionary
equ_label = unique(label_dictionary);
%remove repetitions among all values 
%equ_label = reshape(equ_label,1,numel(equ_label));
%equ_label = unique(equ_label);

% relabel the label matrix in the order of numbers
for i = 1:size(l,1)
    for j= 1:size(l,2)
        if(ismember(l(i,j),equ_label)>0)
            l(i,j) = find(equ_label ==l(i,j));
        end
        
    end
end 

%% mark the object location and area
for i = 1:size(equ_label,2)
    %find the location of the object
    k = find(l==i);
    %fo = find(mirror(rot270(l)==i));
    [r,c,~] = find(l==i);
   % combined = [r,c];
    %rc_sum = sum(combined,2);
    pixel_value = uint8(255-image(k));
    %find the area of the object
    area = numel(k);
    
    % assign the area and location with its id in the struct of points 
    points(i).Location = k;%linear location
    points(i).Pixel = double(pixel_value);%pixel value in original image
    points(i).Row = double(r);%row location
    points(i).Col = double(c);%column location
    points(i).Area = area;%area of the object
    points(i).ID = i;%object id
    points(i).FO =k(1);%first occurance
end
attri =zeros(numel(points),3);
%% find the centroid
for i = 1:numel(points)
    %find the sum of all pixel value of an object
    attri(i,1) = sum(points(i).Pixel);
    %find the row weighted sum
    attri(i,2) = sum(points(i).Pixel.*points(i).Row);
    %find the column weighted sum
    attri(i,3) = sum(points(i).Pixel.*points(i).Col);
    %assign the total pixel value to the field
    points(i).TotalPixel=  attri(i,1);
    %find the row centroid
    points(i).RC =  double(attri(i,2))/double(attri(i,1));
    %find the column centroid
    points(i).CC = double(attri(i,3))/double(attri(i,1));
end

end
