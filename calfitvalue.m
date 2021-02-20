% 2.3 计算个体的适应值
%遗传算法子程序
%Name:calfitvalue.m
%计算个体的适应值
function fitvalue=calfitvalue(objvalue)
global badvalue
[px,py]=size(objvalue);
for i=1:px
   fitvalue(i)=badvalue-objvalue(i);       %函数值越小，适应值越大
end
fitvalue=fitvalue';


