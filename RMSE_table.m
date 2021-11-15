function RMSE_table(package,filename)
%% summary 
%This function takes the input of a package struct of dot profile data, and
%save the rmse of each method as .csv
%input : package: database of dot profile data
%% function body
%extract data
ct = 1;
for i = 1:numel(package)
    for j= 1:numel(package(i).CellProfile.IndividualProfile)
        RMSE(ct).Cell_ID = i;
        RMSE(ct).Block_ID = j;
        RMSE(ct).HLR = round(package(i).CellProfile.IndividualProfile(j).Displacement1.Horizontal_RMSE,4);
        RMSE(ct).VLR = round(package(i).CellProfile.IndividualProfile(j).Displacement1.Vertical_RMSE,4);
       % RMSE(ct).HGF = round(package(i).CellProfile.IndividualProfile(j).Displacement5.Horizontal_RMSE,4);
       % RMSE(ct).VGF = round(package(i).CellProfile.IndividualProfile(j).Displacement5.Vertical_RMSE,4);
        RMSE(ct).HGF = round(package(i).CellProfile.IndividualProfile(j).Displacement2.Horizontal_RMSE,4);
        RMSE(ct).VGF = round(package(i).CellProfile.IndividualProfile(j).Displacement2.Vertical_RMSE,4);
       % RMSE(ct).HGF2 = round(package(i).CellProfile.IndividualProfile(j).Displacement4.Horizontal_RMSE,4);
       % RMSE(ct).VGF2 = round(package(i).CellProfile.IndividualProfile(j).Displacement4.Vertical_RMSE,4);
        %RMSE(ct).HAT = round(package(i).CellProfile.IndividualProfile(j).Displacement3.Horizontal_RMSE,4);
       % RMSE(ct).VAT = round(package(i).CellProfile.IndividualProfile(j).Displacement3.Vertical_RMSE,4);
        ct = ct+1;
    end
end


%save the new file
writetable(struct2table(RMSE), filename)
end
