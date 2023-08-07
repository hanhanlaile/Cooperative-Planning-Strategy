function [ Los ] = LosDegree( x0,y0,x1,y1,interval )
%中继无人机与地面控制端间的通视度
    %计算当前位置中继无人机与地面终端通视度
    x_min=min(x0,x1);
    x_max=max(x0,x1);
    F_0=[];
    for x_pre0=(x_min+interval):interval:(x_max-interval)
        %y，z的解析式
        t0=(x_pre0-x0)/(x1-x0);
        y_pre0=y0+t0*(y1-y0);
        %计算通视度
        [z_real]=mountain_function(x_pre0,y_pre0)-3.5*error_function(x_pre0,y_pre0);
        if (z_real<0)
            z_real=0;
        end
        FL0=50-z_real;
        F_0=[F_0 FL0];
    end
    mm=min(F_0);
    if isempty(mm)
        Los=8.1;
    else
        Los=mm;
    end
end