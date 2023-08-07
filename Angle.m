function theta = Angle(a,b)
    costheta = dot(a,b)/(norm(a)*norm(b)); % ����ֵ
    if costheta <= -1
        cost = -1;
    elseif costheta >=1
        cost = 1;
    else
        cost = costheta;
    end
    theta = acos(cost)*180/pi; % �нǡ�
end

