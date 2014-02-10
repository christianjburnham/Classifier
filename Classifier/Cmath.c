//
//  Cmath.c
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#include <stdio.h>
#import "Cmath.h"
#import "math.h"
#import "Polynomials.h"
double pi = 3.141592653589793;
double sqrtTwo = 1.414213562373095;


void seperableBasis(double x,double y,double sigma, int m, int n, double* b_real, double* b_imag){
    
    
    double r=sqrtf(x*x+y*y)/sigma;
    double mabs=fabs((double) m);
    double pow=powf(r,mabs);
    double lpoly[n+1];
    double r2=r*r;
    double efac=exp(-r*r/2.);
    laguerre(r2, lpoly, (double) mabs, n+1);
    double phi=atan2(y, x);
    double fac=sqrt(factrl(n)/(pi*factrl(mabs+n)))/sigma;
    double a_real;
    
    if(m>0){a_real = sqrtTwo*pow*cos((double)m*phi)*fac;}
    else if(m<0){a_real = sqrtTwo*pow*sin((double)m*phi)*fac;}
    else{a_real = pow*fac;}
    
    *b_real=efac*lpoly[n]*a_real;
    *b_imag = 0.;
    
}

double factrl(int n)
{
	static int ntop=4;
	static double a[33]={1.0,1.0,2.0,6.0,24.0};
	int j;
    
	if (n > 32) return exp(gammln(n+1.0));
	while (ntop<n) {
		j=ntop++;
		a[ntop]=a[j]*ntop;
	}
	return a[n];
}

double gammln(double xx)
{
	double x,y,tmp,ser;
	static double cof[6]={76.18009172947146,-86.50532032941677,
		24.01409824083091,-1.231739572450155,
		0.1208650973866179e-2,-0.5395239384953e-5};
	int j;
    
	y=x=xx;
	tmp=x+5.5;
	tmp -= (x+0.5)*log(tmp);
	ser=1.000000000190015;
	for (j=0;j<=5;j++) ser += cof[j]/++y;
	return -tmp+log(2.5066282746310005*ser/x);
}

void getCoefficients(int picWidth, int picHeight, double xCenter, double yCenter, unsigned char* greyPicData,
                     double *coeff,double sigma, double* norm,int n_max){
    // this function evaluates the coefficients in the exapansion
    
    
    double deltaX = 1./picWidth;
    double deltaY = 1./picHeight;

    double sum = 0;
    int pixel =0;
    for (int y = 0; y < picHeight; y++) {
        for (int x = 0; x < picWidth; x++) {
            
            sum = sum + greyPicData[pixel]*greyPicData[pixel]*deltaX*deltaY;
            pixel+=1;
            
        }
    }
    *norm = sqrt(sum);
    *norm = 1.;
    
    double ssum = 0.;
    
    
    int i = 0;
    for(int n = 0; n<n_max;n++){
        for(int m = -n; m <= n; m++){
            sum = 0;
            int pixel =0;
            for (int y = 0; y < picHeight; y++) {
                for (int x = 0; x < picWidth; x++) {
                    
                    
                    double xf = x*deltaX;
                    double yf = 1.-y*deltaY;
                    
                    double b_real,b_imag;
                    
                    //only calculate the Gauss-Laguerre circular harmonics if the pixel value has a non-zero intensity.
                    if(greyPicData[pixel]>0){
                    
                    seperableBasis(xf-xCenter,yf-yCenter,sigma, m, n, &b_real, &b_imag);
                    }else{
                        b_real = 0;
                    }
                        sum = sum + (b_real*greyPicData[pixel])*deltaX*deltaY;
                    pixel+=1;
                    
                }
            }
            
            sum = sum/ *norm;
            coeff[i] = sum;
            
            ssum = ssum+coeff[i]*coeff[i];
            i++;
        }
    }
//    printf("Ssum = %f\n",ssum);
}

unsigned char* getFittedImage(int picWidth, int picHeight,int n_max,
                              double xCenter, double yCenter, double sigma, double* coeff, double norm){
    
    unsigned char* fit = malloc(sizeof(unsigned char)*picWidth*picHeight);
    
    int pixel = 0;
    
    double deltaX = 1./picWidth;
    double deltaY = 1./picHeight;
    
    
    
    for (int y = 0; y < picHeight; y++) {
        for (int x = 0; x < picWidth; x++) {
            
            double func =0;
            
            double xf = x*deltaX;
            double yf = 1.-y*deltaY;
            
            double b_real,b_imag;
            
            
            int i = 0;
            for(int n = 0; n<n_max;n++){
                for(int m = -n; m <= n; m++){
                    seperableBasis(xf-xCenter,yf-yCenter,sigma, m, n, &b_real, &b_imag);
                    func = func+coeff[i]*b_real;
                    i++;
                }
            }
            func = func*norm;
            if(func<0) func = 0;
            if(func>255) func = 255;
            fit[pixel] = func;
            pixel+=1;
            
            
        }
    }
    return fit;
}




