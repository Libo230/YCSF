% 2.6 ����
% ����(mutation)�������ͻ���ձ����������Ľ��������С�������ָ�����е�ÿ�������ÿһλ���Ը��� pm ��ת�����ɡ�1����Ϊ��0����
% ���ɡ�0����Ϊ��1�����Ŵ��㷨�ı������Կ���ʹ���������������������ܴ��ڵ������ռ䣬��˿�����һ���̶������ȫ�����Ž⡣
%�Ŵ��㷨�ӳ���
%Name: mutation.m
%����
function [newpop]=mutation_multiv(pop,pm)
global Numv 
[px,py]=size(pop);
m=py/Numv;
for j=1:Numv
    newpop1=ones(px,m);
    pop1=pop(:,m*(j-1)+1:m*j);      %ȡ����Ӧ������Ӧ�Ķ����Ʊ���� 
    for i=1:px
       if(rand<pm) %����һ������������ʱȽ�
          mpoint=round(rand*(m-1));   %mpointΪ�����
          if mpoint<=0
             mpoint=1;
          end
          newpop1(i,:)=pop1(i,:);
          if any(newpop1(i,mpoint))==0
            newpop1(i,mpoint)=1;
         else
            newpop1(i,mpoint)=0;
         end
      else
        newpop1(i,:)=pop1(i,:);
      end
   end
   newpop(:,m*(j-1)+1:m*j)=newpop1;      %�������ı�����������Ⱥ��
end

