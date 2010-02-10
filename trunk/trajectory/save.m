% Save a trajectory object to a file
%









function save(this,fname)
hd.trajectory=struct(this);
save(fname,'-struct','hd','-V7.3');
return;
