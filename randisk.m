% Generate n uniform random samples over a disk of radius r
% 
% INPUT
% n = number of samples to generate
% r = radius of the disk
% 
% OUTPUT
% sample = points within the disk, 2-by-n
% Public Domain
function samp=randisk(n,r)
% sample from a uniform distribution over a disk in polar coordinates
rsamp=r*sqrt(rand(1,n));
thetasamp=2*pi*rand(1,n);

% convert samples to rectangular coordinates
samp=[rsamp.*cos(thetasamp);rsamp.*sin(thetasamp)];
end

