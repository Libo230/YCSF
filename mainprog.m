 %???????????????????????????????????????????????????????????????????%
% 
%
%?? 将 x 的值用一个10位的二值形式表示为二值问题?????????????????????%
%----------------------------------------------
% 编程
%----------------------------------------------
%n维Griewangk函数寻找极小值
%可任意设置待优化变量数目和它们各自的变化范围
%遗传算法主程序
clear
clf
%% 数据导入
xdata1=xlsread('1'); 
xdata2=xlsread('2');
dm=xdata1-xdata2;
%%
%% T2谱反演
f_start=0.3e+0;f_end=0.3e+4;nT2=30;  
T2min=0.3;T2max=3000;
for i=1:nT2
    T2(i)=T2min*(T2max/T2min)^((i-1)/(nT2-1));
end
TE=0.9;%ms
TWA=6.0;
T1=3.0; % water 1-500；oil 3000-4000；gas：4000-5000？？  
e=500;
t=1*TE:TE:e*TE;
necho=length(t);
TWs=2000;
TWl=12988;
TE=0.9;
   for j=1:1
         
       record=xdata1(j,:);
       Ff=gameofthrones(record,t,necho,T2,nT2);
       fy(j,:)=Ff;
   end
%%
%%遗传算法%%


ss=waitbar(0,'大循环');
global bounds
global Numv        %优化参数个数， 每个变量具有相同长度的二进制编码
global badvalue
for sd=1:1 %深度
    tic
     fx=fy(sd,:);
    d=dm(sd,1:100);
Numv=6;              %本例中为四维griewangk函数，优化参数4个
popsize=80;          %设置初始参数，群体大小
chromlength=Numv*15; %字符串长度（个体长度），染色体长度
eranum=80;     %设置种群代数，一般取20－100
pc=0.90;         %设置交叉概率，本例中交叉概率是定值，若想设置变化的交叉概率可用表达式表示，或从写一个
                %交叉概率函数，例如用神经网络训练得到的值作为交叉概率
pm=0.1;         %设置变异概率，同理也可设置为变化的
badvalue=300;   %估计最差值   
bestvalue=badvalue; 
 bounds=[0.1 1;400 600;2000 4000;400 600;400 600;9 20];                 %自变量上下限
pop=initpop(popsize,chromlength);   %运行初始化函数，随机产生初始群体
pmutation=pm;
average=10;
trace=[bestvalue];
hh=waitbar(0,'小循环');
for i=1:eranum    %迭代
 t1=clock;    
  
  totalobj=0;
sol=decode_multiv(pop);                   %将pop每行转化成十进制数

[px,py] = size(sol);
for r=1:px  %未知数
     x=sol(r,:);

 for ii=1:100
  
     for jj=1:30
       m1(ii,jj)=fx(jj).*(exp(-((ii.*TE)./(T2min*(T2max/T2min)^((jj-1)/(nT2-1))))));
     end
    m2(ii,1)=((1-x(1)).*(exp(-(TWs./x(2)))-exp(-(TWl./x(2))))+x(1).*(exp(-(TWs./x(3)))-exp(-(TWl./x(3))))).*sum(m1(ii,:));
    m3(ii,1)=(1-x(1)).*(exp(-(TWs./x(3)))-exp(-(TWl./x(3)))).*exp(-(ii.*TE)./x(4)).*x(6);
    m4(ii,1)=x(1).*(exp(-(TWs./x(2)))-exp(-(TWl./x(2)))).*exp(-(ii.*TE)./x(5)).*(sum(fx)-x(6));
    m5(ii,1)= m2(ii,1)+ m3(ii,1)+ m4(ii,1);

 end  
m=(d-(m5(:,1))').*(d-(m5(:,1))');
  eval(r,:)=sum(m);
end


objvalue= eval;                   %计算目标函数值

totalobj=sum(objvalue);
averageobj=totalobj/size(objvalue,1);    %本代目标函数平均值
   
   
   
   average(i)=averageobj;   %记录每代平均目标值
   fitvalue=calfitvalue(objvalue);     %计算群体中每个个体的适应度
   [newpop]=selection(pop,fitvalue);   %复制
   [newpop]=crossover_multiv(newpop,pc);      %交叉
   [newpop]=mutation_multiv(newpop,pmutation);       %变异
   pmutation=pm+(i^4)*(0.6-pm)/(eranum^4);    %随着种群不断进化，逐步增大变异率
   [bestindividual,bestobj]=best(pop,fitvalue);   %求出群体中适应值最大的个体及其适应值
   y(i)=bestobj;
   if y(i)<bestvalue                              %保留迄今为止最优的个体及其适应值
       bestvalue=y(i);
       bestind=decode_multiv(bestindividual);
       bestind=bestind';
   end
   x(i,:)=decode_multiv(bestindividual);
   pop=newpop;
    trace=[trace; bestvalue];
    
     t2=clock;
    tt=etime(t2,t1);
    tt=tt*(eranum-i);
    t_h=floor(tt/3600);
    if t_h<10
        str_t_h=['0',num2str(t_h)];
    else
        str_t_h=num2str(t_h);
    end
    t_mn=floor(mod(tt,3600)/60);
    if t_mn<10
        str_t_mn=['0',num2str(t_mn)];
    else
        str_t_mn=num2str(t_mn);
    end
    t_s=floor(mod(tt,60));
    if t_s<10
        str_t_s=['0',num2str(t_s)];
    else
        str_t_s=num2str(t_s);
    end
    str=['李博正在迭代,大约还需要',str_t_h,':',str_t_mn,':',str_t_s,'   百分比：',num2str(i/eranum*100),'%'];
    waitbar(i/eranum,hh,str);
    
end
close(hh);
  plot(trace(:,1))
   title('适应度曲线','fontsize',12);

bestbo(:,sd)=bestvalue;
zhui(:,sd)=bestind;
str2=['第',num2str(sd),'次'];
waitbar(sd/1000,ss,str2);
toc
end
bestbo
zhui
