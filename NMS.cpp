/*************************************************************************/
/* Non-Maximum Supression		                                 */
/*                                                                       */
/* C.Premebida and L.Garrote: June/2014                                  */
/* http://webmail.isr.uc.pt/~cpremebida/IROS14/LaserVisionFusion.html    */
/*                                                                       */
/*                                                                       */
/*                                                                       */
/*                                                                       */
/* All rights reserved.                                                  */
/*************************************************************************/

#include <iostream>
#include <math.h>
#include "mex.h"
#include "matrix.h"
#include <algorithm>
#include <vector>


using namespace std;

extern void _main();

void mexFunction(
        int          nlhs,
        mxArray      *plhs[],
        int          nrhs,
        const mxArray *prhs[]
        )
{
    double       *boxes;
    
    //mxArray *output;
    double *doutput;
    
    /* Check for proper number of arguments */
    
    if (nrhs != 2) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargin",
                "MEXCPP requires three input arguments.");
    } else if (nlhs >= 2) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "MEXCPP requires 1 output argument.");
    }
    
    double *overlap;
    overlap= (double *) mxGetPr(prhs[1]);
    
    boxes=(double *) mxGetPr(prhs[0]);
    
    const int *dims;
    int numdims;
    
    dims = mxGetDimensions(prhs[0]);
    numdims = mxGetNumberOfDimensions(prhs[0]);
    int dimy = (int)dims[0];
    int dimx = (int)dims[1];
        
    
    std::vector<int> pick;
    if (dimx==0 || dimy==0){
//
    }else{

        std::vector<int> I;
        for(int i=0;i<dimy;i++){
            
            I.push_back(((int)boxes[4*dimy+i]-1) );
        }   
        
//
        while (!I.empty()){
            int last = (int)(I.size())-1; //
            int i = I[last];
            pick.push_back(i);
            std::vector<int> suppress;
            suppress.push_back(last);
            for (int pos = 0; pos<=(last-1);pos++){
                int j = I[pos];                
                double xx1 = (double)max(boxes[0*dimy+i], boxes[0*dimy+j]);
                double yy1 = (double)max(boxes[1*dimy+i], boxes[1*dimy+j]);
                double xx2 = (double)min(boxes[2*dimy+i], boxes[2*dimy+j]);
                double yy2 = (double)min(boxes[3*dimy+i], boxes[3*dimy+j]);
                double w = xx2-xx1;
                double h = yy2-yy1;
                
                if (w > 0 && h > 0){
// compute overlap
                    double area1 = ((boxes[2*dimy+j]-boxes[0*dimy+j]) * (boxes[3*dimy+j]-boxes[1*dimy+j]));
                    double area2 = ((boxes[2*dimy+i]-boxes[0*dimy+i]) * (boxes[3*dimy+i]-boxes[1*dimy+i]));
                    double Int_a = (w)*(h);
                    double o = Int_a / (area1 + area2 - Int_a);
                    //mexPrintf("area =%f o = %f\n",w*h,o);
                    if (o > overlap[0]){
                        suppress.push_back(pos);
                    }
                }
            }

            std::sort(suppress.begin(), suppress.end(), std::greater<int>());
            for(int k=0;k<suppress.size();k++){
                   I.erase(I.begin()+suppress[k]);
                    
            }
            suppress.clear();           
        }
    }
    
//
    unsigned int pmax=pick.size();
    plhs[0]= mxCreateDoubleMatrix(pmax,1,mxREAL);
    
    doutput = mxGetPr(plhs[0]);
    
    for(unsigned int i=0;i<pmax;i++)
    {
        doutput[i]=pick[i]+1;
    }
    
    return;
}
