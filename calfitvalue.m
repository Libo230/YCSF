% 2.3 ����������Ӧֵ
%�Ŵ��㷨�ӳ���
%Name:calfitvalue.m
%����������Ӧֵ
function fitvalue=calfitvalue(objvalue)
global badvalue
[px,py]=size(objvalue);
for i=1:px
   fitvalue(i)=badvalue-objvalue(i);       %����ֵԽС����ӦֵԽ��
end
fitvalue=fitvalue';


