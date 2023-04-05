

%% load catchment stats
excel_file_path = 'C:\onedrive\Projects\Coastal_catchments\data_for_stat_plots.xlsx'; %from python scripts
raw_table_SLRonly = readtable(excel_file_path, 'ReadRowNames', true, 'Sheet', 'Sheet1');

%% 
% total catchment area
perc_catch_area_85833 = raw_table_SLRonly(2:8, 1);
perc_catch_area_85833 = perc_catch_area_85833{:,:};
perc_catch_area_85500 = raw_table_SLRonly(10:16, 1);
perc_catch_area_85500 = perc_catch_area_85500{:,:};
perc_catch_area_85166 = raw_table_SLRonly(18:24, 1);
perc_catch_area_85166 = perc_catch_area_85166{:,:};

perc_catch_area_45833 = raw_table_SLRonly(26:32, 1);
perc_catch_area_45833 = perc_catch_area_45833{:,:};
perc_catch_area_45500 = raw_table_SLRonly(34:40, 1);
perc_catch_area_45500 = perc_catch_area_45500{:,:};
perc_catch_area_45166 = raw_table_SLRonly(42:48, 1);
perc_catch_area_45166 = perc_catch_area_45166{:,:};

% change in area
total_catch_area_85833 = raw_table_SLRonly(2:8, 2);
total_catch_area_85833 = total_catch_area_85833{:,:};
total_catch_area_85500 = raw_table_SLRonly(10:16, 2);
total_catch_area_85500 = total_catch_area_85500{:,:};
total_catch_area_85166 = raw_table_SLRonly(18:24, 2);
total_catch_area_85166 = total_catch_area_85166{:,:};

total_catch_area_45833 = raw_table_SLRonly(26:32, 2);
total_catch_area_45833 = total_catch_area_45833{:,:};
total_catch_area_45500 = raw_table_SLRonly(34:40, 2);
total_catch_area_45500 = total_catch_area_45500{:,:};
total_catch_area_45166 = raw_table_SLRonly(42:48, 2);
total_catch_area_45166 = total_catch_area_45166{:,:};

% median catchment area
median_catch_area_85833 = raw_table_SLRonly(2:8, 3);
median_catch_area_85833 = median_catch_area_85833{:,:};
median_catch_area_85500 = raw_table_SLRonly(10:16, 3);
median_catch_area_85500 = median_catch_area_85500{:,:};
median_catch_area_85166 = raw_table_SLRonly(18:24, 3);
median_catch_area_85166 = median_catch_area_85166{:,:};

median_catch_area_45833 = raw_table_SLRonly(26:32, 3);
median_catch_area_45833 = median_catch_area_45833{:,:};
median_catch_area_45500 = raw_table_SLRonly(34:40, 3);
median_catch_area_45500 = median_catch_area_45500{:,:};
median_catch_area_45166 = raw_table_SLRonly(42:48, 3);
median_catch_area_45166 = median_catch_area_45166{:,:};

% mean catchment area
mean_catch_area_85833 = raw_table_SLRonly(2:8, 4);
mean_catch_area_85833 = mean_catch_area_85833{:,:};
mean_catch_area_85500 = raw_table_SLRonly(10:16, 4);
mean_catch_area_85500 = mean_catch_area_85500{:,:};
mean_catch_area_85166 = raw_table_SLRonly(18:24, 4);
mean_catch_area_85166 = mean_catch_area_85166{:,:};

mean_catch_area_45833 = raw_table_SLRonly(26:32, 4);
mean_catch_area_45833 = mean_catch_area_45833{:,:};
mean_catch_area_45500 = raw_table_SLRonly(34:40, 4);
mean_catch_area_45500 = mean_catch_area_45500{:,:};
mean_catch_area_45166 = raw_table_SLRonly(42:48, 4);
mean_catch_area_45166 = mean_catch_area_45166{:,:};

% number of catchments
number_of_catchments_85833 = raw_table_SLRonly(2:8, 5);
number_of_catchments_85833 = number_of_catchments_85833{:,:};
number_of_catchments_85500 = raw_table_SLRonly(10:16, 5);
number_of_catchments_85500 = number_of_catchments_85500{:,:};
number_of_catchments_85166 = raw_table_SLRonly(18:24, 5);
number_of_catchments_85166 = number_of_catchments_85166{:,:};

number_of_catchments_45833 = raw_table_SLRonly(26:32, 5);
number_of_catchments_45833 = number_of_catchments_45833{:,:};
number_of_catchments_45500 = raw_table_SLRonly(34:40, 5);
number_of_catchments_45500 = number_of_catchments_45500{:,:};
number_of_catchments_45166 = raw_table_SLRonly(42:48, 5);
number_of_catchments_45166 = number_of_catchments_45166{:,:};

% runoff intercept area
runoff_intercept_area_85833 = raw_table_SLRonly(2:8, 6);
runoff_intercept_area_85833 = runoff_intercept_area_85833{:,:};
runoff_intercept_area_85500 = raw_table_SLRonly(10:16, 6);
runoff_intercept_area_85500 = runoff_intercept_area_85500{:,:};
runoff_intercept_area_85166 = raw_table_SLRonly(18:24, 6);
runoff_intercept_area_85166 = runoff_intercept_area_85166{:,:};

runoff_intercept_area_45833 = raw_table_SLRonly(26:32, 6);
runoff_intercept_area_45833 = runoff_intercept_area_45833{:,:};
runoff_intercept_area_45500 = raw_table_SLRonly(34:40, 6);
runoff_intercept_area_45500 = runoff_intercept_area_45500{:,:};
runoff_intercept_area_45166 = raw_table_SLRonly(42:48, 6);
runoff_intercept_area_45166 = runoff_intercept_area_45166{:,:};

% catchment submerged area
submerged_area_85833 = raw_table_SLRonly(2:8, 7);
submerged_area_85833 = submerged_area_85833{:,:};
submerged_area_85500 = raw_table_SLRonly(10:16, 7);
submerged_area_85500 = submerged_area_85500{:,:};
submerged_area_85166 = raw_table_SLRonly(18:24, 7);
submerged_area_85166 = submerged_area_85166{:,:};

submerged_area_45833 = raw_table_SLRonly(26:32, 7);
submerged_area_45833 = submerged_area_45833{:,:};
submerged_area_45500 = raw_table_SLRonly(34:40, 7);
submerged_area_45500 = submerged_area_45500{:,:};
submerged_area_45166 = raw_table_SLRonly(42:48, 7);
submerged_area_45166 = submerged_area_45166{:,:};

%%
if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig,'color','w'); set(fig, 'units', 'centimeters', 'position', [-25, 15, 18, 10]); %x0,y0,width,height
plot(submerged_area_85833, 'o--', 'Color', [.2 .2 .8]); hold on;
plot(submerged_area_85500, 'o-', 'Color', [.2 .2 .8]); 
plot(submerged_area_85166, 'o:', 'Color', [.2 .2 .8]); 
plot(submerged_area_45833, 'o--', 'Color', [.9 .3 .2]); 
plot(submerged_area_45500, 'o-', 'Color', [.9 .3 .2]);  
plot(submerged_area_45166, 'o:', 'Color', [.9 .3 .2]);  
% xlim([1 7]);
% ylim([1320000 1445000]);
% xlabel('Distance [m]');
ylabel('Submerged area [km^2]');
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);

%%

% linewidth = 1.5;
markersize = 4;

subplotRows = 4;
subplotCol = 2;
vertSpace = 0.06;
horzSpace = 0.1;
MarginLeft = 0.1;
MarginRight = 0.025; 
MarginTop = 0.04;
MarginBottom = 0.05; 

if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig, 'units', 'centimeters', 'position', [-25, 10, 15.5, 18]); %x0,y0,width,height  was [-25, 10, 15.5, 14] before adding 6th panel

%-----------total catchment area-----------
subaxis(subplotRows,subplotCol,1,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(total_catch_area_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(total_catch_area_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(total_catch_area_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(total_catch_area_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(total_catch_area_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
h = plot(total_catch_area_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([1350000 1500000]);
ylabel('Total area [km^2]');
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box
yh = get(gca,'ylabel'); 
p = get(yh,'position'); 
p(1) = p(1)-.06;       
                      
set(yh,'position',p);  
%---------------------------
%set panel label
t = title('a)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.06 .84 h1(3)])


%-----------percent change in catchment area-----------
subaxis(subplotRows,subplotCol,2,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(perc_catch_area_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(perc_catch_area_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(perc_catch_area_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(perc_catch_area_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(perc_catch_area_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
h = plot(perc_catch_area_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([90 100]);
ylabel('Change in area [%]');
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box
% yh = get(gca,'ylabel'); 
% p = get(yh,'position'); 
% p(1) = p(1)-.06;        
%                       
% set(yh,'position',p);   
%---------------------------
%set panel label
t = title('b)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.05 .04 h1(3)])

%-----------submerged catchment area-----------
subaxis(subplotRows,subplotCol,3,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(submerged_area_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(submerged_area_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(submerged_area_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(submerged_area_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(submerged_area_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
h = plot(submerged_area_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([0 230000]);
ylabel({'Submerged'; 'catchment area [km^2]'});
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box
% yh = get(gca,'ylabel');
% p = get(yh,'position'); 
% p(1) = p(1)-.20;       
%                        
% set(yh,'position',p);  
%-----set exponent on y axis to zero-----
ay = ancestor(h, 'axes');
ay.YAxis.Exponent = 5;
ytickformat('%.1f');
%---------------------------
%set panel label
t = title('c)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.06 .84 h1(3)])

%-----------runoff intercept area-----------
subaxis(subplotRows,subplotCol,4,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(runoff_intercept_area_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(runoff_intercept_area_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(runoff_intercept_area_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(runoff_intercept_area_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(runoff_intercept_area_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
h = plot(runoff_intercept_area_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([0 230000]);
ylabel({'Runoff', 'intercept area [km^2]'});
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box
% yh = get(gca,'ylabel');
% p = get(yh,'position');
% p(1) = p(1)-.20;        
%                       
% set(yh,'position',p);  
%-----set exponent on y axis to zero-----
ay = ancestor(h, 'axes');
ay.YAxis.Exponent = 5;
ytickformat('%.1f');
%---------------------------
%set panel label
t = title('d)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.06 .84 h1(3)])

%-----------median catchment area-----------
subaxis(subplotRows,subplotCol,5,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(median_catch_area_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(median_catch_area_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(median_catch_area_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(median_catch_area_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(median_catch_area_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
plot(median_catch_area_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([4 8]);
ylabel('Median area [km^2]');
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box-----
yh = get(gca,'ylabel'); 
p = get(yh,'position');
p(1) = p(1)-.2;       
                       
set(yh,'position',p);  
%------------------------------
%set panel label
t = title('e)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.06 .84 h1(3)])

%-----------mean catchment area-----------
subaxis(subplotRows,subplotCol,6,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(mean_catch_area_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(mean_catch_area_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(mean_catch_area_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(mean_catch_area_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(mean_catch_area_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
plot(mean_catch_area_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([20 26]);
ylabel({'Mean area [km^2]'});
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box-----
yh = get(gca,'ylabel');
p = get(yh,'position'); 
p(1) = p(1)-.1;        
                       
set(yh,'position',p);  
xlabel('Year');
%------------------------------
%set panel label
t = title('f)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.06 .84 h1(3)])

%-----------number of catchments-----------
subaxis(subplotRows,subplotCol,7,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(number_of_catchments_85833, 'o--', 'Color', [.2 .2 .8], 'MarkerSize', markersize); hold on;
plot(number_of_catchments_85500, 'o-', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(number_of_catchments_85166, 'o:', 'Color', [.2 .2 .8], 'MarkerSize', markersize); 
plot(number_of_catchments_45833, 'o--', 'Color', [.9 .3 .2], 'MarkerSize', markersize); 
plot(number_of_catchments_45500, 'o-', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
h = plot(number_of_catchments_45166, 'o:', 'Color', [.9 .3 .2], 'MarkerSize', markersize);  
xlim([1 7]);
ylim([54000 63000]);
ylabel('Number of catchments');
x_labels = {'2000'; '2020'; '2040'; '2060'; '2080'; '2100'; '2120'};
set(gca,'xtick', [1:7], 'xticklabel', x_labels);
%set y axis distance from box
% yh = get(gca,'ylabel'); 
% p = get(yh,'position'); 
% p(1) = p(1)-.20;         
%                       
% set(yh,'position',p);  
%-----set exponent on y axis to zero-----
ay = ancestor(h, 'axes');
ay.YAxis.Exponent = 0;
ytickformat('%.0f');
xlabel('Year');
%---------------------------------------
%set panel label
t = title('g)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.06 .84 h1(3)])


Lgnd = legend('RCP 8.5 83%', 'RCP 8.5 50%', 'RCP 8.5 17%', 'RCP 4.5 83%', 'RCP 4.5 50%', 'RCP 4.5 17%', 'Location','eastoutside', 'NumColumns', 1, 'fontsize', 10);
Lgnd.Position(1) = .675; %x position
Lgnd.Position(2) = .065; %y position

% exportgraphics(fig,'C:\onedrive\Figures\Figure2_catchment_stats.jpg','Resolution',300);
% exportgraphics(fig,'C:\onedrive\Figures\Figure2_catchment_stats.eps','Resolution',300);

