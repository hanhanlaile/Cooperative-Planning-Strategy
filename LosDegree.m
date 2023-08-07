function [ Los ] = LosDegree( x0,y0,x1,y1,interval )
%�м����˻��������ƶ˼��ͨ�Ӷ�
    %���㵱ǰλ���м����˻�������ն�ͨ�Ӷ�
    x_min=min(x0,x1);
    x_max=max(x0,x1);
    F_0=[];
    for x_pre0=(x_min+interval):interval:(x_max-interval)
        %y��z�Ľ���ʽ
        t0=(x_pre0-x0)/(x1-x0);
        y_pre0=y0+t0*(y1-y0);
        %����ͨ�Ӷ�
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