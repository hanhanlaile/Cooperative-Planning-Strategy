function d = downRadius(R,X_m,Y_m,X_m_1,Y_m_1,X_m_2,Y_m_2)
% 最小半径约束，下半径
    w1=[X_m_2 Y_m_2]; %每三个路径点作为一组
    w2=[X_m_1 Y_m_1];
    w3=[X_m Y_m];
    q1=(w1-w2)/norm(w1-w2); %向量w2w1的单位向量
    q2=(w3-w2)/norm(w3-w2); %向量w3w2的单位向量
    theta = Angle(q1,q2); %向量w2w1和向量w3w2之间的夹角
    if theta == 180
        d=((w3(1)-w2(1))^2+(w3(2)-w2(2))^2)^0.5;
    else
        theta_degree=theta*pi/180; %换算为角度
        q=(q2+q1)/norm(q2+q1); %角平分线单位向量
%         R=10; %最小转弯半径
        center=w2+R*q/sin(theta_degree/2); %圆的中心点
%         w12=w2+((center(1)-w2(1))^2+(center(2)-w2(2))^2-R^2)^0.5*q1; %圆与w1w2的切点
        w32=w2+((center(1)-w2(1))^2+(center(2)-w2(2))^2-R^2)^0.5*q2; %圆与w3w2的切点
        d=((w3(1)-w2(1))^2+(w3(2)-w2(2))^2)^0.5-((w3(1)-w32(1))^2+(w3(2)-w32(2))^2)^0.5;
    end
end

