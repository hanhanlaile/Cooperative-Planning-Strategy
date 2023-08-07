function [ Los3 ] = LosDegree3( x1,y1,z1,x2,y2,z2,interval )
%中继无人机与任务无人机间的通视度
    %提取中继机与任务机范围内的实际数据
    x_min=min(x1,x2);
    x_max=max(x1,x2);
    %计算当前位置中继无人机与任务无人机通视度
    F_1=[];
    for x_pre1=(x_min+interval):interval:(x_max-interval)
        %计算y，z点
        t1=(x_pre1-x1)/(x2-x1);
        y_pre1=y1+t1*(y2-y1);
        z_pre1=z1+t1*(z2-z1);
        [z_real]=mountain_function(x_pre1,y_pre1)-3.5*error_function(x_pre1,y_pre1);       
        if (z_real<0)
            z_real=0;
        end
        %计算通视度
        FL1=z_pre1-z_real;
        F_1=[F_1 FL1];
    end
    mm=min(F_1);
    if isempty(mm)
        Los3=-1000;
    else
        Los3=mm;
    end
end