function [hd,vd,vd2,CellProfile] = displacement3(cells,drop_num,nozz_num,stride,res1,res2,CellProfile)
%% summary
%This function finds the horizontal displacement and vertical displacement
%of one column or one row of all cells in different block and update the
%cell profile to add these data for each individual cell
%input :cells: a struct containing basic data
% drop_num : number of drop for one nozzle in the cell
% nozz_num: number of nozzles in one cell
%stride: distance between two ink drop
%res1 : printer resolution
%res2:image resolution
%CellProfile: a struct containing profile for each cell
%output
%hd: vertical displacement struct
%vd: horizontal displacement struct
%CellProfile:updated cell profile
%details of each struct are in documentation
%% function body
% create an ideal grid system
%initalize the ideal cc and rc
ideal_x = zeros(drop_num,nozz_num);
ideal_y = zeros(drop_num,nozz_num);
ct = 0;
% find the ratio between printer resolution and image resolution
ratio = res2/res1;
% assign the ideal coordinate parameter 
for i =1:nozz_num
    ideal_x(:,i) =ct;
    ct = stride*ratio+ct;
end
ct = 0;
for i =1:drop_num
    ideal_y(i,:) =ct;
    ct = stride*ratio+ct;
end

%concatenate  ideal grid as two 1 column matrix
ideal_x = reshape(ideal_x,[drop_num*nozz_num,1]);
ideal_y = reshape(ideal_y,[drop_num*nozz_num,1]);
% combine two axis as one matrix
ideal_axis = [ideal_x,-ideal_y];% shape: total dots*2
%standardize the ideal axis by substracting their mean
mean_ideal = transpose(mean(ideal_axis));%shape: 2*1
ideal_axis = transpose(ideal_axis);%shape :2*total dots
std_ideal = ideal_axis - mean_ideal;%standardize data
%loop over cells 
for i = 1:numel(cells)
    %loop over each block
    for j = 1:numel(cells(i).block)
        % grid fit method
        %extract the actual axis of x and y
        real_x = cells(i).block(j).CC;
        real_y = cells(i).block(j).RC;
        %concatenate actual axis to two 1 column matrices
        real_x = reshape(real_x,[drop_num*nozz_num,1]);%dots *1 
        real_y = reshape(real_y,[drop_num*nozz_num,1]);%dots *1 
        %combine x and y axis
        real_axis = [real_x,-real_y];%dots *2
        %standardize the actual axis by substracting their mean
        mean_real = transpose(mean(real_axis));%2*1
        
        real_axis = transpose(real_axis); %2*dots
        std_real = real_axis - mean_real;%standardize the data
        % find the linear transformation between them
        M = std_real *transpose(std_ideal);
        % decompose the transformation via SVD
        [U,~,V] = svd(M);
        %use two orthoganal matrices to find the transformation of 2 basis
        R= U*diag([1,det(V*transpose(U))])*transpose(V);%2*2
        % find the translation vector
        t = mean_real -R * mean_ideal;%2*1  
        % find the fitted points
        fit_axis = transpose(R*ideal_axis+t); %total dot *2
        % reshape the fitted values of orthongal transformation
        fit_CC = reshape(fit_axis(:,1),[drop_num,nozz_num]);
        fit_RC = reshape(-fit_axis(:,2),[drop_num,nozz_num]);
        %assign the fitted basis 
        CellProfile(i).IndividualProfile(j).Displacement2.Fitted_Basis = R;
        %assign the block id for each cell
        CellProfile(i).IndividualProfile(j).Displacement2.Block_ID = j;
        %assign the block id for each cell
        CellProfile(i).IndividualProfile(j).Displacement2.Vertical_Fit = fit_RC;
        CellProfile(i).IndividualProfile(j).Displacement2.Horizontal_Fit =fit_CC;    
        % linear regression method
        %find the vetrical fit line
        for k1 = 1:nozz_num
            %find the vertical fit line for each column
           v_fit = polyfit(cells(i).block(j).RC(:,k1),cells(i).block(j).CC(:,k1),1);
           v_fit2 = polyfit(fit_RC(:,k1),fit_CC(:,k1),1);
           % find the normal vector[a;b] from y = ax+c to ax+by =c
           n_vector = [-v_fit(1),1]/norm([-v_fit(1),1]);
           axis = transpose([cells(i).block(j).RC(:,k1),cells(i).block(j).CC(:,k1)]);
           n_vector2 = [-v_fit2(1),1]/norm([-v_fit2(1),1]);
           %find |c| based on c = y0*b
           c = v_fit(2)*n_vector(2);
           c2 = v_fit2(2)*n_vector2(2);
           %compute the displacement and fitted points
           hdis = (n_vector*axis-c)/ratio;%/norm([-v_fit(1);1]);
           hfit = polyval(v_fit,cells(i).block(j).RC(:,k1));
           hdis2 = (n_vector2*axis-c2)/ratio;%/norm([-v_fit2(1);1]);
           %computer the error and squared error
           hdisplace2 = (hdis).^2;
           hdisplace1 = hdis;
           hdisplace22 = (hdis2).^2;
           hdisplace12 = hdis2;%horizontal displacement
           % assign value to each individual nozzles
           hd(i).Displacement(1).Nozzle(k1).Vertical_FitLine(:,j) = reshape(v_fit,[2,1]);
           hd(i).Displacement(1).Nozzle(k1).Horizontal_Fit(:,j) = hfit;
           hd(i).Displacement(1).Nozzle(k1).Horizontal_SE(:,j) = hdisplace2;
           hd(i).Displacement(1).Nozzle(k1).Horizontal_L1(:,j) = hdisplace1;
           %assign the orthogonal fit method result to each individual nozzles
           hd(i).Displacement(2).Nozzle(k1).Horizontal_Fit(:,j) = fit_CC(:,k1);
           hd(i).Displacement(2).Nozzle(k1).Horizontal_SE(:,j) = hdisplace22;
           hd(i).Displacement(2).Nozzle(k1).Horizontal_L1(:,j) = hdisplace12;
           hd(i).Cell_ID = i;
           hd(i).Displacement(1).Nozzle(k1).NozzleID = k1;
           hd(i).Displacement(2).Nozzle(k1).NozzleID = k1;
           %assign the regression result to each cells
           CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_Fit(:,k1) = hfit;
           CellProfile(i).IndividualProfile(j).Displacement1.Vertical_FitLine(:,k1) = reshape(v_fit,[2,1]);
           CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_SE(:,k1) = hdisplace2;
           CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_L1(:,k1)= hdisplace1;
           CellProfile(i).IndividualProfile(j).Displacement2.Horizontal_SE(:,k1) = hdisplace22;
           CellProfile(i).IndividualProfile(j).Displacement2.Horizontal_L1(:,k1)= hdisplace12;
        end
        %find the horizontal fit line
        for k2 = 1:drop_num
            % use regression to find the fit line
            h_fit = polyfit(cells(i).block(j).CC(k2,:),cells(i).block(j).RC(k2,:),1);
            h_fit2 = polyfit(fit_CC(k2,:),fit_RC(k2,:),1);
            % compute the normal vector
            n_vector = [-h_fit(1),1]./norm([-h_fit(1),1]);
            axis = [cells(i).block(j).CC(k2,:);cells(i).block(j).RC(k2,:)];
            n_vector2 = [-h_fit2(1),1]./norm([-h_fit2(1),1]);  
            %compute c in the form ax+by =c 
            c = h_fit(2)*n_vector(2);
            c2 = h_fit2(2)*n_vector2(2);
            %find the vertical displacement
            vdis = ((n_vector*axis-c)/norm([-h_fit(1),1]))/ratio;
            vdis2 = ((n_vector2*axis-c2)/norm([-h_fit2(1),1]))/ratio;
            %find the vertical fitted points
            vfit = polyval(h_fit,cells(i).block(j).CC(k2,:));
            %find the error and squared error
            vdisplace2 = (vdis).^2;
            vdisplace1 = vdis;
            vdisplace22 = (vdis2).^2;
            vdisplace12 = vdis2;%vertical displacement
            %assign regression result to each nozzles
            vd(i).Displacement(1).Row(k2).Horizontal_FitLine(j,:) = reshape(h_fit,[1,2]);
            vd(i).Displacement(1).Row(k2).Vertical_Fit(j,:) = reshape(vfit,[1,nozz_num]);
            vd(i).Displacement(1).Row(k2).Vertical_SE(j,:) = reshape(vdisplace2,[1,nozz_num]);
            vd(i).Displacement(1).Row(k2).Vertical_L1(j,:) = reshape(vdisplace1,[1,nozz_num]);
            %assign the orthognal fit result to each nozzle
            vd(i).Displacement(2).Row(k2).Horizontal_FitLine(j,:) = reshape(h_fit2,[1,2]);
            vd(i).Displacement(2).Row(k2).Vertical_Fit(j,:) = fit_RC(k2,:);
            vd(i).Displacement(2).Row(k2).Vertical_SE(j,:) =  reshape(vdisplace22,[1,nozz_num]);
            vd(i).Displacement(2).Row(k2).Vertical_L1(j,:) = reshape(vdisplace12,[1,nozz_num]);
            vd(i).Cell_ID = i;
            vd(i).Displacement(1).Row(k2).RowID = k2;
            vd(i).Displacement(2).Row(k2).RowID = k2;
            %assign the regression result to each cell
            CellProfile(i).IndividualProfile(j).Displacement1.Vertical_Fit(k2,:) = reshape(vfit,[1,nozz_num]);
            CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_FitLine(k2,:) = reshape(v_fit,[1,2]);
            CellProfile(i).IndividualProfile(j).Displacement1.Vertical_SE(k2,:) = reshape(vdisplace2,[1,nozz_num]);
            CellProfile(i).IndividualProfile(j).Displacement1.Vertical_L1(k2,:)= reshape(vdisplace1,[1,nozz_num]);
            CellProfile(i).IndividualProfile(j).Displacement2.Vertical_SE(k2,:) = reshape(vdisplace22,[1,nozz_num]);
            CellProfile(i).IndividualProfile(j).Displacement2.Vertical_L1(k2,:)= reshape(vdisplace12,[1,nozz_num]);
        end
        %compute rmse of regression and orthogonal transform method for each cell
        %Linear Regression
        CellProfile(i).IndividualProfile(j).Displacement1.Block_ID = j;
        MSE_h = sum(CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_SE,"all")/(drop_num*nozz_num);
        CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_RMSE=sqrt(MSE_h);
        MSE_v = sum(CellProfile(i).IndividualProfile(j).Displacement1.Vertical_SE,"all")/(drop_num*nozz_num);
        CellProfile(i).IndividualProfile(j).Displacement1.Vertical_RMSE=sqrt(MSE_v);
        %grid fit
        MSE_h = sum(CellProfile(i).IndividualProfile(j).Displacement2.Horizontal_SE,"all")/(drop_num*nozz_num);
        CellProfile(i).IndividualProfile(j).Displacement2.Horizontal_RMSE=sqrt(MSE_h);
        MSE_v = sum(CellProfile(i).IndividualProfile(j).Displacement2.Vertical_SE,"all")/(drop_num*nozz_num);
        CellProfile(i).IndividualProfile(j).Displacement2.Vertical_RMSE=sqrt(MSE_v);
       %label method name
        CellProfile(i).IndividualProfile(j).Displacement1.MethodName ="Linear Regression";
        CellProfile(i).IndividualProfile(j).Displacement2.MethodName ="Orthogonal Transformation";  
    end
    fprintf("Cell #%d is computed\n",i)
end
fprintf("\n")
%% combined two displacement together
% x is in first column y is in second column
tot = drop_num*nozz_num;
for i = 1:numel(CellProfile)
    for j = 1:numel(CellProfile(i).IndividualProfile)
        combined = zeros(tot,2);
        combined(:,1) = reshape(CellProfile(i).IndividualProfile(j).Displacement1.Horizontal_L1,[tot,1]);
        combined(:,2) = reshape(CellProfile(i).IndividualProfile(j).Displacement1.Vertical_L1,[tot,1]);
        CellProfile(i).IndividualProfile(j).Displacement1.Pair_Displacement = combined;
        combined = zeros(tot,2);
        combined(:,1) = reshape(CellProfile(i).IndividualProfile(j).Displacement2.Horizontal_L1,[tot,1]);
        combined(:,2) = reshape(CellProfile(i).IndividualProfile(j).Displacement2.Vertical_L1,[tot,1]);
        CellProfile(i).IndividualProfile(j).Displacement2.Pair_Displacement = combined;
    end
    fprintf("Cell #%d is combined!\n",i)
end
% store vertical displacement for each nozzle
for i = 1:numel(CellProfile)
   for j = 1:nozz_num
       for k = 1:numel(CellProfile(i).IndividualProfile)
           vd2(i).Displacement(1).Nozzle(j).Vertical_L1(:,k) =CellProfile(i).IndividualProfile(k).Displacement1.Vertical_L1(:,j);
           vd2(i).Displacement(2).Nozzle(j).Vertical_L1(:,k) =CellProfile(i).IndividualProfile(k).Displacement2.Vertical_L1(:,j);
           vd2(i).Displacement(1).Nozzle(j).Vertical_SE(:,k) =CellProfile(i).IndividualProfile(k).Displacement1.Vertical_SE(:,j);
           vd2(i).Displacement(2).Nozzle(j).Vertical_SE(:,k) =CellProfile(i).IndividualProfile(k).Displacement2.Vertical_SE(:,j);
           vd2(i).Cell_ID = i;
       end     
   end
   fprintf("Vertical Displacement of Cell# %d is completed\n",i)
end
end