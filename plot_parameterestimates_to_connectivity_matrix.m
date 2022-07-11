% Script to show connectivity of seed regions to voxels in the cerebellum.
% Identified peak voxels in cerebellum - i.e. voxels with higest connectivity
% values for each seed regions or AP region (each T-contrast). 
% Find parameter estimates for each voxel i.e. the extent to activity in
% each voxel is contributed to by each seed region. PE for each voxel for 
% each seed region can be used to demonstrate the extent of similarity in 
% connectivity profiles of each seed region to the cerebellum.
% Script generates a matrix showing each region/ structures PE for each peak voxel

%cd to main result directory
cd ''

% load the list of parameter estimates for each peak voxel for each seed
% loads a structure called param with two entries - the list of parameter
% estimate for each peak voxel and an identifying name for each peak voxel
load 'param_est_three_peaks' 
% load list of seednames - opens variable called seednames in workspace
load 'AP_grid_seednames_mat.mat'  

%% generate a set of index variables - that can be used to isolate all of 
% seeds that are found in major sections of the frontal cortex (lateral,
% medial, orbital and opercular surfaces)

idx_oper = ([31,40]);
idx_orbital = ([19,20,21,28,29,30,38,39]);
idx_medial = ([5,6,8,12,13,15,16,22,24,25,32,34,35,41,44,45,50,51,55]);
idx_lateral = ([1,2,3,4,7,9,10,11,14,17,18,23,26,27,33,36,37,42,43,46,47,48,49,52,53,54,56,57,58,59]);
names_orbital = seednames(idx_orbital,:);
names_lateral = seednames(idx_lateral,:);
names_medial = seednames(idx_medial,:);
names_oper = seednames(idx_oper,:);

%% generate arrays which contain all of the voxel identifying names (y) and
% the parameter estimates for each voxel (x)
x = param(1).paramater_estimates;
y = param(1).name;

%% reordered index and reordered seednames so parameter estimates are reordered
% so that the go from AP1-10 and also are aligned based on position in
% frontal cortex - lateral frontal surface -> medial -> orbital ->
% opercular
idx_reorder = ([1 2 3 4 7 6 5 9 10 11 14 13 8 12 23 18 17 15 22 16 24 19 20 ...
21 33 27 26 31 32 25 34 28 29 30 43 37 36 42 40 35 41 44 38 39 49 46 47 48 50 ...
45 54 52 53 55 51 56 57 58 59]);

seed_names_redordered = {'ML1 FPole AP1', 'ML2 FPole AP1', 'ML1 FPole AP2', 'ML2 FPole AP2',...
'SFG AP2', 'pCC AP2', 'FrMed AP2', 'ML1 FPole AP3', 'ML2 FPole AP3', 'ML3 FPole AP3',...
'SFG AP3', 'pCC AP3', 'ACC AP3', 'FrMed AP3', 'SFG AP4', 'MFG AP4', 'IFG AP4', 'ACC AP4',...
'pCC AP4', 'FrMed AP4', 'Subcalossal AP4', 'ML1 OFC AP4', 'ML2 OFC AP4', 'ML3 OFC AP4',...
'SFG AP5', 'MFG AP5', 'IFG AP5', 'Operculum AP5', 'pCC AP5', 'ACC AP5', 'Subcalossal AP5',...
'ML1 OFC AP5', 'ML2 OFC AP5', 'ML3 OFC AP5', 'SFG AP6', 'MFG AP6', 'IFG AP6', 'ML3 PCG AP6',...
'Operculum AP6', 'ACC AP6', 'pCC AP6', 'Subcalossal AP6', 'ML1 OFC AP6', 'ML2 OFC AP6',...
'SFG AP7', 'MFG AP7', 'ML2 PCG AP7', 'ML3 PCG AP7', 'SMA AP7', 'ACC AP7', 'SFG AP8', 'ML2 PCG AP8',...
'ML3 PCG AP8', 'SMA AP8', 'ACC AP8', 'ML1 PCG AP9', 'ML2 PCG AP9', 'ML1 PCG AP10', 'ML2 PCG AP10'};

% reorder the parameter estimates (x) based on AP region and frontal cortex
% surface
reordered_param_est = [];
reordered_param_est = x(idx_reorder,:);
idx_antlobe = [1,4,7,10,13,16,19,22,24,26];
idx_postlobe = [2,5,8,11,14,17,20,23,25,27];
idx_tertlobe = [3,6,9,12,15,18,21];

% select out the parameter estimates linked to peak voxels in the anteior,
% posterior and tertiary lobes of the cerebellum
param_est_ant_reorder = reordered_param_est(:,idx_antlobe);
param_est_post_reorder = reordered_param_est(:,idx_postlobe);
param_est_tert_reorder = reordered_param_est(:,idx_tertlobe);
param_est_reorder_tert = horzcat(param_est_ant_reorder, param_est_post_reorder, param_est_tert_reorder, nan(59,3));

AP = {'1','2','3','4','5','6','7','8','9','10'};

% calculate difference matrices for the main parameter estimate matrices

difference_primary_secondary = param_est_reorder_tert(:,1:10) - param_est_reorder_tert(:,11:20);
param_est_sorted_difference = horzcat(param_est_reorder_tert, difference_primary_secondary);

mini = min(min(param_est_sorted_difference));
maxi = max(max(param_est_sorted_difference));

figure(1003)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
%figure(110);
imagesc(param_est_sorted_difference);caxis([mini maxi]);colorbar;...
%     title('All Seeds','Position',[15.5,-1.5],'FontSize',13);...
    yticklabels(seed_names_redordered);yticks(1:1:59);...
    set(gca,'xticklabel',{[]});...
    xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',6);...
    xline(30.5,'-','Color','k','LineWidth',6);...
    ax = gca; ax.YAxis.FontSize = 6.5;...
%     ylabel('Seed region','FontSize',15),...
%     xlabel('AP section to cerebellum connection: Peak voxel (Primary & Secondary)','FontSize',13,...
%     'Position',[15.5,64]);... 
%     text(4,-0.5,'Primary Peak');...
%     text(14,-0.5,'Secondary Peak');...
%     text(24,-0.5,'Tertiary Peak');

%% seperate parameter estimate variables, grouping the columns that reflect 
% the primary (ant), secondary (post) and teriarty (tert) representations.

idx_antlobe = [1,4,7,10,13,16,19,22,24,26];
idx_postlobe = [2,5,8,11,14,17,20,23,25,27];
idx_tertlobe = [3,6,9,12,15,18,21];

param_est_ant = x(:,idx_antlobe);
param_est_post = x(:,idx_postlobe);
param_est_tert = x(:,idx_tertlobe);

param_name_ant = y(:,idx_antlobe);
param_name_post = y(:,idx_postlobe);
param_name_tert = y(:,idx_tertlobe);

param_est_ant2 = param_est_ant(:,4:10);
param_est_post2 = param_est_post(:,4:10);
param_est_tert2 = param_est_tert(:,4:5);
param_name_ant2 = param_name_ant(:,4:10);
param_name_post2 = param_name_post(:,4:10);
param_name_tert2 = param_name_tert(:,4:5);

param_est_sorted = horzcat(param_est_ant, param_est_post);
param_est_sorted_tert = horzcat(param_est_ant, param_est_post, param_est_tert, nan(59,3));
param_est_sorted2 = horzcat(param_est_ant, nan(59,3),param_est_post2);
param_est_sorted3 = horzcat(param_est_ant2, param_est_post2);
param_name_sorted = horzcat(param_name_ant, param_name_post);

%% calculate difference matrices for the main parameter estimate matrices

difference_primary_secondary = param_est_sorted_tert(:,1:10) - param_est_sorted_tert(:,11:20);
param_est_sorted_difference = horzcat(param_est_sorted_tert, difference_primary_secondary);
difference_primary_tertiary = param_est_sorted_tert(:,1:7) - param_est_sorted_tert(:,21:27);
difference_secondary_tertiary = param_est_sorted_tert(:,11:17) - param_est_sorted_tert(:,21:27);
param_est_sorted_difference_tert = horzcat(param_est_sorted_difference, difference_primary_tertiary, nan(59,3), difference_secondary_tertiary, nan(59,3));

%% concatenate all columns for each matrix, and create histogram to compare strength of connectivity
% of primary, tertiart and secondary

param_est_primary_column = reshape(param_est_ant,[590,1]);
param_est_secondary_column = reshape(param_est_post,[590,1]);
param_est_tertiary_column = reshape(param_est_tert,[413,1]);

figure(1001);
plot(hist(param_est_primary_column));
hold on
plot(hist(param_est_secondary_column));
hold on 
plot(hist(param_est_tertiary_column));
legend('Primary','Secondary','Tertiary');

%% concatenate difference matrices to allow for histogram/ line graph plotting

difference_prim_sec_column = reshape(difference_primary_secondary,[590,1]);
difference_prim_tert_columm = reshape(difference_primary_tertiary,[413,1]);
difference_sec_tert_column = reshape(difference_secondary_tertiary,[413,1]);

%% create variables for, and output scatter plots for demonstrating 
% correlation, therefore extent of similarity of primary and secondary reps
% overall and in relation to the AP positions

param_ant_column = vertcat(param_est_ant(:,4),param_est_ant(:,5),param_est_ant(:,6),...
    param_est_ant(:,7),param_est_ant(:,8),param_est_ant(:,9),param_est_ant(:,10));
param_post_column = vertcat(param_est_post(:,4),param_est_post(:,5),param_est_post(:,6),...
    param_est_post(:,7),param_est_post(:,8),param_est_post(:,9),param_est_post(:,10));
ant_post_corr = corrcoef([param_ant_column param_post_column]);

p = polyfit(param_ant_column, param_post_column,1);
f = polyval(p,param_ant_column);

%% all parameter estimates -primary, secondary and tertiary combined in to one matrix
AP = {'1','2','3','4','5','6','7','8','9','10'};

figure(1003)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
%figure(110);
imagesc(param_est_sorted_tert);colorbar;...
%     title('All Seeds','Position',[15.5,-1.5],'FontSize',13);...
    yticklabels(seednames);yticks(1:1:59);...
    set(gca,'xticklabel',{[]});...
    xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',6);...
    ax = gca; ax.YAxis.FontSize = 8;...
%     ylabel('Seed region','FontSize',15),...
%     xlabel('AP section to cerebellum connection: Peak voxel (Primary & Secondary)','FontSize',13,...
%     'Position',[15.5,64]);... 
%     text(4,-0.5,'Primary Peak');...
%     text(14,-0.5,'Secondary Peak');...
%     text(24,-0.5,'Tertiary Peak');


%% primary, secondary and tertiary plus difference matrix in one figure
AP = {'1','2','3','4','5','6','7','8','9','10'};

figure(1010)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
%figure(110);
imagesc(param_est_sorted_difference_tert);caxis([-0.5 0.5]);colorbar;...
%     title('All Seeds','Position',[15.5,-1.5],'FontSize',13);...
    yticklabels(seednames);yticks(1:1:59);...
    set(gca,'xticklabel',{[]});...
    xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',5);...
    xline(30.5,'-','Color','k','LineWidth',5);...
    xline(40.5,'-','Color','k','LineWidth',5);...
    ax = gca; ax.YAxis.FontSize = 8;
%     ylabel('Seed region','FontSize',15),...
%     xlabel('AP section to cerebellum connection: Peak voxel (Primary & Secondary)','FontSize',13,...
%     'Position',[15.5,64]);... 
%     text(4,-0.5,'Primary Peak');...
%     text(14,-0.5,'Secondary Peak');...
%     text(24,-0.5,'Tertiary Peak');
%% create index variables and split paramter estimate in rows, to isolate
% seed parameter estimates related to seeds in different subsections of
% frontal cortex

param_est_orbital = param_est_sorted(idx_orbital,:);
param_est_lateral = param_est_sorted(idx_lateral,:);
param_est_medial = param_est_sorted(idx_medial,:);
param_est_oper = param_est_sorted(idx_oper,:);

param_est_orbital_ant = param_est_ant(idx_orbital,:);
param_est_orbital_post = param_est_post(idx_orbital,:);
param_est_orbital_tert = param_est_tert(idx_orbital,:);
param_est_orbital_sorted = horzcat(param_est_orbital_ant,param_est_orbital_post);
param_est_orbital_sorted_tert = horzcat(param_est_orbital_sorted, param_est_orbital_tert, nan(8,3));
% param_est_orbital_tert = horzcat(param_est_orbital_tert,x_orbital);
param_est_lateral_ant = param_est_ant(idx_lateral,:);
param_est_lateral_post = param_est_post(idx_lateral,:);
param_est_lateral_tert = param_est_tert(idx_lateral,:);
param_est_lateral_sorted = horzcat(param_est_lateral_ant,param_est_lateral_post);
param_est_lateral_sorted_tert = horzcat(param_est_lateral_sorted, param_est_lateral_tert, nan(30,3));
% param_est_lateral_tert = horzcat(param_est_lateral_tert,x_lateral);
param_est_medial_ant = param_est_ant(idx_medial,:);
param_est_medial_post = param_est_post(idx_medial,:);
param_est_medial_tert = param_est_tert(idx_medial,:);
param_est_medial_sorted = horzcat(param_est_medial_ant,param_est_medial_post);
param_est_medial_sorted_tert = horzcat(param_est_medial_sorted, param_est_medial_tert, nan(19,3));
% param_est_medial_tert = horzcat(param_est_medial_tert,x_medial);
param_est_oper_ant = param_est_ant(idx_oper,:);
param_est_oper_post = param_est_post(idx_oper,:);
param_est_oper_tert = param_est_tert(idx_oper,:);
param_est_oper_sorted = horzcat(param_est_oper_ant, param_est_oper_post);
param_est_oper_sorted_tert = horzcat(param_est_oper_sorted, param_est_oper_tert, nan(2,3));
% param_est_oper_tert = horzcat(param_est_oper_tert,x_oper);

%% Make variables for medial etc scatters

param_ant_lateral_column = vertcat(param_est_lateral_ant(:,4),param_est_lateral_ant(:,5),...
    param_est_lateral_ant(:,6),param_est_lateral_ant(:,6),param_est_lateral_ant(:,8),...
    param_est_lateral_ant(:,9),param_est_lateral_ant(:,10));
param_post_lateral_column = vertcat(param_est_lateral_post(:,4),param_est_lateral_post(:,5),...
    param_est_lateral_post(:,6),param_est_lateral_post(:,7),param_est_lateral_post(:,8),...
    param_est_lateral_post(:,9),param_est_lateral_post(:,10));
param_ant_medial_column = vertcat(param_est_medial_ant(:,4),param_est_medial_ant(:,5),...
    param_est_medial_ant(:,6),param_est_medial_ant(:,7),param_est_medial_ant(:,8),...
    param_est_medial_ant(:,9),param_est_medial_ant(:,10));
param_post_medial_column = vertcat(param_est_medial_post(:,4),param_est_medial_post(:,5),...
    param_est_medial_post(:,6),param_est_medial_post(:,7),param_est_medial_post(:,8),...
    param_est_medial_post(:,9),param_est_medial_post(:,10));
param_ant_orbital_column = vertcat(param_est_orbital_ant(:,4),param_est_orbital_ant(:,5),...
    param_est_orbital_ant(:,6),param_est_orbital_ant(:,7),param_est_orbital_ant(:,8),...
    param_est_orbital_ant(:,9),param_est_orbital_ant(:,10));
param_post_orbital_column = vertcat(param_est_orbital_post(:,4),param_est_orbital_post(:,5),...
    param_est_orbital_post(:,6),param_est_orbital_post(:,7),param_est_orbital_post(:,8),...
    param_est_orbital_post(:,9),param_est_orbital_post(:,10));
param_ant_oper_column = vertcat(param_est_oper_ant(:,4),param_est_oper_ant(:,5),...
    param_est_oper_ant(:,6),param_est_oper_ant(:,7),param_est_oper_ant(:,8),...
    param_est_oper_ant(:,9),param_est_oper_ant(:,10));
param_post_oper_column = vertcat(param_est_oper_post(:,4),param_est_oper_post(:,5),...
    param_est_oper_post(:,6),param_est_oper_post(:,7),param_est_oper_post(:,8),...
    param_est_oper_post(:,9),param_est_oper_post(:,10));

p_lat = polyfit(param_ant_lateral_column, param_post_lateral_column,1);
f_lat = polyval(p_lat,param_ant_lateral_column);
p_med = polyfit(param_ant_medial_column, param_post_medial_column,1);
f_med = polyval(p_med,param_ant_medial_column);
p_orb = polyfit(param_ant_orbital_column, param_post_orbital_column,1);
f_orb = polyval(p_orb,param_ant_orbital_column);
p_oper = polyfit(param_ant_oper_column, param_post_oper_column,1);
f_oper = polyval(p_oper,param_ant_oper_column);

%% plot PE for peak voxels in cerebellum from lateral structures only
figure(101)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
imagesc(param_est_lateral_sorted_tert);colorbar;...
%     title('Lateral','Position',[15.5,-0.6],'FontSize',13);...
    yticklabels(names_lateral);yticks([1:1:30]);xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',5);...
    set(gca,'xticklabel',{[]});ytickangle(45);
    ax = gca; ax.YAxis.FontSize = 7;...
%     ylabel('Seed region','FontSize',15,'Position',[-2,14.5]),...
%     xlabel({'AP section to cerebellum connection: Peak voxel'; '(Primary & Secondary)'},'FontSize',10,...
%     'Position',[15.5,31.7]);... 
%     text(2.5,-0.2,'Primary Peak');
%     text(12,-0.2,'Secondary Peak');
%     text(22.5,-0.2,'Tertiary Peak');

%% plot PE for peak voxels in cerebellum from medial structures only
figure(102)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
imagesc(param_est_medial_sorted_tert);colorbar;...
% title('Medial','Position',[15.5,-0.25],'FontSize',13);
    yticklabels(names_medial);yticks([1:1:19]);xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',5);...
    set(gca,'xticklabel',{[]});ytickangle(45);
    ax = gca; ax.YAxis.FontSize = 7;...
%     ylabel('Seed region','FontSize',15),...
%     xlabel({'AP section to cerebellum connection: Peak voxel'; '(Primary & Secondary)'},'FontSize',10,...
%     'Position',[15.5,20.5]);... 
%     text(3,0.1,'Primary Peak');
%     text(13,0.1,'Secondary Peak');
%     text(23,0.1,'Tertiary Peak');
% nexttile

%% plot PE for peak voxels in cerebellum from orbital structures only
figure(103)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
imagesc(param_est_orbital_sorted_tert);colorbar;...
%     title('Orbital','Position',[15.5,0.1],'FontSize',13);...
    yticklabels(names_orbital);yticks([1:1:8]);
    xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',5);...
    set(gca,'xticklabel',{[]});ytickangle(45);...
%     ylabel('Seed region','FontSize',15),...
%     xlabel({'AP section to cerebellum connection: Peak voxel'; '(Primary & Secondary)'},'FontSize',10,...
%     'Position',[15.5,8.9]);... 
%     text(3.5,0.3,'Primary Peak');
%     text(13.5,0.3,'Secondary Peak');
%     text(23.5,0.3,'Tertiary Peak');
% nexttile

%% plot PE for peak voxels in cerebellum from opercular structures only
figure(104)
% tiledlayout(1,2)
colormap('Jet');
% nexttile
imagesc(param_est_oper_sorted_tert);colorbar;
%     title('Opercular','Position',[15.5,0.42],'FontSize',13);...
    yticklabels(names_oper);yticks([1:1:2]);xline(10.5,'-','Color','k','LineWidth',5);...
    xline(20.5,'-','Color','k','LineWidth',5);...
    set(gca,'xticklabel',{[]});ytickangle(45);...
%     ylabel('Seed region','FontSize',15,'Position',[-1.2,1.5]),...
%     xlabel({'AP section to cerebellum connection: Peak voxel'; '(Primary & Secondary)'},'FontSize',10,...
%     'Position',[15.5,2.6]);... 
%     text(3.5,0.4575,'Primary Peak');
%     text(1,0.4575,'Secondary Peak');
%     text(23.5,0.4575,'Tertiary Peak');
% nexttile

%% Lateral Scatter
% nexttile
figure(705)
% title('Lateral Scatter');
grid on
hold on
scatter(param_ant_lateral_column, param_post_lateral_column,sz,col,'filled');
axis('tight');
hold on
% xlabel({'Primary peak voxel to frontal seed';'(parameter estimate)'});
% ylabel({'Secondary peak voxel to frontal seed';'(parameter estimate)'});
plot(param_ant_lateral_column,f_lat,'k-.');
% legend({'AP4','AP5','AP6','AP7','AP8','AP9','AP10'},'Location','northwest',...
%     'NumColumns',2);

%% medial scatter
figure(706)
% title('Medial Scatter');
grid on
hold on
scatter(param_ant_medial_column, param_post_medial_column,sz,col,'filled');
axis('tight');
hold on
% xlabel({'Primary peak voxel to frontal seed';'(parameter estimate)'});
% ylabel({'Secondary peak voxel to frontal seed';'(parameter estimate)'});
plot(param_ant_medial_column,f_med,'k-.');

%% orbital scatter
figure(707)
% title('Orbital Scatter');
grid on
hold on
scatter(param_ant_orbital_column, param_post_orbital_column,sz,col,'filled');
axis('tight');
hold on
% xlabel({'Primary peak voxel to frontal seed';'(parameter estimate)'});
% ylabel({'Secondary peak voxel to frontal seed';'(parameter estimate)'});
plot(param_ant_orbital_column,f_orb,'k-');

%% opercular scatter
figure(708)
% title('Operculum Scatter');
grid on
hold on
scatter(param_ant_oper_column, param_post_oper_column,sz,col,'filled');
axis('tight');
hold on
% xlabel({'Primary peak voxel to frontal seed';'(parameter estimate)'});
% ylabel({'Secondary peak voxel to frontal seed';'(parameter estimate)'});
plot(param_ant_oper_column,f_oper,'k-');

