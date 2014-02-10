//
//  Polynomials.c
//  Classifier
//
//  Created by Christian Burnham on 10/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#include "Polynomials.h"
#include <stdio.h>
#include "math.h"

void hermite(double x, double* hpoly,int max)
{
    //returns the hermite polynomials H_n(x)
    hpoly[0]=1.;
    if(max>1) hpoly[1]=2.*x;
    
    for(int i=2;i<max;i++){
        hpoly[i]=2.*x*hpoly[i-1]-2.*(i-1)*hpoly[i-2];
    }
}

void laguerre(double x,double *lpoly, double alpha, int max)
{
    //returns the generalized Laguerre polynomials L_n(alpha)(x)
    lpoly[0]=1.;
    if(max>1) lpoly[1]=-x+alpha+1.;
    
    for(int i=2;i<max;i++){
        lpoly[i]=(2.+(alpha-1.-x)/(double) i)*lpoly[i-1]
        -((1.+(alpha-1.)/(double) i)*lpoly[i-2]);
    }
    
}


