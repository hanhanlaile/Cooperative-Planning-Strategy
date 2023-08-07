function [c] = nonlcon(x2,y2,z2,X0)
%nonlcon 非线性约束
%   通视约束、椭球约束
    c=(((x2-X0(1))/100)^2+((y2-X0(2))/100)^2+((z2-X0(3))/25)^2)^0.5;
end
