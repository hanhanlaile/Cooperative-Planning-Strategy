function [ Los1 ] = LosDegree1( x0,y0,z0,x2,y2,z2,interval )
%�м����˻��������ƶ˼��ͨ�Ӷ�
    %���㵱ǰλ���м����˻�������ն�ͨ�Ӷ�
    x_min=min(x0,x2);
    x_max=max(x0,x2);
    F_0=[];
    for x_pre0=(x_min+interval):interval:(x_max-interval)
        %y��z�Ľ���ʽ
        t0=(x_pre0-x0)/(x2-x0);
        y_pre0=y0+t0*(y2-y0);
        z_pre0=z0+t0*(z2-z0);
        %����ͨ�Ӷ�
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