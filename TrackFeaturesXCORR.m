function [ibe,jbe]=TrackFeaturesXCORR(ic,jc,zp,z,halfwin,RESIDUE_THRESH);
% Copyright 2006 David D. Diel, MIT License

K=size(ic,2);
[m,n]=size(z);
ibe=NaN*zeros(1,K);
jbe=NaN*zeros(1,K);
zhalfwin=2*halfwin+1;

%for each feature
for k=1:K
  zpk=zp(:,:,k);
  imin=ic(k)-zhalfwin;
  jmin=jc(k)-zhalfwin;
  imax=ic(k)+zhalfwin;
  jmax=jc(k)+zhalfwin;
  
  if (imin>=1)&(jmin>=1)&(imax<=m)&(jmax<=n)
    %density=xcorr2(zpk,z(imin:imax,jmin:jmax)); %not normalized
    density=normxcorr2(zpk,z(imin:imax,jmin:jmax)); %normalized
    density=density((halfwin+1):(end-halfwin),(halfwin+1):(end-halfwin));
    hot=max(density(:));
    [iphot,jphot]=find(density==hot);
    ihot=ic(k)+iphot-zhalfwin-1;
    jhot=jc(k)+jphot-zhalfwin-1;
    
    %take care of multiple peaks
    N=length(ihot);
    if N>1
      r=sqrt((ihot-ic(k)).^2+(jhot-jc(k)).^2)+0.001*rand(size(ihot));
      [rval,rind]=sort(r);
      ihot=ihot(rind);
      jhot=jhot(rind);
    end
    
    %do a final residue check
    if (hot>RESIDUE_THRESH)
      ibe(k)=ihot;
      jbe(k)=jhot;
    end
  end
end

return