% 2.6 变异
% 变异(mutation)，基因的突变普遍存在于生物的进化过程中。变异是指父代中的每个个体的每一位都以概率 pm 翻转，即由“1”变为“0”，
% 或由“0”变为“1”。遗传算法的变异特性可以使求解过程随机地搜索到解可能存在的整个空间，因此可以在一定程度上求得全局最优解。
%遗传算法子程序
%Name: mutation.m
%变异
function [newpop]=mutation_multiv(pop,pm)
global Numv 
[px,py]=size(pop);
m=py/Numv;
for j=1:Numv
    newpop1=ones(px,m);
    pop1=pop(:,m*(j-1)+1:m*j);      %取出相应变量对应的二进制编码段 
    for i=1:px
       if(rand<pm) %产生一随机数与变异概率比较
          mpoint=round(rand*(m-1));   %mpoint为变异点
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
   newpop(:,m*(j-1)+1:m*j)=newpop1;      %将变异后的变量放入新种群中
end

