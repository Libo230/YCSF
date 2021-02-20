 %???????????????????????????????????????????????????????????????????%
% 
%
%?? �� x ��ֵ��һ��10λ�Ķ�ֵ��ʽ��ʾΪ��ֵ����?????????????????????%
%----------------------------------------------
% ���
%----------------------------------------------
%nάGriewangk����Ѱ�Ҽ�Сֵ
%���������ô��Ż�������Ŀ�����Ǹ��Եı仯��Χ
%�Ŵ��㷨������
clear
clf
%% ���ݵ���
xdata1=xlsread('1'); 
xdata2=xlsread('2');
dm=xdata1-xdata2;
%%
%% T2�׷���
f_start=0.3e+0;f_end=0.3e+4;nT2=30;  
T2min=0.3;T2max=3000;
for i=1:nT2
    T2(i)=T2min*(T2max/T2min)^((i-1)/(nT2-1));
end
TE=0.9;%ms
TWA=6.0;
T1=3.0; % water 1-500��oil 3000-4000��gas��4000-5000����  
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
%%�Ŵ��㷨%%


ss=waitbar(0,'��ѭ��');
global bounds
global Numv        %�Ż����������� ÿ������������ͬ���ȵĶ����Ʊ���
global badvalue
for sd=1:1 %���
    tic
     fx=fy(sd,:);
    d=dm(sd,1:100);
Numv=6;              %������Ϊ��άgriewangk�������Ż�����4��
popsize=80;          %���ó�ʼ������Ⱥ���С
chromlength=Numv*15; %�ַ������ȣ����峤�ȣ���Ⱦɫ�峤��
eranum=80;     %������Ⱥ������һ��ȡ20��100
pc=0.90;         %���ý�����ʣ������н�������Ƕ�ֵ���������ñ仯�Ľ�����ʿ��ñ��ʽ��ʾ�����дһ��
                %������ʺ�����������������ѵ���õ���ֵ��Ϊ�������
pm=0.1;         %���ñ�����ʣ�ͬ��Ҳ������Ϊ�仯��
badvalue=300;   %�������ֵ   
bestvalue=badvalue; 
 bounds=[0.1 1;400 600;2000 4000;400 600;400 600;9 20];                 %�Ա���������
pop=initpop(popsize,chromlength);   %���г�ʼ�����������������ʼȺ��
pmutation=pm;
average=10;
trace=[bestvalue];
hh=waitbar(0,'Сѭ��');
for i=1:eranum    %����
 t1=clock;    
  
  totalobj=0;
sol=decode_multiv(pop);                   %��popÿ��ת����ʮ������

[px,py] = size(sol);
for r=1:px  %δ֪��
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


objvalue= eval;                   %����Ŀ�꺯��ֵ

totalobj=sum(objvalue);
averageobj=totalobj/size(objvalue,1);    %����Ŀ�꺯��ƽ��ֵ
   
   
   
   average(i)=averageobj;   %��¼ÿ��ƽ��Ŀ��ֵ
   fitvalue=calfitvalue(objvalue);     %����Ⱥ����ÿ���������Ӧ��
   [newpop]=selection(pop,fitvalue);   %����
   [newpop]=crossover_multiv(newpop,pc);      %����
   [newpop]=mutation_multiv(newpop,pmutation);       %����
   pmutation=pm+(i^4)*(0.6-pm)/(eranum^4);    %������Ⱥ���Ͻ����������������
   [bestindividual,bestobj]=best(pop,fitvalue);   %���Ⱥ������Ӧֵ���ĸ��弰����Ӧֵ
   y(i)=bestobj;
   if y(i)<bestvalue                              %��������Ϊֹ���ŵĸ��弰����Ӧֵ
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
    str=['����ڵ���,��Լ����Ҫ',str_t_h,':',str_t_mn,':',str_t_s,'   �ٷֱȣ�',num2str(i/eranum*100),'%'];
    waitbar(i/eranum,hh,str);
    
end
close(hh);
  plot(trace(:,1))
   title('��Ӧ������','fontsize',12);

bestbo(:,sd)=bestvalue;
zhui(:,sd)=bestind;
str2=['��',num2str(sd),'��'];
waitbar(sd/1000,ss,str2);
toc
end
bestbo
zhui
