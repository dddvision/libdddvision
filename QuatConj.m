function qc=QuatConj(q)
%Copyright David D. Diel as of the most recent modification date.
%Permission is hereby granted to the following entities
%for unlimited use and modification of this document:
%  University of Central Florida
%  Massachusetts Institute of Technology
%  Draper Laboratory
%  Scientific Systems Company

if size(q,1)~=4
  warning('input argument should be quaternion (4-by-N)');
end

qc=[q(1,:);-q(2,:);-q(3,:);-q(4,:)];

return
