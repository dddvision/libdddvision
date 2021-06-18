// Copyright 2006 David D. Diel, MIT License
#include "mex.h"

#include "opencv/cv.h"
#include "opencv/cxcore.h"
#include "opencv/highgui.h"
#include "opencv/cvaux.h"

// #define NEXT_ELEMENT( elem_size, reader )                 \
// {                                                             \
//     if( ((reader).ptr += (elem_size)) >= (reader).block_max ) \
//     {                                                         \
//         cvChangeSeqBlock( &(reader), 1 );                     \
//     }                                                         \
// }

// #define READ_ELEMENT( elem, reader )                       \
// {                                                              \
//     assert( (reader).seq->elem_size == sizeof(elem));          \
//     memcpy( &(elem), (reader).ptr, sizeof((elem)));            \
// }

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
  // TODO: check sizes and types of other input parameters

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

//   matrix<double> mxpoints(2, n);
//   matrix<float> mxdescr(length, n);
//   matrix<signed char> mxsign(1, n);
//   matrix<float> mxinfo(3, n);
// 
//   if(keypointSequence->total > 0)
//   {
//     cvStartReadSeq(descriptorSequence, &descriptorReader, 0);
//     cvStartReadSeq(keypointSequence, &keypointReader, 0);
// 
//       for(int i = 0; i < keypointSequence->total; i++ ) {
//           const CvSURFPoint* kp = (const CvSURFPoint*)keypointReader.ptr;
//           const float* mvec = (const float*)descriptorReader.ptr;
//           NEXT_ELEMENT( keypointReader.seq->elem_size, keypointReader );
//           NEXT_ELEMENT( descriptorReader.seq->elem_size, descriptorReader );
// 
//           mxpoints(0,i) = kp->pt.x;
//           mxpoints(1,i) = kp->pt.y;
// 
//           mxsign(0,i) = kp->laplacian;
// 
//           mxinfo(0,i) = kp->size;
//           mxinfo(1,i) = kp->hessian;
//           mxinfo(2,i) = kp->dir;
// 
//           for (int j=0;j<length;++j) {
//               mxdescr(j,i) = mvec[j];
//           }
//       }
//   }
// 
//   if (nlhs >= 1) {
//       plhs[0] = mxpoints;
//   }
//   if (nlhs >= 2) {
//       plhs[1] = mxdescr;
//   }
//   if (nlhs >= 3) {
//       plhs[2] = mxsign;
//   }
//   if (nlhs >= 4) {
//       plhs[3] = mxinfo;
//   }

  cvReleaseMemStorage(&storage);
  cvReleaseImage(&cImage);

  return;
}
