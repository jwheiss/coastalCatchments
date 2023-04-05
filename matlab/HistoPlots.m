%first load catchmentareas.mat
load CatchmentAreas.mat

%% make edger linear

root=0.1;
mult=1.5;
edger=root;
for i = 2:40
    edger(i)=edger(i-1)*mult;
end

%% generate histos for 4.5
if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig, 'units', 'centimeters', 'position', [-25, 10, 15, 17]); %x0,y0,width,height

subplotRows = 4;
subplotCol = 2;
vertSpace = 0.08;
horzSpace = 0.1;
MarginLeft = 0.088;
MarginRight = 0.03; 
MarginTop = 0.02;
MarginBottom = 0.08;

num_vars=7; %7 plots
labels = ["a)" "b)" "c)" "d)" "e)" "f)" "g)"];

histo=zeros(length(edger)-1,num_vars);
for i = 1:num_vars
    areas=table2array(catchmentareas(:,i));
%     subplot(4,2,i)
    subaxis(subplotRows,subplotCol,i,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 

    h=histogram(areas,edger);
    histo(:,i)=h.Values;
    
    set(gca, 'XScale', 'log')
    
    med(i)=nanmedian(table2array(catchmentareas(:,i)));
    avg(i)=nanmean(table2array(catchmentareas(:,i)));

xlabel('Area [km^2]', 'FontSize', 10);
ylabel('Count', 'FontSize', 10);
ylim([0 6000]);

%set panel label
t = title(labels(i), 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.05 .81 h1(3)])

end




%% generate histos for 8.5
if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig, 'units', 'centimeters', 'position', [-25, 10, 15, 17]); %x0,y0,width,height

subplotRows = 4;
subplotCol = 2;
vertSpace = 0.08;
horzSpace = 0.1;
MarginLeft = 0.088;
MarginRight = 0.03; 
MarginTop = 0.02;
MarginBottom = 0.08;

num_vars=7; %7 plots
labels = ["a)" "b)" "c)" "d)" "e)" "f)" "g)"];

histo=zeros(length(edger)-1,num_vars);
for i = 1:num_vars
    if i == 1
    column_counter = i;
    areas=table2array(catchmentareas(:,column_counter));
    subaxis(subplotRows,subplotCol,i,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 

    h=histogram(areas,edger);
    histo(:,i)=h.Values;
    
    set(gca, 'XScale', 'log');
    
    med(i)=nanmedian(table2array(catchmentareas(:,i)));
    avg(i)=nanmean(table2array(catchmentareas(:,i)));

    xlabel('Area [km^2]', 'FontSize', 10);
    ylabel('Count', 'FontSize', 10);
    
    %set panel label
    t = title(labels(i), 'fontweight','normal');
    set(t, 'units', 'normalized');
    h1 = get(t, 'position');
    set(t, 'position', [0.05 .81 h1(3)]);
    else
        
    column_counter = i+6;

    areas=table2array(catchmentareas(:,column_counter));
%     subplot(4,2,i)
    subaxis(subplotRows,subplotCol,i,'SpacingVert',vertSpace,'SpacingHorizontal',horzSpace,'MarginLeft', MarginLeft, 'MarginRight',MarginRight, 'MarginTop', MarginTop, 'MarginBottom', MarginBottom); 

    h=histogram(areas,edger);
    histo(:,i)=h.Values;
    
    set(gca, 'XScale', 'log')
    
    med(i)=nanmedian(table2array(catchmentareas(:,i)));
    avg(i)=nanmean(table2array(catchmentareas(:,i)));

xlabel('Area [km^2]', 'FontSize', 10);
ylabel('Count', 'FontSize', 10);
ylim([0 6000]);

%set panel label
t = title(labels(i), 'fontweight','normal');
set(t, 'units', 'normalized');
h1 = get(t, 'position');
set(t, 'position', [0.05 .81 h1(3)])

    end
end





%% Plot histogram line
%first generate histos for all scenarios 
figure(001)
num_vars=size(catchmentareas,2);
histo=zeros(length(edger)-1,num_vars);
for i = 1:num_vars
    areas=table2array(catchmentareas(:,i));
    subplot(5,3,i)
    h=histogram(areas,edger);
    histo(:,i)=h.Values;
    set(gca, 'XScale', 'log')
    med(i)=nanmedian(table2array(catchmentareas(:,i)));
    avg(i)=nanmean(table2array(catchmentareas(:,i)));
end
close(figure(001))

if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig, 'units', 'centimeters', 'position', [-25, 10, 19, 15]); %x0,y0,width,height

subplot(2,1,1)
plot((edger(1:end-1)+edger(2:end))/2,histo(:,[1:7]),'.-');hold on
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
% legend(catchmentareas.Properties.VariableNames{[1,8:13]})%,'location','south','orientation','horizontal')
legend('2000', '2020', '2040', '2060', '2080', '2100', '2120')%,'location','south','orientation','horizontal')
% for i=1:length(edger)
%     plot([edger(i),edger(i)],[1,6000],':k','HandleVisibility','off')
% end

ylabel("count")
title('Histogram of catchment sizes')
subtitle('RCP 45')
xlim([edger(1) edger(28)])

subplot(2,1,2)
temp=histo(:,[1,8:13]);
plot((edger(1:end-1)+edger(2:end))/2,temp,'.-');hold on
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
% legend(catchmentareas.Properties.VariableNames{[1,8:13]})%,'location','south','orientation','horizontal')
legend('2000', '2020', '2040', '2060', '2080', '2100', '2120');
% for i=1:length(edger)
%     plot([edger(i),edger(i)],[1,6000],':k','HandleVisibility','off')
% end
xlabel("bin limits (km^2)")
ylabel("count")
subtitle('RCP 85')
xlim([edger(1) edger(28)])

exportgraphics(fig,'C:\onedrive\Figures\Figure_area_hist.jpg','Resolution',300);
exportgraphics(fig,'C:\onedrive\Figures\Figure_area_hist.eps','Resolution',300);



%% Plot avg and median
figure(003)

subplot(2,1,1)
title('median catchment size')
plot(med(1:7),'.-');hold on
plot(med([1,8:end]),'.-')
legend({'RCP45','RCP85'})
subplot(2,1,2)
title('mean catchment size')
plot(avg(1:7),'.-');hold on
plot(avg([1,8:end]),'.-')
legend({'RCP45','RCP85'})



%% Area Weighted (by catchment size) Histograms
if exist('FN','var') == 1; FN = FN+1; figure(FN); else FN=1; figure(FN); end
fig = figure(FN); set(fig, 'units', 'centimeters', 'position', [-25, 10, 19, 15]); %x0,y0,width,height

area_accum=zeros(length(edger),num_vars);
area_count=area_accum;
for i = 1:num_vars
    temp=table2array(catchmentareas(:,i));
    for k=2:length(edger)
        area_accum(k,i)=sum(temp(temp>edger(k-1)&temp<edger(k)));
        area_count(k,i)=sum(temp<edger(k));
    end
end

subplot(2,1,1)
temp=area_accum(2:end,[1:7]);
plot((edger(1:end-1)+edger(2:end))/2,temp,'.-');hold on
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
%legend(catchmentareas.Properties.VariableNames,'Location','southeast','Orientation','horizontal')
% legend(catchmentareas.Properties.VariableNames,'Location','northeast')
legend('2000', '2020', '2040', '2060', '2080', '2100', '2120');
% for i=1:length(edger)
%     %plot([edger(i),edger(i)],[10^2 10^6],':k','HandleVisibility','off')
%     plot([edger(i),edger(i)],[0 .2*10^6],':k','HandleVisibility','off')
% end
ylabel("sum area (km^2)")
title('Area-Weighted Histogram of Catchment Size')
subtitle('RCP 45')
xlim([.1 10^4])


subplot(2,1,2)
temp=area_accum(2:end,[1,8:13]);
plot((edger(1:end-1)+edger(2:end))/2,temp,'.-');hold on
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
%legend(catchmentareas.Properties.VariableNames,'Location','southeast','Orientation','horizontal')
% legend(catchmentareas.Properties.VariableNames{[1,8:13]},'Location','northeast');
legend('2000', '2020', '2040', '2060', '2080', '2100', '2120');
% for i=1:length(edger)
%     %plot([edger(i),edger(i)],[10^2 10^6],':k','HandleVisibility','off')
%     plot([edger(i),edger(i)],[0 .2*10^6],':k','HandleVisibility','off')
% end
xlabel("bin limits (km^2)")
ylabel("sum area (km^2)")
subtitle('RCP 85')
xlim([.1 10^4])

exportgraphics(fig,'C:\onedrive\Figures\publication\20xx coastal catchments\FigureS3_area_hist_weighted.jpg','Resolution',300);
exportgraphics(fig,'C:\onedrive\Figures\publication\20xx coastal catchments\FigureS3_area_hist_weighted.eps','Resolution',300);



%% CDFs Weighted (by catchment size)

figure(005)

subplot(2,1,1)
plot((edger(1:end-1)+edger(2:end))/2,cumsum(area_accum(2:end,[1:7]))./sum(area_accum(2:end,[1:7])),'.-');hold on
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
ylim([0 1])
xlim([edger(1) edger(28)])
legend(catchmentareas.Properties.VariableNames)
for i=1:length(edger)
    plot([edger(i),edger(i)],[0 max(area_accum(:))],':k','HandleVisibility','off')
end

ylabel("pCDF area")
title('Weighted pCDF of catchment areas')
subtitle('RCP 45')



subplot(2,1,2)
temp=area_accum(2:end,[1,8:13]);
plot((edger(1:end-1)+edger(2:end))/2,cumsum(temp)./sum(temp),'.-');hold on
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
ylim([0 1])
xlim([edger(1) edger(28)])
legend(catchmentareas.Properties.VariableNames{[1,8:13]})
for i=1:length(edger)
    plot([edger(i),edger(i)],[0 max(area_accum(:))],':k','HandleVisibility','off')
end
xlabel("bin limits (km^2)")
ylabel("pCDF area")
subtitle('RCP 85')
