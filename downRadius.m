function d = downRadius(R,X_m,Y_m,X_m_1,Y_m_1,X_m_2,Y_m_2)
% ��С�뾶Լ�����°뾶
    w1=[X_m_2 Y_m_2]; %ÿ����·������Ϊһ��
    w2=[X_m_1 Y_m_1];
    w3=[X_m Y_m];
    q1=(w1-w2)/norm(w1-w2); %����w2w1�ĵ�λ����
    q2=(w3-w2)/norm(w3-w2); %����w3w2�ĵ�λ����
    theta = Angle(q1,q2); %����w2w1������w3w2֮��ļн�
    if theta == 180
        d=((w3(1)-w2(1))^2+(w3(2)-w2(2))^2)^0.5;
    else
        theta_degree=theta*pi/180; %����Ϊ�Ƕ�
        q=(q2+q1)/norm(q2+q1); %��ƽ���ߵ�λ����
%         R=10; %��Сת��뾶
        center=w2+R*q/sin(theta_degree/2); %Բ�����ĵ�
%         w12=w2+((center(1)-w2(1))^2+(center(2)-w2(2))^2-R^2)^0.5*q1; %Բ��w1w2���е�
        w32=w2+((center(1)-w2(1))^2+(center(2)-w2(2))^2-R^2)^0.5*q2; %Բ��w3w2���е�
        d=((w3(1)-w2(1))^2+(w3(2)-w2(2))^2)^0.5-((w3(1)-w32(1))^2+(w3(2)-w32(2))^2)^0.5;
    end
end

