% 2.7 ���Ⱥ����������Ӧֵ�������
%�Ŵ��㷨�ӳ���
%Name: best.m
%���Ⱥ������Ӧֵ����ֵ
function [bestindividual,bestobj]=best(pop,fitvalue)
global badvalue
[px,py]=size(pop);
bestindividual=pop(1,:);
bestfit=fitvalue(1);
for i=2:px
if fitvalue(i)>bestfit
bestindividual=pop(i,:);
bestfit=fitvalue(i);
end
end
bestobj=badvalue-bestfit;