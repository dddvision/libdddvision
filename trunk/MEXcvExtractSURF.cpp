#include "mex.h"

#include <opencv/cv.h>
#include <opencv/cxcore.h>
#include <opencv/highgui.h>
#include <opencv/cvaux.h>

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  double* mImage;
  int M;
  int N;
  int m;
  int n;

  IplImage* cImage;
  CvSeq *keypointSequence;
  CvSeq *descriptorSequence;
  CvSeqReader keypointReader;
  CvSeqReader descriptorReader;
  CvSURFPoint *keypoint;
  CvSURFParams parameters;
  CvMemStorage* storage;

  // TODO: check that input image is uint8 MxNx1

  mImage = static_cast<double*>(mxGetData(prhs[0]));
  M = mxGetM(prhs[0]);
  N = mxGetN(prhs[0]);

  cImage = cvCreateImage(cvSize(N,M),IPL_DEPTH_8U,1);

  for( m=0 ; m<M ; ++m )
  {
    for( n=0 ; n<N ; ++n )
    {
      cImage->imageData[m*(cImage->widthStep)+n]=mImage[n*M+m];
    }
  }

  parameters = cvSURFParams(0);
  parameters.extended = 1;
  parameters.hessianThreshold = mxGetScalar(prhs[1]);
  parameters.nOctaves = static_cast<int>(floor(mxGetScalar(prhs[2])));
  parameters.nOctaveLayers = static_cast<int>(floor(mxGetScalar(prhs[3])));
  storage = cvCreateMemStorage(0);
  cvExtractSURF(cImage, NULL, &keypointSequence, &descriptorSequence, storage, parameters);

  cvStartReadSeq(descriptorSequence, &descriptorReader, 0);
  cvStartReadSeq(keypointSequence, &keypointReader, 0);

  cvReleaseMemStorage(&storage);
  cvReleaseImage(&cImage);

  return;
}
