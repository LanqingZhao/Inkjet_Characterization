function [output] = sub_interpol2(filename,res_o,res_n)
%% VERSION 2 
% NOTE: res_o/res_n MUST NOT be greater than 2
%% summary of function
%step1 perform interpolation on original image
%input : filename : name of the original image
% res_o: old resolution
% res_n : the new resolution
%output: the new image matrix 
% This function will do subpixel interpolation on an image with old
% resolution and output an image with new resolution. The idea is from Shikai Zhou


%% variable initailzation
image = imread(filename);%read the image
image = rgb2gray(image);%transform to grayscale
row = size(image,1);% obtain the row of old image
row_new = ceil(row/res_o*res_n);%obtain the row of new image
col = size(image,2);%obtain the column of old image
col_new = ceil(col/res_o*res_n);%obtain the column of new image
image(row:row+2,col:col+2) = 0;%zero padding
o_size = double(1/res_o);% old size of one pixel
n_size = double(1/res_n);%new size of one pixel 
output = double(ones(row_new,col_new));%initalize output
i = 1;%initalize the row counter of old image
j = 1;%initalize the column counter of old image
image = double(image);% convert the data type of old image 
%% interpolation 
% loop over the new image
for x =1:row_new
    for y = 1:col_new
        % obtain the parameter to calculate the area relation between old
        % pixel and new pixel
        a = j*o_size-(y-1)*n_size;
        c = y*n_size-j*o_size;
        b = i*o_size -(x-1)*n_size;
        d = x*n_size - i*o_size;
        % case 1 no complete overlap of old pixel in new pixel
        if(c<o_size && d< o_size)
            % calculate the weighted pixel value 
        output(x,y) = a*b*image(i,j)+c*b*image(i,j+1)+a*d*image(i+1,j)+c*d*image(i+1,j+1);
        
         j= j+1;%update the column of old pixel by 1 
  
        if(j>col)% change of row 
        j =1;
        i = i+1;
        end
        % case2 the left and right edge of the old pixel inside the new
        % pixel
       elseif(c>o_size && d<o_size)
           % calculate the weighted pixel value
       output(x,y) = a*b*image(i,j)+o_size*b * image(i,j+1) + (c-o_size)*b*image(i,j+2);
       output(x,y) = output(x,y) +d*a*image(i+1,j)+ o_size*d*image(i+1,j+1)+(c-o_size)*d*image(i+1,j+2);
        j  = j+2;% update the column of old pixel by two
        
  
       if(j>col)% change of row
        j =1;
        i= i+1;
       end
       % case 3 the upper and lower edge of the old pixel inside the new
       % pixel
     elseif(c<o_size && d>o_size)
         % calculate the weighted pixel value
       output(x,y) = a*b*image(i,j)+o_size*a*image(i+1,j)+(d-o_size)*a*image(i+2,j);
       output(x,y) = output(x,y)+b*c*image(i,j+1) +o_size*c*image(i+1,j+1)+(d-o_size)*c*image(i+2,j+1);
       j = j+1;%update the column of old pixel by 1 
    
    
       if(j>col)% change the row by 2 
        j =1 ;
        i = i+2; 
       end
       % case 4 all edges of old pixel are inside the new pixel 
      elseif(c>o_size&&d>o_size)
          % calculate the weighted pixel value
       output(x,y) = a*b*image(i,j)+o_size*b*image(i,j+1)+(c-o_size)*b*image(i,j+2);
       output(x,y) = output(x,y)+ a*o_size*image(i+1,j)+o_size^2*image(i+1,j+1)+(c-o_size)*o_size*image(i+1,j+2);
       output(x,y) = output(x,y)+ a*(d-o_size)*image(i+2,j)+o_size*(d-o_size)*image(i+2,j+1) +(c-o_size)*(d-o_size)*image(i+2,j+2);
        j = j+2;%update the column of old pixel by 2
        
         if(j>col)%update the row of old pixel by 2
           j =1;
           i = i+2;       
         end
        end             
    end  
end
%find the weighted average pixel value of new image
output = uint8(output/(n_size^2));
%remove the edge due to zero-padding
output_col = size(output,2);
output = uint8(output(:,1:output_col-1));
end