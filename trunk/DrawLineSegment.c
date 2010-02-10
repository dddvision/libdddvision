// Draw a line segment into an array while validating array bounds.
//
// ARGUMENTS
// array = two-dimensional boolean array
// size0 = size of the array in the first dimension
// size1 = size of the array in the second dimension
// point0 = tail point of line segment
// point1 = head point of line segment
//
// RETURN VALUE
// 0 segment does not exceed array bounds
// 1 segment exceeds array bounds
//
// Copyright David D. Diel as of the most recent modification date.
// Permission is hereby granted to the following entities
// for unlimited use and modification of this document:
// University of Central Florida
// Massachusetts Institute of Technology
// Draper Laboratory
// Scientific Systems Company

int DrawLineSegment(int **array, int size0, int size1, double *point0, double *point1)
{
  int outside = 0;
  double point00=point0[0];
  double point10=point1[0];
  double point01=point0[1];
  double point11=point1[1];
  double temp;
  double slope;
  double sign;
  double offset;
  int steep;
  int point00f;
  int point10f;
  int index0;
  int index1;

  // steep means slope greater than +-45 degrees
  if( (steep = fabs(point11-point01) > fabs(point10-point00)) )
  {
    temp=point00;
    point00=point01;
    point01=temp;
    temp=point10;
    point10=point11;
    point11=temp;
  }

  // assure that dimension 0 increments positively
  if( point00 > point10 )
  {
    temp=point00;
    point00=point10;
    point10=temp;
    temp=point01;
    point01=point11;
    point11=temp;
  }
  
  slope = (point11-point01)/(point10-point00);
  if( slope>=0.0 )
  { sign = 1.0; }
  else
  { sign = -1.0; }
      
  point00f = (int)floor(point00);
  point10f = (int)floor(point10);
  index1 = (int)floor(point01);
  offset = point01-(double)index1+slope*((double)(point00f+1)-point00);

  for( index0=point00f ; index0<=point10f ; index0++ )
  {
    if( (index0<0) || (index1<0) || (index0>=size0) || (index1>=size1) ) { outside=1; break; }

    if( steep ) { array[index1][index0]=1; } else { array[index0][index1]=1; }

    if( index0==point10f ) { offset=point11-(double)index1; }
  
    if( (offset>=1.0) || (offset<0.0) )
    {
      index1=index1+(int)sign;
      offset=offset-sign;

      if( (index0<0) || (index1<0) || (index0>=size0) || (index1>=size1) ) { outside=1; break; }

      if( steep ) { array[index1][index0]=1; } else { array[index0][index1]=1; }
    }
    offset=offset+slope;
  }

  return(outside);
}
