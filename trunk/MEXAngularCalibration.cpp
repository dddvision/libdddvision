#include <stdlib.h>
#include <math.h>
#include <stdio.h>

#include "mex.h"
#include "AngularCalibration.h"

#include "AngularCalibration.cpp"

/*
  Matlab syntax
  [c1,c2,c3]=MEXAngularCalibration(a,y1c,y2c,m,n);
  a = list of 8 parameters (axis 1+,axis 2+,axis 1-,axis 2-)
  y1c = pixel coordinate of axis 1 center
  y2c = pixel coordinate of axis 2 center
  m = image height
  n = image width
*/

void mexFunction( int nlhs,       mxArray *plhs[],
				  int nrhs, const mxArray *prhs[] )
{
  double *c1,*c2,*c3,*a;
  double y1c,y2c,m,n;

  /* Check for proper number of arguments. */
  if(nrhs != 5)
  {
    mexErrMsgTxt("usage: [c1,c2,c3]=MEXAngularCalibration(a,y1c,y2c,m,n)");
  }
  else if(nlhs > 3)
  {
    mexErrMsgTxt("Too many output arguments");
  }
  
  /* The inputs must be a noncomplex double.*/
  if( mxIsComplex(prhs[0]) ||
	  mxIsComplex(prhs[1]) ||
	  mxIsComplex(prhs[2]) ||
	  mxIsComplex(prhs[3]) ||
	  mxIsComplex(prhs[4]) ||
	  !mxIsDouble(prhs[0]) ||
	  !mxIsDouble(prhs[1]) ||
	  !mxIsDouble(prhs[2]) ||
	  !mxIsDouble(prhs[3]) ||
	  !mxIsDouble(prhs[4]) )
  {
    mexErrMsgTxt("Inputs must be a noncomplex double.");
  }

  /* check input vector lengths */
  if( !((mxGetM(prhs[0]) == 12) || (mxGetN(prhs[0]) == 12)) ) { mexErrMsgTxt("Parameter vector must have 12 elements"); }
  
  /* extract input information */
  a = mxGetPr(prhs[0]);
  y1c = *mxGetPr(prhs[1]);
  y2c = *mxGetPr(prhs[2]);
  m = *mxGetPr(prhs[3]);
  n = *mxGetPr(prhs[4]);

  /* Allocate memory for return argument and assign pointer. */
  plhs[0] = mxCreateDoubleMatrix(m,n, mxREAL);
  plhs[1] = mxCreateDoubleMatrix(m,n, mxREAL);
  plhs[2] = mxCreateDoubleMatrix(m,n, mxREAL);
  c1 = mxGetPr(plhs[0]);
  c2 = mxGetPr(plhs[1]);
  c3 = mxGetPr(plhs[2]);

  /* change Matlab indices to C convention */
  y1c--;
  y2c--;

  /* call the function to do the work */
  AngularCalibration(c1,c2,c3,a,y1c,y2c,(int)m,(int)n);
}

