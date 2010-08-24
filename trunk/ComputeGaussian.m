function g = ComputeGaussian(xCen, yCen, K, sizeX, sizeY)

g = zeros(sizeX, sizeY);

invK = inv(K);

xCor = [1:sizeX]' * ones(1,sizeY); 
yCor = [[1:sizeY]' * ones(1,sizeX)]';

x = xCor - xCen;
y = yCor - yCen;

g = (1/((2*pi)*det(K)^.5)) * exp(-0.5* (invK(1,1)*x.^2 + (invK(1,2)+invK(2,1))*x.*y + invK(2,2)*y.^2));

%since the gaussians are only for visual purposes, they are scaled such
%that instead of the area under the curve being 1, their max height is 1

%g = g/max(max(g));
end