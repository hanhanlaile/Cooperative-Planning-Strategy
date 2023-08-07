%% 参数初始化
data=xlsread('最优轨迹点.xlsx');
X=data(:,1);
Y=data(:,2);
Z=data(:,3);
data1=csvread('障碍地形.csv');
scatter(data1(:,1),data1(:,2),3,'b','filled');
hold on;
axis([0 4403 0 2644]);
% x0=3910;y0=484;z0=30;
% x2=3910;y2=484;z2=30;
x0=3910;y0=484;z0=30;
x2=3910;y2=484;z2=30;
x1=3750;y1=537;z1=50;
ce=1;
cl=0;
interval=3;
xi=100;
zi=25;
xi2=100;
%存储通视位置
allInformation=[];
totalTime=[];
totalRelayDistance=[];
% for omega=3.8:0.1:3.9
Losx=[];
Losy=[];
Losz=[];
% Losx=[Losx;x2];
% Losy=[Losy;y2];
% Losz=[Losz;z2];
xm=[];
ym=[];
zm=[];
los1=[];
los2=[];
Distence=[];
Dis2=[];
DetaK=[];
Los_=[];
Time_=[];
SpeedRelayxy=[];
SpeedRelayz=[];
SpeedRelayxyz=[];
relayProcessPositionX=[];
relayProcessPositionY=[];
relayProcessPositionZ=[];
radius_missionUAV_X=[];
radius_missionUAV_Y=[];
radius_missionUAV_X=[radius_missionUAV_X;X(1)];
radius_missionUAV_Y=[radius_missionUAV_Y;Y(1)];
%粒子群参数
sizepop=20;%初始种群个数
dim=5;%空间维数
ger=30;%最大迭代次数
c_1=0.7;%惯性权重
c_2=2;%自我学习因子
c_3=2;%群体学习因子
omega=0.1;
m=1;
count=0;%计数器，统计k>199的次数，超过2跳出循环
% disRelay=[];
sumRelayDistance=0;
cd=100;
R=20;
%% 计算所有通视位置
t3=clock;
while m < 200
    m=m+1;
    X0=[x2;y2;z2];
    count=count+1;
    k=count;
    if count>length(X)
        count=length(X);
        k=count;
    end
    X00=[X(k);Y(k)];
    XeMax=x2+xi;
    XeMin=x2-xi;
    YeMax=y2+xi;
    YeMin=y2-30;
    ZeMax=z2+zi;
    ZeMin=z2;
    xmissionMax=x1+xi2;
    xmissionMin=x1-xi2;
    ymissionMax=y1+xi2;
    ymissionMin=y1-xi2;
    % 目标函数
    f=@(a,b,c,a1,b1)((a-X0(1))^2+(b-X0(2))^2+(c-X0(3))^2)^0.5+omega*((a1-X00(1))^2+(b1-X00(2))^2)^0.5;
    % 设置种群参数
    xlimit_max=[XeMax;YeMax;ZeMax;xmissionMax;ymissionMax];%设置位置参数限制
    xlimit_min=[XeMin;YeMin;ZeMin;xmissionMin;ymissionMin];
    vlimit_max=[10;10;5;10;10];%设置速度限制
    vlimit_min=[-10;-10;-5;-10;-10];
%         x1=X(k);y1=Y(k);z1=Z(k);
    % 生成初始种群
    % 首先随机生成初始种群位置
    % 然后随机生成初始种群速度
    % 然后初始化个体历史最佳位置，以及个体历史最佳适应度
    % 然后初始化群体历史最佳位置，以及群体历史最佳适应度
    t1=clock;
    for i=1:dim
        for j=1:sizepop
            pop_x(i,j)=xlimit_min(i)+(xlimit_max(i)-xlimit_min(i))*rand;%初始种群的位置
            pop_v(i,j)=vlimit_min(i)+(vlimit_max(i)-vlimit_min(i))*rand;%初始种群的速度
        end
    end
    gbest=pop_x;%每个个体的历史最佳位置
    for j=1:sizepop
        [ Los1(j) ] = LosDegree1( x0,y0,z0,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
        [ Los2(j) ] = LosDegree2( pop_x(4,j),pop_x(5,j),z1,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
        [ Los3(j) ] = LosDegree3( pop_x(4,j),pop_x(5,j),z1,x1,y1,z1,interval/3 );
        [Dis(j)] = Distance(pop_x(4,j),pop_x(5,j),x1,y1);
        [c(j)] = nonlcon(pop_x(1,j),pop_x(2,j),pop_x(3,j),X0);
        if m<3 %至少三个路径点
            d(j)=1;
        else
            [d(j)] = downRadius(R,pop_x(4,j),pop_x(5,j),radius_missionUAV_X(m-1),radius_missionUAV_Y(m-1),radius_missionUAV_X(m-2),radius_missionUAV_Y(m-2));
        end
        if Los1(j)>cl && Los2(j)>cl && c(j)<ce && Los3(j)>cl && Dis(j)<=cd && d(j)>=0
            fitness_gbest(j)=f(pop_x(1,j),pop_x(2,j),pop_x(3,j),pop_x(4,j),pop_x(5,j));%每个个体的历史最佳适应度
        else
            fitness_gbest(j)=inf;
        end
    end
    zbest=pop_x(:,1);%种群的历史最佳位置
    fitness_zbest=fitness_gbest(1);%种群历史最佳适应度
    %求解最小值
    for j=1:sizepop
        if fitness_gbest(j)<fitness_zbest
            zbest=pop_x(:,j);
            fitness_zbest=fitness_gbest(j);
        end
    end
    % 粒子群迭代
    % 更新速度并对速度进行边界处理
    % 更新位置并对位置进行边界处理
    % 进行自适应变异
    % 进行约束条件判断并计算新种群各个个体位置的适应度
    % 新适应度与个体历史最佳适应度做比较
    % 个体历史最佳适应度与种群历史最佳适应度做比较
    % 再次循环或结束
    iter=1;%迭代次数
    record=zeros(ger,1);%记录器
    while iter<=ger
        for j=1:sizepop
            %更新速度并对速度进行边界处理
            pop_v(:,j)=c_1*pop_v(:,j)+c_2*rand*(gbest(:,j)-pop_x(:,j))+c_3*rand*(zbest-pop_x(:,j));%速度更新
            for i=1:dim
                if pop_v(i,j)>vlimit_max(i)
                    pop_v(i,j)=vlimit_max(i);
                end
                if pop_v(i,j)<vlimit_min(i)
                    pop_v(i,j)=vlimit_min(i);
                end
            end
            %更新位置并对位置进行边界处理
            pop_x(:,j)=pop_x(:,j)+pop_v(:,j);%位置更新
            for i=1:dim
                if pop_x(i,j)>xlimit_max(i)
                    pop_x(i,j)=xlimit_max(i);
                end
                if pop_x(i,j)<xlimit_min(i)
                    pop_x(i,j)=xlimit_min(i);
                end
            end
%             %进行自适应变异
%             if rand>0.85
%                 i=ceil(dim*rand);
%                 pop_x(i,j)=xlimit_min(i)+(xlimit_max(i)-xlimit_min(i))*rand;
%             end
            %进行约束条件判断并计算新种群各个个体位置的适应度
            [ Los1(j) ] = LosDegree1( x0,y0,z0,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
            [ Los2(j) ] = LosDegree2( pop_x(4,j),pop_x(5,j),z1,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
            [ Los3(j) ] = LosDegree3( pop_x(4,j),pop_x(5,j),z1,x1,y1,z1,interval/3 );
            [Dis(j)] = Distance(pop_x(4,j),pop_x(5,j),x1,y1);
            [c(j)] = nonlcon(pop_x(1,j),pop_x(2,j),pop_x(3,j),X0);
            if m<3 %至少三个路径点
                d(j)=1;
            else
                [d(j)] = downRadius(R,pop_x(4,j),pop_x(5,j),radius_missionUAV_X(m-1),radius_missionUAV_Y(m-1),radius_missionUAV_X(m-2),radius_missionUAV_Y(m-2));
            end
            if Los1(j)>cl && Los2(j)>cl && c(j)<ce && Los3(j)>cl && Dis(j)<=cd && d(j)>=0
                fitness_pop(j)=f(pop_x(1,j),pop_x(2,j),pop_x(3,j),pop_x(4,j),pop_x(5,j));%每个个体的历史最佳适应度
            else
                fitness_pop(j)=inf;
            end
            %新适应度与个体历史最佳适应度做比较
            if fitness_pop(j)<fitness_gbest(j)
                gbest(:,j)=pop_x(:,j);%更新个体历史最佳位置
                fitness_gbest(j)=fitness_pop(j);%更新个体历史最佳适应度
            end
            %个体历史最佳适应度与种群历史最佳适应度作比较
            if fitness_gbest(j)<fitness_zbest
                zbest=gbest(:,j);%更新群体历史最佳位置
                fitness_zbest=fitness_gbest(j);%更新群体历史最佳适应度
            end
        end
        record(iter)=fitness_zbest;%最小值记录
        iter=iter+1;
    end
    t2=clock;
    time_=etime(t2,t1);
    radius_missionUAV_X=[radius_missionUAV_X;zbest(4)];
    radius_missionUAV_Y=[radius_missionUAV_Y;zbest(5)];
    [ Los1 ] = LosDegree1( x0,y0,z0,ceil(zbest(1)),ceil(zbest(2)),ceil(zbest(3)),interval );
    [ Los2 ] = LosDegree2( ceil(zbest(4)),ceil(zbest(5)),z1,ceil(zbest(1)),ceil(zbest(2)),ceil(zbest(3)),interval );
    [ Los3 ] = LosDegree3( ceil(zbest(4)),ceil(zbest(5)),z1,x1,y1,z1,interval/3 );
    %中继机速度
    speedxy=((ceil(zbest(1))-x2)^2+(ceil(zbest(2))-y2)^2)^0.5;
    speedz=abs(ceil(zbest(3))-z2);
    speedxyz=((ceil(zbest(1))-x2)^2+(ceil(zbest(2))-y2)^2+(ceil(zbest(3))-z2)^2)^0.5;
    SpeedRelayxy=[SpeedRelayxy;speedxy];
    SpeedRelayz=[SpeedRelayz;speedz];
    SpeedRelayxyz=[SpeedRelayxyz;speedxyz];
    sumRelayDistance=sumRelayDistance+speedxyz;
    %记录每步耗时
    Time_=[Time_;time_];
    %记录任务机偏离标准路径的距离
    Los_=[Los_;Los3];
    %记录任务机速度
    Dis1=((ceil(zbest(4))-x1)^2+(ceil(zbest(5))-y1)^2)^0.5;
    if Dis1>100
        Dis1=Dis1-10;
    end
    Distence=[Distence;Dis1];
    %记录任务机位置
    xm=[xm;ceil(zbest(4))];
    ym=[ym;ceil(zbest(5))];
    zm=[zm;50];
    %更新任务机位置
    x1=ceil(zbest(4));
    y1=ceil(zbest(5));
    dis2=((x1-X(k))^2+(y1-Y(k))^2)^0.5;
    Dis2=[Dis2;dis2];
    %更新中继机位置
    x2=ceil(zbest(1));
    y2=ceil(zbest(2));
    z2=ceil(zbest(3));
    %记录中继机位置
    Losx=[Losx;x2];
    Losy=[Losy;y2];
    Losz=[Losz;z2];
    %记录通视度
    [ Los1 ] = LosDegree1( x0,y0,z0,x2,y2,z2,interval );
    [ Los2 ] = LosDegree2( x1,y1,z1,x2,y2,z2,interval );
    los1=[los1;Los1];
    los2=[los2;Los2];
    %记录位置通视度信息
    Los_XYZ=[Losx Losy Losz];
    %中继无人机总飞行距离
%     for ii=2:length(Losx)
%         disr=((Losx(ii)-Losx(ii-1))^2+(Losy(ii)-Losy(ii-1))^2+(Losz(ii)-Losz(ii-1))^2)^0.5;
%         sumRelayDistance=sumRelayDistance+disr;
%         
%     end
    los123=[los1 los2 Los_];
    Mission_XYZ=[xm ym zm];
    speedRelayMission=[Distence/5 SpeedRelayxy/5 SpeedRelayz/5 SpeedRelayxyz/5];
    TotalStep=[Distence SpeedRelayxy SpeedRelayz SpeedRelayxyz];
    allInformation1=[xm ym zm Losx Losy Losz los1 los2 Los_ Distence/10 SpeedRelayxy/10 SpeedRelayz/10 SpeedRelayxyz/10 Distence SpeedRelayxy SpeedRelayz SpeedRelayxyz Dis2];
%     totalTime=[totalTime;length(xm)];
%     totalRelayDistance=[];
    % 终止条件
    disToEndPosiyion=((x1-X(length(X)))^2+(y1-Y(length(X)))^2)^0.5;
    fprintf('第 %d 次搜索',m);
    fprintf('任务无人机位置：(%d, %d)\n',ceil(zbest(4)),ceil(zbest(5)));
    fprintf('任务无人机最优路径位置：(%d, %d)\n',X(k),Y(k));
    fprintf('任务无人机通视度：%d\n',ceil(Los3));
    fprintf('中继无人机位置：(%d, %d，%d)\n',ceil(zbest(1)),ceil(zbest(2)),ceil(zbest(3)));
    fprintf('中继无人机与地面站通视度：%d\n',ceil(Los1));
    fprintf('中继无人机与任务无人机通视度：%d\n\n',ceil(Los2));
    %画图展示
    plot(X,Y,'g','Linewidth',0.8);
    hold on;
%     scatter(X(k),Y(k),10,'b','filled');
%     hold on;
    plot(xm,ym,'m','Linewidth',0.5);
    hold on;
    scatter(x1,y1,5,'m','filled');
    pause(0.0001);
    if disToEndPosiyion < 5
        fprintf('到达任务终点位置\n');
        break;
    end
%     if m>=length(X)+1
%         fprintf('未到达任务终点位置\n');
%         break;
%     end
end
t4=clock;
time_2=etime(t3,t4);
% allInformation=[allInformation xm ym zm Losx Losy Losz los1 los2 Los_ Distence/10 SpeedRelayxy/10 SpeedRelayz/10 SpeedRelayxyz/10 Distence SpeedRelayxy SpeedRelayz SpeedRelayxyz Dis2];
totalTime=[totalTime;length(xm)];
totalRelayDistance=[totalRelayDistance;sumRelayDistance];
total=[totalTime totalRelayDistance];
fprintf('完成 Omega=%f 的计算\n\n',omega);
% end
%% 绘制通视度情况
figure(2);
plot(los1);
hold on;
plot(los2);
hold on;
plot(Los_);
title('通视度情况');
% figure(3);
% plot(Distence/10);
% title('任务无人机速度');
% figure(4);
% plot(Dis2);
% title('任务无人机偏离距离');
sum=0;
for i=2:1:length(Losx)
    dis=((Losx(i)-Losx(i-1))^2+(Losy(i)-Losy(i-1))^2+(Losz(i)-Losz(i-1))^2)^0.5;
    sum=sum+dis;
end
%% 绘制中继机每时刻的速度曲线
figure(5);
plot(SpeedRelayxy/5);
figure(6);
plot(SpeedRelayz/5);