function newpop=decode_multiv(pop)
global bounds
global Numv  
[px,py]=size(pop);     m1=py/Numv;
for i=1:Numv
    Minx=bounds(i,1);
    Maxx=bounds(i,2);
    m=py/Numv;
    pop1=pop(:,m*(i-1)+1:m*i);     %ȡ����Ӧ������Ӧ�Ķ����Ʊ����
    for j=1:m
        pop2(:,j)=2.^(m-1).*pop1(:,j);   %����Ȩ��
        m=m-1;
    end
    pop3=Minx+sum(pop2,2)*(Maxx-Minx)/(2^m1-1);
    newpop(:,i)=pop3;
end