//
//  Cmath.h
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#ifndef Classifier_Cmath_h
#define Classifier_Cmath_h


void seperableBasis(double x,double y,double sigma, int m, int n, double* b_real, double* b_imag);
double factrl(int n);
double gammln(double xx);
void getCoefficients(int picWidth, int picHeight, double xCenter, double yCenter, unsigned char* greyPicData,
                     double *coeff,double sigma,double* norm,int n_max);
unsigned char* getFittedImage(int picWidth, int picHeight,int n_max,
                              double xCenter, double yCenter, double sigma, double* coeff, double norm);


#endif
