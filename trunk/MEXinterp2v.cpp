/*
MEXinterp2v.cpp
bilinear array interpolation at sparse points Xi,Yi (double)
assuming matlab index 1,2,...N
usage: Zi=MEXinterp2v(Z,Xi,Yi)
*/


#include "mex.h"
#include <malloc.h>
#include <math.h>


void mexFunction( int nlhs,       mxArray *plhs[],
								 int nrhs, const mxArray *prhs[] )
{
  unsigned int m,n,mplus,mn,p,xf,yf;
  //unsigned int mminus,nminus;
  unsigned int *Xf,*Yf;
  double *Zi,*Z,*Xi,*Yi;
  double *Xr,*Yr;
  double xr,yr,a00,a01,a10,a11,b0,b1;
  double NaN=mxGetNaN();
  int i,L,Lp;
	
  /* Check for proper number of arguments. */
  if(nrhs != 3)
  {
    mexErrMsgTxt("usage: Zi=MEXinterp2v(Z,Xi,Yi)");
  }
  else if(nlhs > 1)
  {
    mexErrMsgTxt("Too many output arguments");
  }
  
  /* The inputs must be a noncomplex double.*/
  if( mxIsComplex(prhs[0]) ||
		mxIsComplex(prhs[1]) ||
		mxIsComplex(prhs[2]) ||
		!mxIsDouble(prhs[0]) ||
		!mxIsDouble(prhs[1]) ||
		!mxIsDouble(prhs[2]) )
  {
    mexErrMsgTxt("Inputs must be a noncomplex double.");
  }
	
  /* extract input information */
  m = mxGetM(prhs[0]);
  n = mxGetN(prhs[0]);
  L = mxGetM(prhs[1]);
  Z = mxGetPr(prhs[0]);
  Xi = mxGetPr(prhs[1]);
  Yi = mxGetPr(prhs[2]);
  
  /* check input vector lengths */
  if( mxGetM(prhs[2]) != L ) { mexErrMsgTxt("Input vectors must be the same size"); }
  if( (Lp=mxGetN(prhs[1]))  > L ) {L=Lp;}
  if( mxGetN(prhs[2]) != Lp ) { mexErrMsgTxt("Input vectors must be the same size"); }
	
  /* Allocate memory for return argument and assign pointer. */
  if( (L>0)&(Lp>0) )  
  {
    plhs[0] = mxCreateDoubleMatrix(1,L, mxREAL);
    Zi = mxGetPr(plhs[0]);
  }
  else
  {
    plhs[0] = mxCreateDoubleMatrix(0,0, mxREAL);
    Zi = mxGetPr(plhs[0]);
    return;
  }
	
  /* Allocate memory for intermediate variables and assign pointers. */
  Xr=(double*)malloc(L*sizeof(double));
  Yr=(double*)malloc(L*sizeof(double));
  
  Xf=(unsigned int*)malloc(L*sizeof(unsigned int));
  Yf=(unsigned int*)malloc(L*sizeof(unsigned int));
	
  /* Do the interpolation. */
  for(i=0;i<L;i++) { Xf[i]=(unsigned int)floor(Xi[i]); }
  for(i=0;i<L;i++) { Yf[i]=(unsigned int)floor(Yi[i]); }
  for(i=0;i<L;i++) { Xr[i]=Xi[i]-(double)Xf[i]; }
  for(i=0;i<L;i++) { Yr[i]=Yi[i]-(double)Yf[i]; }
	
  mplus=m+1;
  //mminus=m-1;
  //nminus=n-1;
  mn=m*n;
  for(i=0;i<L;i++)
  {
    xf=Xf[i];
		yf=Yf[i];  
		xr=Xr[i];
		yr=Yr[i];
		
		p=xf+yf*m-mplus;
		
		if( (xf>=1) && (yf>=1) && (xf<m) && (yf<n) )
		{
			a00 = Z[p];
			a01 = Z[p+m];
			a10 = Z[p+1];
			a11 = Z[p+mplus];
			
			b0 = a00*(1.0-yr) + a01*yr;
			b1 = a10*(1.0-yr) + a11*yr;
			
			Zi[i]=(b0*(1.0-xr) + b1*xr);
		}
		else
    { Zi[i]=NaN; }
  }
	
  free(Xr);
  free(Yr);
  free(Xf);
  free(Yf);
}

