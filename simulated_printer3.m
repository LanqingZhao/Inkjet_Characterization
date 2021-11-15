function   simulated_printer3(image,res1,res2,gmm_2d,dot_size,Nozzle_Bag)
%% Summary
%a simulated printer.
%input:
%image: given image
%gmm_2d: 2d gm models
%res1: real printer resolution
%res2: simulated printer resolution
%Nozzle_Bag: nozzle information
%output: saving simulated image
%% data preallocation
tic
fprintf("Simulation to print:"+image+"\n")
I = imread(image);
wid = size(I,2);
hght = size(I,1);
page = ones(11*res1,8.5*res1)*255;
left_c = (8.5*res1-wid)/2;
left_r = (11*res1-hght)/2;
ratio = res2/res1;
b_c = left_c+1;
e_c = b_c+wid-1;
b_r = left_r+1;
e_r = b_r+hght-1;
page(b_r:e_r,b_c:e_c) = I;
page = uint8(page);
start = 111;
w = (wid+10)*ratio;
h = (hght+8)*ratio;
id_im = zeros(h,w);
sim_im_lrk= zeros(h,w);
sim_im_lr5= zeros(h,w);
sim_im_lr6= zeros(h,w);
sim_im_gfk= zeros(h,w);
sim_im_gf5= zeros(h,w);
sim_im_gf6= zeros(h,w);
sim_im_lr3 = zeros(h,w);
sim_im_gf3 = zeros(h,w);
sim_im_lr4 = zeros(h,w);
sim_im_gf4 = zeros(h,w);
%gmm5
vd_l = zeros(11*res1,8.5*res1);
hd_l = zeros(11*res1,8.5*res1);
vd_g = zeros(11*res1,8.5*res1);
hd_g = zeros(11*res1,8.5*res1);
%kde
vd_lk = zeros(11*res1,8.5*res1);
hd_lk = zeros(11*res1,8.5*res1);
vd_gk = zeros(11*res1,8.5*res1);
hd_gk = zeros(11*res1,8.5*res1);
%gmm6
vd_l6 = zeros(11*res1,8.5*res1);
hd_l6 = zeros(11*res1,8.5*res1);
vd_g6 = zeros(11*res1,8.5*res1);
hd_g6 = zeros(11*res1,8.5*res1);
%gmm3
vd_l3 = zeros(11*res1,8.5*res1);
hd_l3 = zeros(11*res1,8.5*res1);
vd_g3 = zeros(11*res1,8.5*res1);
hd_g3 = zeros(11*res1,8.5*res1);
%gmm4
vd_l4 = zeros(11*res1,8.5*res1);
hd_l4 = zeros(11*res1,8.5*res1);
vd_g4 = zeros(11*res1,8.5*res1);
hd_g4 = zeros(11*res1,8.5*res1);
num_nozz = numel(gmm_2d);
stop = 11*res1 - 110;
height =stop-start;
%% generate random displacement
for i = start:start+num_nozz-1
     index = i-110;
      %gmm5
       d_l =  (random(gmm_2d(index).Linear_Regression.GMM5,height));
       hd_l(start:stop-1,i)= d_l(:,1);
       vd_l(start:stop-1,i)= d_l(:,2);
       d_g = (random(gmm_2d(index).Grid_Fit.GMM5,height));
       hd_g(start:stop-1,i)= d_g(:,1);
       vd_g(start:stop-1,i)= d_g(:,2);
       %gmm6
       d_l =  (random(gmm_2d(index).Linear_Regression.GMM6,height));
       hd_l6(start:stop-1,i)=d_l(:,1);
       vd_l6(start:stop-1,i)=d_l(:,2);
       d_g = (random(gmm_2d(index).Grid_Fit.GMM6,height));
       hd_g6(start:stop-1,i)= d_g(:,1);
       vd_g6(start:stop-1,i)= d_g(:,2);
       %gmm4
       d_l =  (random(gmm_2d(index).Linear_Regression.GMM4,height));
       hd_l4(start:stop-1,i)= d_l(:,1);
       vd_l4(start:stop-1,i)= d_l(:,2);
       d_g = (random(gmm_2d(index).Grid_Fit.GMM4,height));
       hd_g4(start:stop-1,i)= d_g(:,1);
       vd_g4(start:stop-1,i)= d_g(:,2);

       if(mod(index,402) ==0)
       fprintf("Generated random displacement for %i nozzles\n",index)
       end
end
fprintf("\nTotal displacement generated:%i\n\n",numel(vd_g6))
%gmm4
fprintf("%.3f percent printer pixels has LRH displacement less than 0.5 simulated pixel under GMM4\n",numel(find(abs(hd_l4)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRV displacement less than 0.5 simulated pixel under GMM4\n",numel(find(abs(vd_l4)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRH displacement less than 1 simulated pixel under GMM4\n",numel(find(abs(hd_l4)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRV displacement less than 1 simulated pixel under GMM4\n\n",numel(find(abs(vd_l4)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFH displacement less than 0.5 simulated pixel under GMM4\n",numel(find(abs(hd_g4)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFV displacement less than 0.5 simulated pixel under GMM4\n",numel(find(abs(vd_g4)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFH displacement less than 1 simulated pixel under GMM4\n",numel(find(abs(hd_g4)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFV displacement less than 1 simulated pixel under GMM4\n\n",numel(find(abs(vd_g4)<(1/ratio)))/numel(vd_g6)*100)
%gmm5
fprintf("%.3f percent printer pixels has LRH displacement less than 0.5 simulated pixel under GMM5\n",numel(find(abs(hd_l)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRV displacement less than 0.5 simulated pixel under GMM5\n",numel(find(abs(vd_l)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRH displacement less than 1 simulated pixel under GMM5\n",numel(find(abs(hd_l)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRV displacement less than 1 simulated pixel under GMM5\n\n",numel(find(abs(vd_l)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFH displacement less than 0.5 simulated pixel under GMM5\n",numel(find(abs(hd_g)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFV displacement less than 0.5 simulated pixel under GMM5\n",numel(find(abs(vd_g)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFH displacement less than 1 simulated pixel under GMM5\n",numel(find(abs(hd_g)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFV displacement less than 1 simulated pixel under GMM5\n\n",numel(find(abs(vd_g)<(1/ratio)))/numel(vd_g6)*100)
%gmm6
fprintf("%.3f percent printer pixels has LRH displacement less than 0.5 simulated pixel under GMM6\n",numel(find(abs(hd_l6)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRV displacement less than 0.5 simulated pixel under GMM6\n",numel(find(abs(vd_l6)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRH displacement less than 1 simulated pixel under GMM6\n",numel(find(abs(hd_l6)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has LRV displacement less than 1 simulated pixel under GMM6\n\n",numel(find(abs(vd_l6)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFH displacement less than 0.5 simulated pixel under GMM6\n",numel(find(abs(hd_g6)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFV displacement less than 0.5 simulated pixel under GMM6\n",numel(find(abs(vd_g6)<(0.5/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFH displacement less than 1 simulated pixel under GMM6\n",numel(find(abs(hd_g6)<(1/ratio)))/numel(vd_g6)*100)
fprintf("%.3f percent printer pixels has GFV displacement less than 1 simulated pixel under GMM6\n\n",numel(find(abs(vd_g6)<(1/ratio)))/numel(vd_g6)*100)
%I = padarray(I,[3,3],255,"Both");
%I = padarray(I,[3,3],255,"Both");
[r,c]= find(I==0);
[rn,cn] = find(page==0);
%% generating random dot profile ("ink drop") and generate simulated image
fprintf( '"printing" images\n')
for i = 1:numel(r)
       index = cn(i)-110;
        %lr gmm5
       k= -1+2*rand(1);
       dis = ([vd_l(rn(i),cn(i)),hd_l(rn(i),cn(i))]);
       row1 = round((r(i)+dis(1)+5))*ratio-ratio/2-dot_size(1)*ratio/2;
       row2 = round((r(i)+dis(1)+5))*ratio-ratio/2+dot_size(1)*ratio/2;
       col1 = round((c(i)+dis(2)+4))*ratio-ratio/2-dot_size(2)*ratio/2;
       col2 = round((c(i)+dis(2)+4))*ratio-ratio/2+dot_size(2)*ratio/2;
       mean = Nozzle_Bag(index).Dot_Profile.Mean((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       dot = mean+k*Nozzle_Bag(index).Dot_Profile.SD((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       sim_im_lr5(row1:row2,col1:col2) =  sim_im_lr5(row1:row2,col1:col2)+(dot)*255;
       %gf gmm5
       k= -1+2*rand(1);
       dis = ([vd_g(rn(i),cn(i)),hd_g(rn(i),cn(i))]);
       row1 = round((r(i)+dis(1)+5))*ratio-ratio/2-dot_size(1)*ratio/2;
       row2 = round((r(i)+dis(1)+5))*ratio-ratio/2+dot_size(1)*ratio/2;
       col1 = round((c(i)+dis(2)+4))*ratio-ratio/2-dot_size(2)*ratio/2;
       col2 = round((c(i)+dis(2)+4))*ratio-ratio/2+dot_size(2)*ratio/2;
       mean = Nozzle_Bag(index).Dot_Profile.Mean((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       dot = mean+k*Nozzle_Bag(index).Dot_Profile.SD((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       sim_im_gf5(row1:row2,col1:col2) = sim_im_gf5(row1:row2,col1:col2)+(dot)*255;
        %lr gmm6
       k= -1+2*rand(1);
       dis = ([vd_l6(rn(i),cn(i)),hd_l6(rn(i),cn(i))]);
       row1 = round((r(i)+dis(1)+5))*ratio-ratio/2-dot_size(1)*ratio/2;
       row2 = round((r(i)+dis(1)+5))*ratio-ratio/2+dot_size(1)*ratio/2;
       col1 = round((c(i)+dis(2)+4))*ratio-ratio/2-dot_size(2)*ratio/2;
       col2 = round((c(i)+dis(2)+4))*ratio-ratio/2+dot_size(2)*ratio/2;
       mean = Nozzle_Bag(index).Dot_Profile.Mean((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       dot = mean+k*Nozzle_Bag(index).Dot_Profile.SD((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       sim_im_lr6(row1:row2,col1:col2) =  sim_im_lr6(row1:row2,col1:col2)+(dot)*255;
       %gf gmm6
       k= -1+2*rand(1);
       dis = ([vd_g6(rn(i),cn(i)),hd_g6(rn(i),cn(i))]);
       row1 = round((r(i)+dis(1)+5))*ratio-ratio/2-dot_size(1)*ratio/2;
       row2 = round((r(i)+dis(1)+5))*ratio-ratio/2+dot_size(1)*ratio/2;
       col1 = round((c(i)+dis(2)+4))*ratio-ratio/2-dot_size(2)*ratio/2;
       col2 = round((c(i)+dis(2)+4))*ratio-ratio/2+dot_size(2)*ratio/2;
       mean = Nozzle_Bag(index).Dot_Profile.Mean((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       dot = mean+k*Nozzle_Bag(index).Dot_Profile.SD((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       sim_im_gf6(row1:row2,col1:col2) = sim_im_gf6(row1:row2,col1:col2)+(dot)*255;
       
       %lr gmm4
       k= -1+2*rand(1);
       dis = ([vd_l4(rn(i),cn(i)),hd_l4(rn(i),cn(i))]);
       row1 = round((r(i)+dis(1)+5))*ratio-ratio/2-dot_size(1)*ratio/2;
       row2 = round((r(i)+dis(1)+5))*ratio-ratio/2+dot_size(1)*ratio/2;
       col1 = round((c(i)+dis(2)+4))*ratio-ratio/2-dot_size(2)*ratio/2;
       col2 = round((c(i)+dis(2)+4))*ratio-ratio/2+dot_size(2)*ratio/2;
       mean = Nozzle_Bag(index).Dot_Profile.Mean((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       dot = mean+k*Nozzle_Bag(index).Dot_Profile.SD((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       sim_im_lr4(row1:row2,col1:col2) = sim_im_lr4(row1:row2,col1:col2)+(dot)*255;
      
       %gf gmm4
       k= -1+2*rand(1);
       dis = ([vd_g4(rn(i),cn(i)),hd_g4(rn(i),cn(i))]);
       row1 = round((r(i)+dis(1)+5))*ratio-ratio/2-dot_size(1)*ratio/2;
       row2 = round((r(i)+dis(1)+5))*ratio-ratio/2+dot_size(1)*ratio/2;
       col1 = round((c(i)+dis(2)+4))*ratio-ratio/2-dot_size(2)*ratio/2;
       col2 = round((c(i)+dis(2)+4))*ratio-ratio/2+dot_size(2)*ratio/2;
       mean = Nozzle_Bag(index).Dot_Profile.Mean((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       dot = mean+k*Nozzle_Bag(index).Dot_Profile.SD((31-ratio*dot_size(1)/2):(31+ratio*dot_size(1)/2),(25-ratio*dot_size(2)/2):(25+ratio*dot_size(2)/2));
       sim_im_gf4(row1:row2,col1:col2) =  sim_im_gf4(row1:row2,col1:col2)+(dot)*255;
      
end
%% saving
%save gmm5
imwrite(uint8(255-uint8(sim_im_lr5)),"gmm5lr2d_"+image,"Resolution",res2)
imwrite(uint8(255-uint8(sim_im_gf5)),"gmm5gf2d_"+image,"Resolution",res2)
 fprintf("Complete GMM5 \n")
%save gmm6
imwrite(uint8(255-uint8(sim_im_lr6)),"gmm6lr2d_"+image,"Resolution",res2)
imwrite(uint8(255-uint8(sim_im_gf6)),"gmm6gf2d_"+image,"Resolution",res2)
fprintf("Complete GMM6 \n")
%save gmm4
imwrite(uint8(255-uint8(sim_im_lr4)),"gmm4lr2d_"+image,"Resolution",res2)
imwrite(uint8(255-uint8(sim_im_gf4)),"gmm4gf2d_"+image,"Resolution",res2)
fprintf("Complete GMM4 \n")
%save 600dpi
imwrite(uint8(page),"o_"+image,"Resolution",res1)
fprintf("orignial completed\n")
time = toc;
fprintf("Time used:%.3f sec\n",time)
end