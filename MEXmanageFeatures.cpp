// Copyright 2006 David D. Diel, MIT License
#include <malloc.h>
#include <math.h>
#include <stdio.h>
#include <memory.h>

#include "mex.h"


/*** helper function prototypes ***/
signed char manageFeatures(unsigned char*,double,double,double,int,int);


/*
MATLAB function [outmask,status]=MEXmanageFeatures(mask,x,y,r)
% coordinates are defined in sub-element matrix notation
%
% ARGUMENTS:
% mask = UInt8 array that defines acceptable regions by its non-zero elements (m-by-n)
% x,y = sub-pixel feature positions, skipped if NaN (K-by-1) or (1-by-K)
% r = the number of pixels to occupy around each feature (1-by-1)
%
% RETURNS:
% outmask = UInt8 mask showing open regions where new features could be found (m-by-n)
% status = Int8 returns a code, defined as follows:
%   -2 = dead / feature overlap
%   -1 = dead / lost in tracking
%    1 = alive / inactive
*/
void mexFunction( int nlhs,       mxArray *plhs[],
		        		  int nrhs, const mxArray *prhs[] )
{
  int cnt,m,n,k,K;
  double *x,*y;
  double r;
  unsigned char *mask,*outmask;
  signed char *status;
  int outdims[2];

  /* check for proper number of inputs */
  if(nrhs != 4)
  {
    mexErrMsgTxt("Usage [status,outmask]=MEXmanageFeatures(mask,x,y,r)");
  }
  else if(nlhs > 2)
	{
    mexErrMsgTxt("Too many output arguments");
  }

  /* the inputs must be of the correct type */
  if( mxIsComplex(prhs[0]) || !mxIsUint8(prhs[0]) )
  {
    mexErrMsgTxt("First argument must be noncomplex Uint8");
  }
  for(cnt=1;cnt<4;cnt++)
  {
	  if( mxIsComplex(prhs[cnt]) || !mxIsDouble(prhs[cnt]) )
    {
      mexErrMsgTxt("Last three arguments must be noncomplex double");
    }
  }
  
  /* extract array sizes */
  m=mxGetM(prhs[0]);
  n=mxGetN(prhs[0]);

  /* check list lengths */
	if( (mxGetM(prhs[3])!=1) || (mxGetN(prhs[3])!=1) )
  {
    mexErrMsgTxt("Argument dimensions are incorrect");
  }

  k=mxGetM(prhs[1]);
  K=mxGetN(prhs[1]);

	if( (mxGetM(prhs[2])!=k) || (mxGetN(prhs[2])!=K) )
  {  
    mexErrMsgTxt("Coordinate lists must be the same size.");
  }

  mask=(unsigned char*)mxGetData(prhs[0]);
  x=(double*)mxGetData(prhs[1]);
  y=(double*)mxGetData(prhs[2]);
  r=*(double*)mxGetData(prhs[3]);

  /* allocate memory for return arguments and assign pointers */
  outdims[0]=m;
  outdims[1]=n;
  plhs[0]=mxCreateNumericArray(2,outdims,mxUINT8_CLASS, mxREAL);
  outmask=(unsigned char*)mxGetData(plhs[0]);

  outdims[0]=k;
  outdims[1]=K;
  plhs[1]=mxCreateNumericArray(2,outdims,mxINT8_CLASS, mxREAL);
  status=(signed char*)mxGetData(plhs[1]);

  /* make output mask a copy of the input mask */
  memcpy(outmask,mask,m*n);

  /* deal with empty list case */
  if((k==0)||(K==0))
    {return;}

  if(k>K) {K=k;}

  /* for each feature */
  for(k=0;k<K;k++)
  {
    /* call the function to do the work, and change Matlab indices to C convention */
    status[k]=manageFeatures(outmask,x[k]-1.0,y[k]-1.0,r,m,n);
  }

  return;
}


/* management by greedy territory occupancy */
signed char manageFeatures(unsigned char *mask, double x, double y, double r, int m, int n)
{
  int xf,yf,rf;
  int xfm,xfp,yfm,yfp;
  int i,j;

  /* checking NaN */
  if( mxIsNaN(x) || mxIsNaN(y) )
    {return -1;}    

  xf=(int)floor(x+0.5);
  yf=(int)floor(y+0.5);
  rf=(int)floor(r+0.5);

  xfm=xf-rf;
  xfp=xf+rf;
  yfm=yf-rf;
  yfp=yf+rf;

  /* check bounds */
  if( !( (xfm>=0) && (yfm>=0) && (xfp<m) && (yfp<n) ) )
    {return -1;}
  
  /* check for previous mask */
  if(mask[xf+yf*m]==0)
    {return -2;}

  /* fill territory */
  for(j=yfm;j<=yfp;j++)
  {
    for(i=xfm;i<=xfp;i++)
    {
      mask[i+j*m]=0;
    }
  }

  return 1;
}