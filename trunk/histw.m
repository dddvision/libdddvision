% Similar to histc, but increments each bin by each element weight
%
% INPUTS
% x = data points
% w = weights
% edge = histogram bin boundaries
%
% OUTPUTS
% h = weighted histogram values
% bin = data-to-bin index
function [h,bin]=histw(x,w,edge)
[cnt,bin]=histc(x,edge);
N=numel(edge);
bin(bin==0)=N;
h=zeros(1,N);
for b=1:numel(w)
  bb=bin(b);
  h(bb)=h(bb)+w(b);
end
end
