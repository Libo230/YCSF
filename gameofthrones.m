
function fx=gameofthrones(xn,t,t_n,f,f_n)
px=xn';
for i=1:t_n    
    for j=1:f_n        
       A(i,j)=exp(-(t(i)./f(j)));            
    end        
end
[U,S,V]=svd(A);
s=diag(S);
% vn=evar(xn);
% snr=10*log10(216.675/vn);
fx=inv(A'*A+2*eye(f_n))*A'*px;
fx=max(0,fx);
display('completed !');
%%-----------------------------------------%%



