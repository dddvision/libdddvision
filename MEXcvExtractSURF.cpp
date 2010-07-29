//#include <tchar.h>
#include "cv.h"
#include "cxcore.h"
#include "highgui.h"
#include "mex.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  double* mImage;
  int M;
  int N;
  int m;
  int n;

  CvSeq *keypointSequence;
  CvSeq *descriptorSequence;
  CvSeqReader keypointReader;
  CvSeqReader descriptorReader;
  CvSURFPoint *keypoint;
  CvSURFParams parameters;
  CvMemStorage* storage;

  mImage = static_cast<double*>(mxGetData(prhs[0]));
  M = mxGetM(prhs[0]);
  N = mxGetN(prhs[0]);
  parameters = cvSURFParams(0);
  parameters.extended = 1;
  parameters.hessianThreshold = mxGetDouble(prhs[1]);
  parameters.numOctaves = static_cast<int>(floor(mxGetDouble(prhs[2])));
  parameters.nOctaveLayers = static_cast<int>(floor(mxGetDouble(prhs[3])));

  IplImage* cImage = cvCreateImage(cvSize(N,M),IPL_DEPTH_8U,1);

  for( m=0 ; m<M ; ++m )
  {
    for( n=0 ; n<N ; ++n )
    {
      cImage->imageData[m*(cImage->widthStep)+n]=static_cast<IPL_DEPTH_8U>(floor(mImage[n*M+m]));
    }
  }
  
  storage = cvCreateMemStorage(0);
  cvExtractSURF(cImage, NULL, &keypointSequence, &descriptorSequence, storage, parameters);

  cvStartReadSeq(descriptorSequence, &descriptorReader, 0);
  cvStartReadSeq(keypointSequence, &keypointReader, 0);

  cvReleaseMemStorage(&storage);
  cvReleaseImage(&cImage);

  return;
}
