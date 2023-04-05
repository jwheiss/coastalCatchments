
%% load data
excel_file_path = 'C:\onedrive\Projects\Coastal_catchments\catchment_with_latitude.xlsx'; %from python script calculate_latitude_catchment_stats.py
raw_table = readtable(excel_file_path, 'ReadRowNames', false, 'Sheet', 'Sheet1');

%%
latitude = raw_table(:, 1);
latitude = latitude{:,:};

%base case
basecase = raw_table(:, 2);
basecase = basecase{:,:};

%-----------area-----------
%2020
catchments_2040 = raw_table(:, 3);
catchments_2040 = catchments_2040{:,:};
%2080
catchments_2080 = raw_table(:, 4);
catchments_2080 = catchments_2080{:,:};
%2120
catchments_2120 = raw_table(:, 5);
catchments_2120 = catchments_2120{:,:};

%2020 change
catchments_change_2040 = raw_table(:, 6);
catchments_change_2040 = catchments_change_2040{:,:};
%2080 change
catchments_change_2080 = raw_table(:, 7);
catchments_change_2080 = catchments_change_2080{:,:};
%2120 change
catchments_change_2120 = raw_table(:, 8);
catchments_change_2120 = catchments_change_2120{:,:};

%-----------number of catchments-----------
%base case
basecase_num_catch = raw_table(:, 9);
basecase_num_catch = basecase_num_catch{:,:};

%2020
catchments_2040_num_catch = raw_table(:, 10);
catchments_2040_num_catch = catchments_2040_num_catch{:,:};
%2080
catchments_2080_num_catch = raw_table(:, 11);
catchments_2080_num_catch = catchments_2080_num_catch{:,:};
%2120
catchments_2120_num_catch = raw_table(:, 12);
catchments_2120_num_catch = catchments_2120_num_catch{:,:};

%2020 change
catchments_2040_num_catch_change = raw_table(:, 13);
catchments_2040_num_catch_change = catchments_2040_num_catch_change{:,:};
%2080 change
catchments_2080_num_catch_change = raw_table(:, 14);
catchments_2080_num_catch_change = catchments_2080_num_catch_change{:,:};
%2120 change
catchments_2120_num_catch_change = raw_table(:, 15);
catchments_2120_num_catch_change = catchments_2120_num_catch_change{:,:};

%-----------submerged catchment area-----------
%2020
catchments_submerged_2040 = raw_table(:, 22);
catchments_submerged_2040 = catchments_submerged_2040{:,:};
%2080
catchments_submerged_2080 = raw_table(:, 23);
catchments_submerged_2080 = catchments_submerged_2080{:,:};
%2120
catchments_submerged_2120 = raw_table(:, 24);
catchments_submerged_2120 = catchments_submerged_2120{:,:};

%-----------runoff intercept area-----------
%2020
catchments_intercept_change_2040 = raw_table(:, 25);
catchments_intercept_change_2040 = catchments_intercept_change_2040{:,:};
%2080
catchments_intercept_change_2080 = raw_table(:, 26);
catchments_intercept_change_2080 = catchments_intercept_change_2080{:,:};
%2120
catchments_intercept_change_2120 = raw_table(:, 27);
catchments_intercept_change_2120 = catchments_intercept_change_2120{:,:};


%%
subplotRows = 3;
subplotCol = 1;
vertSpace = 0.03;
horzSpace = 0.05;
MarginLeft = 0.08;
MarginRight = 0.02; 
MarginTop = 0.035;
MarginBottom = 0.07;
% close all

color1 = '#EDAE49';
color2 = '#D1495B';
color3 = '#00798C';


if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig, 'units', 'centimeters', 'position', [-25, 10, 15, 15]); 

%total area
subaxis(subplotRows,subplotCol,1,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(latitude, (basecase), '-', 'Color', [0 0 0]); hold on;
plot(latitude, (catchments_2040), '-', 'Color', color1); 
plot(latitude, (catchments_2080), '-', 'Color', color2); 
plot(latitude, (catchments_2120), '-', 'Color', color3); 
% plot([0 0], [-60 60], '--', 'Color', [.5 .5 .5]);
% xlim([-25 80]);
xlim([-60 60]);
set(gca,'XTickLabel',[]);
ylabel('Catchment area [km^2]');
%set panel label
t = title('a)', 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.05 .04 h1(1)]);
%legend
Lgnd = legend('Present-day', '2040', '2080', '2120', 'Location', 'northwest', 'NumColumns', 1, 'FontSize', 9);
Lgnd.Position(1) = Lgnd.Position(1)-0.014; %x position
Lgnd.Position(2) = Lgnd.Position(2)+0.008; %x position






%-------------submerged catchment area-----------------
subaxis(subplotRows,subplotCol,2,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
h1 = plot(latitude, (catchments_submerged_2040), ':', 'Color', color1, 'LineWidth', 1); hold on;
h2 = plot(latitude, (catchments_submerged_2080), ':', 'Color', color2, 'LineWidth', 1); 
h3 = plot(latitude, (catchments_submerged_2120), ':', 'Color', color3, 'LineWidth', 1);
% xlim([-25 80]);
xlim([-60 60]);
set(gca,'XTickLabel',[]);
ylabel('Catchment area [km^2]');


%-------------runoff intercept area-----------------
subaxis(subplotRows,subplotCol,2,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
h4 = plot(latitude, (catchments_intercept_change_2040), '-.', 'Color', color1, 'LineWidth', 1); hold on;
h5 = plot(latitude, (catchments_intercept_change_2080), '-.', 'Color', color2, 'LineWidth', 1);
h6 = plot(latitude, (catchments_intercept_change_2120), '-.', 'Color', color3, 'LineWidth', 1);
plot([-60 60], [0 0], '-', 'Color', [0 0 0], 'LineWidth', 0.5);
xlim([-60 60]);
ylim([-37 37]); 
set(gca,'XTickLabel',[]);
ylabel('Change in area [%]');
%legend

Lgnd = legend([h1 h2 h3 h4 h5 h6 ],'2040 SCA', '2080 SCA', '2120 SCA', '2040 RIA', '2080 RIA', '2120 RIA', 'Location', 'southwest', 'NumColumns', 2, 'FontSize', 9);
Lgnd.Position(1) = Lgnd.Position(1)-0.014; %x position
Lgnd.Position(2) = Lgnd.Position(2)-0.01; %y position


%----------net percent change-------------
subaxis(subplotRows,subplotCol,3,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 
plot(latitude, (catchments_change_2040), '-', 'Color', color1, 'LineWidth', 1); hold on;
plot(latitude, (catchments_change_2080), '-', 'Color', color2, 'LineWidth', 1);
plot(latitude, (catchments_change_2120), '-', 'Color', color3, 'LineWidth', 1);
plot([-60 60], [0 0], '-', 'Color', [0 0 0], 'LineWidth', 0.5);
xlim([-60 60]);
ylim([-20 8]); 
xlabel('Latitude ');
ylabel('Net change in area [%]');
%legend
Lgnd = legend('2040', '2080', '2120', 'Location', 'southwest', 'NumColumns', 3, 'FontSize', 9);
Lgnd.Position(1) = Lgnd.Position(1)-0.014; %x position
Lgnd.Position(2) = Lgnd.Position(2)-0.008; %y position


% exportgraphics(fig,'C:\onedrive\Figures\Figure3_latitude.jpg','Resolution',300);
% exportgraphics(fig,'C:\onedrive\Figures\Figure3_latitude.eps','Resolution',300);
