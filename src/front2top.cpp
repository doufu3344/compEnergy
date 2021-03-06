#include "mex.h"
#include "matrix.h"
#include "stdio.h"
#include "math.h"
#include "string.h"
#define RANGE 100
#define RANGE_D 100.00
//----------------------------------------------//
// Usage: [sideview]=front2top[frontview,deep,shallow]
// project a frontal view depth image to top-view
//
// Author: Chenyang Zhang
// Date:   July 2012
//----------------------------------------------//
inline double larger(double a, double b)
	{
	return a>=b ? a : b; 
	}

inline int trans(int depMinusShallow, int shallow, int deepMinusShallow, int upMinusDown, int down){
	// scale current depth value to a proper value in [0,100]
	return (int)ceil((RANGE_D-1)*depMinusShallow/deepMinusShallow+down);
	}


void mexFunction( int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[] )
	{

	double *frontimage;
	int deep;
	int shallow;

	frontimage = mxGetPr(prhs[0]);
	double *deepPr = mxGetPr(prhs[1]);
	double *shallowPr = mxGetPr(prhs[2]);
	deep = (int)deepPr[0];
	shallow = (int)shallowPr[0];


	int height = (int)mxGetM(prhs[0]);
	int width = (int)mxGetN(prhs[0]);

	int i,j,d;
	int dep = 0;

	plhs[0] = mxCreateDoubleMatrix(width*RANGE,1,mxREAL);
	double * topview = mxGetPr(plhs[0]);
	memset(topview,0,sizeof(topview));

	for(i=0;i<height;i++){
		for(j=0;j<width;j++)
			{
			dep = (int)frontimage[i+height*j];
			if(dep>shallow)
				{
				d = trans(dep-shallow,shallow,deep-shallow,RANGE,0);
				topview[d+j*RANGE]=larger(topview[d+RANGE*j], double(i));
				}
			}
		}
	return;

	}
