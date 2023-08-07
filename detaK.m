function [m] = detaK(X,Y,k)
    %detaK calculate detaK
    sum=0;
    for i=1:199
        if k+i>199
            m=199;
            break;
        end
        dis=((X(k+i)-X(k+i-1))^2+((Y(k+i)-Y(k+i-1))^2))^0.5;
        sum=sum+dis;
        if sum>100
            m=k+i-1;
            break;
        end
%         dis=((X(k+i)-X(k))^2+((Y(k+i)-Y(k))^2))^0.5;
%         if dis>100
%             m=k+i-1;
%             break;
%         end
    end
end

