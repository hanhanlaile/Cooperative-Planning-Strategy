function [ Los1 ] = LosDegree1( x0,y0,z0,x2,y2,z2,interval )
%中继无人机与地面控制端间的通视度
    %计算当前位置中继无人机与地面终端通视度
    x_min=min(x0,x2);
    x_max=max(x0,x2);
    F_0=[];
    for x_pre0=(x_min+interval):interval:(x_max-interval)
        %y，z的解析式
        t0=(x_pre0-x0)/(x2-x0);
        y_pre0=y0+t0*(y2-y0);
        z_pre0=z0+t0*(z2-z0);
        %计算通视度
        [z_real]=mountain_function(x_pre0,y_pre0)-3.5*error_function(x_pre0,y_pre0);
        if (z_real<0)
            z_real=0;
        end
        FL0=z_pre0-z_real+12;
        F_0=[F_0 FL0];
    end
    mm=min(F_0);
    if isempty(mm)
        Los1=-1000;
    else
        Los1=mm;
    end
end