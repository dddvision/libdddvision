function []=hf_view(HF)
% Copyright 2006 David D. Diel, MIT License

	surf(HF)
	shading flat
	NC=2^16-1;
	graymap=[(1:NC)',(1:NC)',(1:NC)']/NC;
	colormap(graymap);

return