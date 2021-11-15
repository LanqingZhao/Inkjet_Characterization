function bad= find_bad(filename)
%checking function: check whether bad images still exist
matrix = readmatrix(filename);
h_rmse = matrix(:,5);
block = matrix(:,2);
cell = matrix(:,1);
index = find(h_rmse>7);
bad_block = block(index);
bad_block = reshape(bad_block,[numel(bad_block),1]);
bad_cell = cell(index);
bad_cell = reshape(bad_cell,[numel(bad_cell),1]);
bad = [bad_block,bad_cell];
end