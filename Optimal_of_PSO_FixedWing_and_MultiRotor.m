%% ������ʼ��
data=xlsread('���Ź켣��.xlsx');
X=data(:,1);
Y=data(:,2);
Z=data(:,3);
data1=csvread('�ϰ�����.csv');
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
%�洢ͨ��λ��
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
%����Ⱥ����
sizepop=20;%��ʼ��Ⱥ����
dim=5;%�ռ�ά��
ger=30;%����������
c_1=0.7;%����Ȩ��
c_2=2;%����ѧϰ����
c_3=2;%Ⱥ��ѧϰ����
omega=0.1;
m=1;
count=0;%��������ͳ��k>199�Ĵ���������2����ѭ��
% disRelay=[];
sumRelayDistance=0;
cd=100;
R=20;
%% ��������ͨ��λ��
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
    % Ŀ�꺯��
    f=@(a,b,c,a1,b1)((a-X0(1))^2+(b-X0(2))^2+(c-X0(3))^2)^0.5+omega*((a1-X00(1))^2+(b1-X00(2))^2)^0.5;
    % ������Ⱥ����
    xlimit_max=[XeMax;YeMax;ZeMax;xmissionMax;ymissionMax];%����λ�ò�������
    xlimit_min=[XeMin;YeMin;ZeMin;xmissionMin;ymissionMin];
    vlimit_max=[10;10;5;10;10];%�����ٶ�����
    vlimit_min=[-10;-10;-5;-10;-10];
%         x1=X(k);y1=Y(k);z1=Z(k);
    % ���ɳ�ʼ��Ⱥ
    % ����������ɳ�ʼ��Ⱥλ��
    % Ȼ��������ɳ�ʼ��Ⱥ�ٶ�
    % Ȼ���ʼ��������ʷ���λ�ã��Լ�������ʷ�����Ӧ��
    % Ȼ���ʼ��Ⱥ����ʷ���λ�ã��Լ�Ⱥ����ʷ�����Ӧ��
    t1=clock;
    for i=1:dim
        for j=1:sizepop
            pop_x(i,j)=xlimit_min(i)+(xlimit_max(i)-xlimit_min(i))*rand;%��ʼ��Ⱥ��λ��
            pop_v(i,j)=vlimit_min(i)+(vlimit_max(i)-vlimit_min(i))*rand;%��ʼ��Ⱥ���ٶ�
        end
    end
    gbest=pop_x;%ÿ���������ʷ���λ��
    for j=1:sizepop
        [ Los1(j) ] = LosDegree1( x0,y0,z0,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
        [ Los2(j) ] = LosDegree2( pop_x(4,j),pop_x(5,j),z1,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
        [ Los3(j) ] = LosDegree3( pop_x(4,j),pop_x(5,j),z1,x1,y1,z1,interval/3 );
        [Dis(j)] = Distance(pop_x(4,j),pop_x(5,j),x1,y1);
        [c(j)] = nonlcon(pop_x(1,j),pop_x(2,j),pop_x(3,j),X0);
        if m<3 %��������·����
            d(j)=1;
        else
            [d(j)] = downRadius(R,pop_x(4,j),pop_x(5,j),radius_missionUAV_X(m-1),radius_missionUAV_Y(m-1),radius_missionUAV_X(m-2),radius_missionUAV_Y(m-2));
        end
        if Los1(j)>cl && Los2(j)>cl && c(j)<ce && Los3(j)>cl && Dis(j)<=cd && d(j)>=0
            fitness_gbest(j)=f(pop_x(1,j),pop_x(2,j),pop_x(3,j),pop_x(4,j),pop_x(5,j));%ÿ���������ʷ�����Ӧ��
        else
            fitness_gbest(j)=inf;
        end
    end
    zbest=pop_x(:,1);%��Ⱥ����ʷ���λ��
    fitness_zbest=fitness_gbest(1);%��Ⱥ��ʷ�����Ӧ��
    %�����Сֵ
    for j=1:sizepop
        if fitness_gbest(j)<fitness_zbest
            zbest=pop_x(:,j);
            fitness_zbest=fitness_gbest(j);
        end
    end
    % ����Ⱥ����
    % �����ٶȲ����ٶȽ��б߽紦��
    % ����λ�ò���λ�ý��б߽紦��
    % ��������Ӧ����
    % ����Լ�������жϲ���������Ⱥ��������λ�õ���Ӧ��
    % ����Ӧ���������ʷ�����Ӧ�����Ƚ�
    % ������ʷ�����Ӧ������Ⱥ��ʷ�����Ӧ�����Ƚ�
    % �ٴ�ѭ�������
    iter=1;%��������
    record=zeros(ger,1);%��¼��
    while iter<=ger
        for j=1:sizepop
            %�����ٶȲ����ٶȽ��б߽紦��
            pop_v(:,j)=c_1*pop_v(:,j)+c_2*rand*(gbest(:,j)-pop_x(:,j))+c_3*rand*(zbest-pop_x(:,j));%�ٶȸ���
            for i=1:dim
                if pop_v(i,j)>vlimit_max(i)
                    pop_v(i,j)=vlimit_max(i);
                end
                if pop_v(i,j)<vlimit_min(i)
                    pop_v(i,j)=vlimit_min(i);
                end
            end
            %����λ�ò���λ�ý��б߽紦��
            pop_x(:,j)=pop_x(:,j)+pop_v(:,j);%λ�ø���
            for i=1:dim
                if pop_x(i,j)>xlimit_max(i)
                    pop_x(i,j)=xlimit_max(i);
                end
                if pop_x(i,j)<xlimit_min(i)
                    pop_x(i,j)=xlimit_min(i);
                end
            end
%             %��������Ӧ����
%             if rand>0.85
%                 i=ceil(dim*rand);
%                 pop_x(i,j)=xlimit_min(i)+(xlimit_max(i)-xlimit_min(i))*rand;
%             end
            %����Լ�������жϲ���������Ⱥ��������λ�õ���Ӧ��
            [ Los1(j) ] = LosDegree1( x0,y0,z0,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
            [ Los2(j) ] = LosDegree2( pop_x(4,j),pop_x(5,j),z1,pop_x(1,j),pop_x(2,j),pop_x(3,j),interval );
            [ Los3(j) ] = LosDegree3( pop_x(4,j),pop_x(5,j),z1,x1,y1,z1,interval/3 );
            [Dis(j)] = Distance(pop_x(4,j),pop_x(5,j),x1,y1);
            [c(j)] = nonlcon(pop_x(1,j),pop_x(2,j),pop_x(3,j),X0);
            if m<3 %��������·����
                d(j)=1;
            else
                [d(j)] = downRadius(R,pop_x(4,j),pop_x(5,j),radius_missionUAV_X(m-1),radius_missionUAV_Y(m-1),radius_missionUAV_X(m-2),radius_missionUAV_Y(m-2));
            end
            if Los1(j)>cl && Los2(j)>cl && c(j)<ce && Los3(j)>cl && Dis(j)<=cd && d(j)>=0
                fitness_pop(j)=f(pop_x(1,j),pop_x(2,j),pop_x(3,j),pop_x(4,j),pop_x(5,j));%ÿ���������ʷ�����Ӧ��
            else
                fitness_pop(j)=inf;
            end
            %����Ӧ���������ʷ�����Ӧ�����Ƚ�
            if fitness_pop(j)<fitness_gbest(j)
                gbest(:,j)=pop_x(:,j);%���¸�����ʷ���λ��
                fitness_gbest(j)=fitness_pop(j);%���¸�����ʷ�����Ӧ��
            end
            %������ʷ�����Ӧ������Ⱥ��ʷ�����Ӧ�����Ƚ�
            if fitness_gbest(j)<fitness_zbest
                zbest=gbest(:,j);%����Ⱥ����ʷ���λ��
                fitness_zbest=fitness_gbest(j);%����Ⱥ����ʷ�����Ӧ��
            end
        end
        record(iter)=fitness_zbest;%��Сֵ��¼
        iter=iter+1;
    end
    t2=clock;
    time_=etime(t2,t1);
    radius_missionUAV_X=[radius_missionUAV_X;zbest(4)];
    radius_missionUAV_Y=[radius_missionUAV_Y;zbest(5)];
    [ Los1 ] = LosDegree1( x0,y0,z0,ceil(zbest(1)),ceil(zbest(2)),ceil(zbest(3)),interval );
    [ Los2 ] = LosDegree2( ceil(zbest(4)),ceil(zbest(5)),z1,ceil(zbest(1)),ceil(zbest(2)),ceil(zbest(3)),interval );
    [ Los3 ] = LosDegree3( ceil(zbest(4)),ceil(zbest(5)),z1,x1,y1,z1,interval/3 );
    %�м̻��ٶ�
    speedxy=((ceil(zbest(1))-x2)^2+(ceil(zbest(2))-y2)^2)^0.5;
    speedz=abs(ceil(zbest(3))-z2);
    speedxyz=((ceil(zbest(1))-x2)^2+(ceil(zbest(2))-y2)^2+(ceil(zbest(3))-z2)^2)^0.5;
    SpeedRelayxy=[SpeedRelayxy;speedxy];
    SpeedRelayz=[SpeedRelayz;speedz];
    SpeedRelayxyz=[SpeedRelayxyz;speedxyz];
    sumRelayDistance=sumRelayDistance+speedxyz;
    %��¼ÿ����ʱ
    Time_=[Time_;time_];
    %��¼�����ƫ���׼·���ľ���
    Los_=[Los_;Los3];
    %��¼������ٶ�
    Dis1=((ceil(zbest(4))-x1)^2+(ceil(zbest(5))-y1)^2)^0.5;
    if Dis1>100
        Dis1=Dis1-10;
    end
    Distence=[Distence;Dis1];
    %��¼�����λ��
    xm=[xm;ceil(zbest(4))];
    ym=[ym;ceil(zbest(5))];
    zm=[zm;50];
    %���������λ��
    x1=ceil(zbest(4));
    y1=ceil(zbest(5));
    dis2=((x1-X(k))^2+(y1-Y(k))^2)^0.5;
    Dis2=[Dis2;dis2];
    %�����м̻�λ��
    x2=ceil(zbest(1));
    y2=ceil(zbest(2));
    z2=ceil(zbest(3));
    %��¼�м̻�λ��
    Losx=[Losx;x2];
    Losy=[Losy;y2];
    Losz=[Losz;z2];
    %��¼ͨ�Ӷ�
    [ Los1 ] = LosDegree1( x0,y0,z0,x2,y2,z2,interval );
    [ Los2 ] = LosDegree2( x1,y1,z1,x2,y2,z2,interval );
    los1=[los1;Los1];
    los2=[los2;Los2];
    %��¼λ��ͨ�Ӷ���Ϣ
    Los_XYZ=[Losx Losy Losz];
    %�м����˻��ܷ��о���
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
    % ��ֹ����
    disToEndPosiyion=((x1-X(length(X)))^2+(y1-Y(length(X)))^2)^0.5;
    fprintf('�� %d ������',m);
    fprintf('�������˻�λ�ã�(%d, %d)\n',ceil(zbest(4)),ceil(zbest(5)));
    fprintf('�������˻�����·��λ�ã�(%d, %d)\n',X(k),Y(k));
    fprintf('�������˻�ͨ�Ӷȣ�%d\n',ceil(Los3));
    fprintf('�м����˻�λ�ã�(%d, %d��%d)\n',ceil(zbest(1)),ceil(zbest(2)),ceil(zbest(3)));
    fprintf('�м����˻������վͨ�Ӷȣ�%d\n',ceil(Los1));
    fprintf('�м����˻����������˻�ͨ�Ӷȣ�%d\n\n',ceil(Los2));
    %��ͼչʾ
    plot(X,Y,'g','Linewidth',0.8);
    hold on;
%     scatter(X(k),Y(k),10,'b','filled');
%     hold on;
    plot(xm,ym,'m','Linewidth',0.5);
    hold on;
    scatter(x1,y1,5,'m','filled');
    pause(0.0001);
    if disToEndPosiyion < 5
        fprintf('���������յ�λ��\n');
        break;
    end
%     if m>=length(X)+1
%         fprintf('δ���������յ�λ��\n');
%         break;
%     end
end
t4=clock;
time_2=etime(t3,t4);
% allInformation=[allInformation xm ym zm Losx Losy Losz los1 los2 Los_ Distence/10 SpeedRelayxy/10 SpeedRelayz/10 SpeedRelayxyz/10 Distence SpeedRelayxy SpeedRelayz SpeedRelayxyz Dis2];
totalTime=[totalTime;length(xm)];
totalRelayDistance=[totalRelayDistance;sumRelayDistance];
total=[totalTime totalRelayDistance];
fprintf('��� Omega=%f �ļ���\n\n',omega);
% end
%% ����ͨ�Ӷ����
figure(2);
plot(los1);
hold on;
plot(los2);
hold on;
plot(Los_);
title('ͨ�Ӷ����');
% figure(3);
% plot(Distence/10);
% title('�������˻��ٶ�');
% figure(4);
% plot(Dis2);
% title('�������˻�ƫ�����');
sum=0;
for i=2:1:length(Losx)
    dis=((Losx(i)-Losx(i-1))^2+(Losy(i)-Losy(i-1))^2+(Losz(i)-Losz(i-1))^2)^0.5;
    sum=sum+dis;
end
%% �����м̻�ÿʱ�̵��ٶ�����
figure(5);
plot(SpeedRelayxy/5);
figure(6);
plot(SpeedRelayz/5);