function []=hf_view(HF)

	surf(HF)
	shading flat
	NC=2^16-1;
	graymap=[(1:NC)',(1:NC)',(1:NC)']/NC;
	colormap(graymap);

return