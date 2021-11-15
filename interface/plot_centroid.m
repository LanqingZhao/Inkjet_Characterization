function plot_centroid(package,cell_id,block_id,res_o,res_n)
%% summary
%This function plots centroid of a cell
%input: package: database
%cell_id: cell id
%block_id: block id
%% function body
rc = package(cell_id).BasicData.block(block_id).RC;
cc = package(cell_id).BasicData.block(block_id).CC;
I = sub_interpol2(package(cell_id).BasicData.block(block_id).Filename,res_o,res_n);
figure(1)
imshow(I)
hold on
plot(cc,rc,"g+")
title("Centroid plot of cell"+string(cell_id)+"block"+string(block_id))
end
