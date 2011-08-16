function x = refinePeaks(fk, k)
  y1 = fk(k-1);
  y2 = fk(k);
  y3 = fk(k+1);
  dx = (y1-y3)./(2*(y1-2*y2+y3));
  x = k(:)+dx(:);
end
