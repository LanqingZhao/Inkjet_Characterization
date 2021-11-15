function [profile,hd1,hd2,hd3,hd4]=nozzle_info(cell_id,nozz_id,package)
%% Summary
%This function reads and extracts information of individual nozzle
%Input
%cell_id: cell id
%nozz_id: nozzle id in each cell
%package: the database
%output
%profile: the nozzle dot profile
%h1 - h4 horizontal displacement of 4 methods 
profile = package(cell_id).CellProfile.DotProfile(nozz_id);
hd1 = package(cell_id).Horizontal.Displacement(1).Nozzle(nozz_id);
hd2 = package(cell_id).Horizontal.Displacement(2).Nozzle(nozz_id);
hd3 = package(cell_id).Horizontal.Displacement(3).Nozzle(nozz_id);
hd4 = package(cell_id).Horizontal.Displacement(4).Nozzle(nozz_id);
end
