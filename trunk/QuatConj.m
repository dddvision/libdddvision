function q = QuatConj(q)
  if(size(q, 1)~=4)
    error('input must be 4-by-N');
  end
  q(2:4, :) = -q(2:4, :);
end
