data=xlsread('多步模型.xlsx');
omega=data(:,3);
totalTime=data(:,1)/45;
totalFlightDistance=data(:,2);
% Y轴颜色设置
fig=figure;
left_color=[0.8 0.41 0.11];
right_color=[0.4 0.35 0.8];
set(fig,'defaultAxesColorOrder',[left_color;right_color]);
% 绘制
yyaxis left
plot(omega,totalTime,'color',[0.8 0.41 0.11],'Linewidth',1.2);
hold on;
scatter(omega,totalTime,50,[0.8 0.41 0.11],'s','filled');
yyaxis right
plot(omega,totalFlightDistance,'color',[0.4 0.35 0.8],'Linewidth',1.2);
hold on;
scatter(omega,totalFlightDistance,80,[0.4 0.35 0.8],'p','filled');