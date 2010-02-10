% Generate a poisson random variable
%









function r=poissrnd(m,n,lambda)
% Knuth method
L=exp(-lambda);
k=zeros(m,n);
p=ones(m,n);
for j=1:(m*n)
  while(p(j)>=L)
    k(j)=k(j)+1;
    p(j)=p(j)*rand;
  end
end  
r=(k-1);
% alternate method
%   r = 0;
%   j = 1;
%   p = 0;
%   while ~isempty(j)
%     p = p - log(rand);
%     t = (p < lambda);
%     j = j(t);
%     p = p(t);
%     r(j) = r(j) + 1;
%   end
return;
