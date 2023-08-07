function [ Los3 ] = LosDegree3( x1,y1,z1,x2,y2,z2,interval )
%�м����˻����������˻����ͨ�Ӷ�
    %��ȡ�м̻����������Χ�ڵ�ʵ������
    x_min=min(x1,x2);
    x_max=max(x1,x2);
    %���㵱ǰλ���м����˻����������˻�ͨ�Ӷ�
    F_1=[];
    for x_pre1=(x_min+interval):interval:(x_max-interval)
        %����y��z��
        t1=(x_pre1-x1)/(x2-x1);
        y_pre1=y1+t1*(y2-y1);
        z_pre1=z1+t1*(z2-z1);
        [z_real]=mountain_function(x_pre1,y_pre1)-3.5*error_function(x_pre1,y_pre1);       
        if (z_real<0)
            z_real=0;
        end
        %����ͨ�Ӷ�
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