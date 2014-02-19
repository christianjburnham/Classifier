//
//  Model.m
//  Classifier
//
//  Created by Christian Burnham on 07/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "Model.h"
#import "Cmath.h"
#include <time.h>
#include "fann.h"
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>



@implementation Model

-(id) init{

    
    _coefficientsDictionary = [NSMutableDictionary dictionary];
    _errorDictionary = [NSMutableDictionary dictionary];
    _validateArray = [NSMutableArray array];
    

    _training = 1;
    
    _trainingModel = 0;

    _invariant = 1;
    
    _inverse = 1;
    

    
//default parameters
    
    _n_max = 10;
    
    _nValidate = 20;
    
    _validated = 0;
    
    _nCluster = 1;

    _picWidthMax = 512;
    _picHeightMax = 512;
    
    _fitPicWidthMax=512;
    _fitPicHeightMax=512;
    
    _nHiddenNoRot = 67;
    _nHiddenRot = 63;
    _errorMaxNoRot = 0.00042;
    _errorMaxRot = 0.0028;
    _nInputNoRot = 0;
    _nInputRot = 0;
    _nOutputNoRot = 0;
    _nOutputRot = 0;
    

    _databaseName = @"untitled";
    
    _belongsToCluster = malloc(sizeof(int)*_picWidthMax*_picHeightMax);


    return self;
}

-(void) awakeFromNib{
    [self changeModelName];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateNClusterText"
     object:self];

}


-(void) calculate{
//  This subroutine performs an expansion in Gauss Laguerre Circular Harmonics, constructs the finite expansion approximation to the image and also calls the neural network or nearest neighbor classifiers.
    
    
    
// calculate origin and principle axes
    findAxes(_greyPicData, _picWidth, _picHeight,&_xCenter,&_yCenter,
             &_xx, &_xy, &_yx, &_yy, &_xvar, &_yvar);

    
    float sigma = sqrt((_xvar+_yvar)/2.);
    double coeff[_n_max*_n_max];
    double norm;

    
    NSDate *start = [NSDate date];
    getCoefficients(_picWidth, _picHeight, _xCenter, _yCenter, _greyPicData,coeff,sigma,&norm,_n_max);

    [self calculateErrors:coeff];
    NSDate *stop = [NSDate date];
    NSTimeInterval duration = [stop timeIntervalSinceDate:start];
//    NSLog(@"elapsed time = %f",duration);
    
    //now construct the image from the coefficients
    _fit = getFittedImage(_fitPicWidth, _fitPicHeight, _n_max, _xCenter, _yCenter, sigma, coeff, norm);

    
    //make an NSarray containing coeffs
    

        
    if(_training == 1){
    
        NSMutableArray* coeffArray = [NSMutableArray array];
        int i = 0;
        for(int n = 0; n<_n_max;n++){
            for(int m = -n; m <= n; m++){
                //            printf("%i %i %f\n",n,m,coeff[i]);
                [coeffArray addObject:[NSNumber numberWithDouble:coeff[i]]];
                i++;
            }
        }
        
    //save the coefficients to the dictionary
    //note, each value in dictionary is a NSMutableArray, with each element of the array
    //holding an NSMutableArray of the coefficients.
    
    
    NSMutableArray* array2;
    if([_coefficientsDictionary objectForKey:_patternName]){
        //if key already exists
        array2 = [_coefficientsDictionary valueForKey:_patternName];
    }else{
        array2 = [NSMutableArray array];
    }
        [array2 addObject:coeffArray];
        [_coefficientsDictionary setValue:array2 forKey:_patternName];
    
    }//If(_training == 1)
    


    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"redrawFitView"
     object:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateErrorTable"
     object:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateBestClassLabel"
     object:self];
    
    
}//-(void) calculate

-(void) calculateErrors: (double*) coeff{
//Find the rankings using either the neural network or nearest neighbor classifiers.

    if(_trainingModel == 0){
        [self calculateErrorsForNearestNeighbor:coeff];
    } else if(_trainingModel == 1){
        [self calculateErrorsForNeuralNet:coeff];
    }//if(_trainingModel == 1)
    
    //find the name with the least error
    double errorMin = 9999.;

    for(id key in _errorDictionary){
        double err =[[_errorDictionary valueForKey:key] doubleValue];
        if(_trainingModel == 1) err = -err;
        if(err<errorMin){
            _bestClass = key;
            errorMin = err;
        }
    }
    

    

}//-(void) calculateErrors: (double*) coeff


-(void) calculateErrorsForNearestNeighbor: (double*) coeff{
//calculate the rankings for the nearest neighbor classifier
    
    if(_invariant == 1){
        [self calculateErrorsForNearestNeighborWithRotationalInvariance:coeff];
    }else if (_invariant == 0){
        [self calculateErrorsForNearestNeighborWithNoRotationalInvariance:coeff];
     }
 
}//-(void) calculateErrorsForNearestNeighbor: (double*) coeff


-(void) calculateErrorsForNearestNeighborWithRotationalInvariance: (double*) coeff{
    //  calculates rankings for nearest neighbor classifier for rotationally invariant patterns

    _errorDictionary = [NSMutableDictionary dictionary];
    
    double c2[_n_max][_n_max];
    double dot[_n_max][_n_max];
    double cPlus[_n_max][_n_max],cMinus[_n_max][_n_max];
    int i = 0;
    for(int n = 0; n<_n_max; n++){
        for(int m = -n; m<=n; m++){
            double c = coeff[i];
            if(m>0) cPlus[n][m] = c;
            if(m<0) cMinus[n][-m] = c;
            
            if(m==0) {
                c2[n][m] = c*c;
            } else if(m>0) {
                if(m!=n)dot[n][m] = cPlus[n][m]*cPlus[m][m]+cMinus[n][m]*cMinus[m][m];
                c2[n][m] = cPlus[n][m]*cPlus[n][m] + cMinus[n][m]* cMinus[n][m];
            }
            
            i++;
        }
    }
    
    
    double testC2[_n_max][_n_max];
    double testDot[_n_max][_n_max];
    double testCPlus[_n_max][_n_max],testCMinus[_n_max][_n_max];
    
    
    for(id key in _coefficientsDictionary){
        NSMutableArray* coeffArray = [_coefficientsDictionary objectForKey:key];
        
        double e2,error;
        int nsample = 0;
        error = 0;
        
        for(id testCoeff in coeffArray){
            
            nsample++;
            
            int i = 0;
            for(int n = 0; n<_n_max; n++){
                for(int m = -n; m<=n; m++){
                    double c = [testCoeff[i] doubleValue];
                    if(m>0) testCPlus[n][m] = c;
                    if(m<0) testCMinus[n][-m] = c;
                    if(m==0) {
                        testC2[n][m] = c*c;
                    } else if(m>0) {
                        if(m!=n) testDot[n][m] = testCPlus[n][m]*testCPlus[m][m]+testCMinus[n][m]*testCMinus[m][m];
                        testC2[n][m] = testCPlus[n][m]*testCPlus[n][m] + testCMinus[n][m]* testCMinus[n][m];
                    }
                    
                    i++;
                }//for(int m = -n; m<=n; m++)
            }//for(int n = 0; n<_n_max; n++)
            
            e2 = 0;
            for(int n = 0; n<_n_max; n++){
                for(int m = 0; m<=n; m++){
                    double c2dif = c2[n][m]/c2[0][0] - testC2[n][m]/testC2[0][0];
                    e2 += c2dif*c2dif;
                    if(m>0 && m!=n) {
                        
                        double dotDif = dot[n][m]/c2[0][0]-testDot[n][m]/testC2[0][0];
                        e2 += dotDif*dotDif;
                    }
                }
            }
            error += 1./(e2);
        }//for(id testCoeff in coeffArray)
        
        error = 1./sqrt(error / (double) nsample);
        
        //store error in error dictionary
        NSNumber* errorNS = [NSNumber numberWithDouble:error];
        [_errorDictionary setValue:errorNS forKey:key];
        
    }// for(id key in dictionary)
}//-(void) calculateErrorsForNearestNeighborWithRotationalInvariance: (double*) coeff

-(void) calculateErrorsForNearestNeighborWithNoRotationalInvariance: (double*) coeff{

    //  calculates rankings for nearest neighbor classifier for non-rotationally invariant patterns
    _errorDictionary = [NSMutableDictionary dictionary];
    
    double cPlus[_n_max][_n_max],cMinus[_n_max][_n_max],c0[_n_max];

    int i = 0;
    for(int n = 0; n<_n_max; n++){
        for(int m = -n; m<=n; m++){
            double c = coeff[i];
            if(m>0) cPlus[n][m] = c;
            if(m<0) cMinus[n][-m] = c;
            if(m==0) c0[n] = c;
            i++;
        }
    }
    
    double testCPlus[_n_max][_n_max],testCMinus[_n_max][_n_max],testC0[_n_max];

    
    for(id key in _coefficientsDictionary){
        NSMutableArray* coeffArray = [_coefficientsDictionary objectForKey:key];

        double e2,error;
        int nsample = 0;
        error = 0;
        
        for(id testCoeff in coeffArray){
            nsample++;

            int i = 0;
            for(int n = 0; n<_n_max; n++){
                for(int m = -n; m<=n; m++){
                    double c = [testCoeff[i] doubleValue];
                    if(m>0) testCPlus[n][m] = c;
                    if(m<0) testCMinus[n][-m] = c;
                    if(m==0) testC0[n] = c;
                    i++;
                }//for(int m = -n; m<=n; m++)
            }//for(int n = 0; n<_n_max; n++)

            
            
            e2 = 0;
            for(int n = 0; n<_n_max; n++){
                for(int m = -n; m<=n; m++){
                    double dif;
                    if(m>0) {
                        dif = testCPlus[n][m]/testC0[0]-cPlus[n][m]/c0[0];
                    }
                    if(m<0){
                        dif = testCMinus[n][-m]/testC0[0]-cMinus[n][-m]/c0[0];
                    }
                    if(m==0){
                        dif = testC0[n]/testC0[0]-c0[n]/c0[0];
                    }
                    e2+= dif*dif;

                    
                    
                }//for(int m = 0; m<=n; m++)
            }//for(int n = 0; n<_n_max; n++)
            error += 1./(e2);
        }//for(id testCoeff in coeffArray)
        error = 1./sqrt(error / (double) nsample);
        
        //store error in error dictionary
        NSNumber* errorNS = [NSNumber numberWithDouble:error];
        [_errorDictionary setValue:errorNS forKey:key];
    }//for(id key in _coefficientsDictionary)
    
    
}//-(void) calculateErrorsForNearestNeighborWithNoRotationalInvariance: (double*) coeff



-(void) calculateErrorsForNeuralNet:(double*) coeff{
    //calculate rankings for neural net classifier
    
    
    if(_invariant == 1) [self calculateErrorsForInvariantNeuralNet:coeff];
    if(_invariant == 0) [self calculateErrorsForNonInvariantNeuralNet:coeff];
}//-(void) calculateErrorsForNeuralNet:(double*) coeff


-(void) calculateErrorsForInvariantNeuralNet:(double*) coeff{
    //  calculates rankings for nerual net classifier for rotationally invariant patterns

    
    _errorDictionary = [NSMutableDictionary dictionary];
    
    int nInput = _n_max*_n_max-_n_max;
    
    
    fann_type *calc_out;
    fann_type input[nInput];
    
    
    struct fann *ann = fann_create_from_file("invariantNeuralNetInfo.net");
    
    
    double c2[_n_max][_n_max];
    double dot[_n_max][_n_max];
    double cPlus[_n_max][_n_max],cMinus[_n_max][_n_max];
    int i = 0;
    int k = 0;
    for(int n = 0; n<_n_max; n++){
        for(int m = -n; m<=n; m++){
            double c = coeff[i];
            if(m>0) cPlus[n][m] = c;
            if(m<0) cMinus[n][-m] = c;
            
            if(m==0) {
                c2[n][m] = c*c;
                if(n!=0){
                    input[k] = c2[n][m]/c2[0][0];
                    k++;
                }
            } else if(m>0) {
                if(m!=n){
                    dot[n][m] = cPlus[n][m]*cPlus[m][m]+cMinus[n][m]*cMinus[m][m];
                    input[k] = dot[n][m]/c2[0][0];
                    k++;
                }
                c2[n][m] = cPlus[n][m]*cPlus[n][m] + cMinus[n][m]* cMinus[n][m];
                input[k] = c2[n][m]/c2[0][0];
                k++;
            }
            
            i++;
        }
    }
    
    calc_out = fann_run(ann, input);
    for(int i = 0; i<nKeys; i++){
        NSNumber* val = [NSNumber numberWithFloat:calc_out[i]];
        [_errorDictionary setValue:val forKey:patternList[i]];
    }

}//-(void) calculateErrorsForInvariantNeuralNet:(double*) coeff

-(void) calculateErrorsForNonInvariantNeuralNet:(double*) coeff{
    //  calculates rankings for nerual net classifier for non-rotationally invariant patterns
    
    _errorDictionary = [NSMutableDictionary dictionary];
    
    int nInput = _n_max*_n_max-1;
    
    
    fann_type *calc_out;
    fann_type input[nInput];
    
    
    struct fann *ann = fann_create_from_file("nonInvariantNeuralNetInfo.net");
    
    
    int k = 0;
    int i = 0;
    for(int n = 0; n<_n_max; n++){
        for(int m = -n; m<=n; m++){
            if(!(m==0&&n==0)){
            input[k] = coeff[i]/coeff[0];
                k++;
            }
                i++;
        }
    }
    
    calc_out = fann_run(ann, input);
    for(int i = 0; i<nKeys; i++){
        NSNumber* val = [NSNumber numberWithFloat:calc_out[i]];
        [_errorDictionary setValue:val forKey:patternList[i]];
    }

}



-(void) createNeuralNet{
    //used to train the neural net
    
    if([_coefficientsDictionary count]>0){
        [self createNonInvariantNeuralNet];
        [self createInvariantNeuralNet];
        [neuralGreenLight setStatus:1];
    }
}


-(void) createNonInvariantNeuralNet{
    //For training a non-rotationally invariant neural net

    
    FILE *f = fopen("train.data", "w");
    
    
    [self createPatternList];
    
    int count = 0;
    for(id key in _coefficientsDictionary){
        id coeffArray = [_coefficientsDictionary objectForKey:key];
        count+= [coeffArray count];
    }
    
    nKeys = (int)[_coefficientsDictionary count];
    
    
    //count is the number of training examples
    //number of input neurons = number of rotational invariants = _n_max*_n_max - _n_max
    //nKeys is the number of output neurons
    
    int nInput = _n_max*_n_max-1;
    
    fprintf(f,"%d %d %d\n",count,nInput,nKeys);
    
    for(id key in _coefficientsDictionary){
        id coeffArray = [_coefficientsDictionary objectForKey:key];
        
        //find out the position in patternList
        int patternNumber = -1;

        for(int j=0; j<[patternList count]; j++){
            if([patternList[j] isEqualToString:key]) patternNumber = j;
        }
        
        
        //print out the coefficients
        
        for(id coeffs in coeffArray){
            
            int i = 0;
            for(int n = 0; n<_n_max; n++){
                for(int m = -n; m<=n; m++){
                    double c = [coeffs[i] doubleValue]/[coeffs[0] doubleValue];
                    if(!(m==0&&n==0)) fprintf(f,"%f ",c);
                    i++;
                }
            }
            fprintf(f,"\n");
            
            
            //      now print out the desired result
            for(int j = 0; j<nKeys; j++){
                if(j==patternNumber){fprintf(f,"%d ",1);}
                else{fprintf(f,"%d ",0);}
            }
            fprintf(f,"\n");
            
        }//for(id coeffs in coeffArray)
        
    }//for(id key in _coefficientsDictionary)
    
    fclose(f);
    
    
    const unsigned int num_input = nInput;
    const unsigned int num_output = nKeys;
    const unsigned int num_layers = 3;
    const unsigned int num_neurons_hidden = _nHiddenNoRot;
    const unsigned int max_epochs = 40000;
    const unsigned int epochs_between_reports = 1000;
    const float desired_error = _errorMaxNoRot;
    
    _nInputNoRot = nInput;
    _nOutputNoRot = nKeys;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateNeuralParams"
     object:self];
    
    
//    const float desired_error = 0.00042;
    float mse = 100.*desired_error;
    
    while(mse>desired_error){
        
        struct fann *ann = fann_create_standard(num_layers, num_input, num_neurons_hidden, num_output);
        
        //  run the neural network on the training data
        
        fann_train_on_file(ann, "train.data", max_epochs, epochs_between_reports, desired_error);
        mse = fann_get_MSE(ann);
        fann_save(ann, "nonInvariantNeuralNetInfo.net");
        fann_destroy(ann);
        
    }//while(mse>desired_error)
    
    NSLog(@"END TRAINING");

    
}



-(void) createInvariantNeuralNet{
    //For training a rotationally invariant neural net

    
    FILE *f = fopen("train.data", "w");
    
    
    [self createPatternList];
    
    int count = 0;
    for(id key in _coefficientsDictionary){
        id coeffArray = [_coefficientsDictionary objectForKey:key];
        count+= [coeffArray count];
    }
    
    
    //count is the number of training examples
    //number of input neurons = number of rotational invariants = _n_max*_n_max - _n_max
    //nKeys is the number of output neurons
    
    int nInput = _n_max*_n_max-_n_max;
    
    fprintf(f,"%d %d %d\n",count,nInput,nKeys);
    
    for(id key in _coefficientsDictionary){
        id coeffArray = [_coefficientsDictionary objectForKey:key];
        
        //find out the position in patternList
        int patternNumber = -88;
        
        for(int j=0; j<[patternList count]; j++){
            if([patternList[j] isEqualToString:key]) patternNumber = j;
        }
        
        
        //print out the rotational invariants
        
        for(id coeffs in coeffArray){
            
            double c2[_n_max][_n_max];
            double dot[_n_max][_n_max];
            double cPlus[_n_max][_n_max],cMinus[_n_max][_n_max];
            int i = 0;
            for(int n = 0; n<_n_max; n++){
                for(int m = -n; m<=n; m++){
                    double c = [coeffs[i] doubleValue];
                    if(m>0) cPlus[n][m] = c;
                    if(m<0) cMinus[n][-m] = c;
                    
                    if(m==0) {
                        c2[n][m] = c*c;
                        if(n!=0) {
                            fprintf(f,"%f ",c2[n][m]/c2[0][0]);
                        }
                    } else if(m>0) {
                        if(m!=n){
                            dot[n][m] = cPlus[n][m]*cPlus[m][m]+cMinus[n][m]*cMinus[m][m];
                            fprintf(f,"%f ",dot[n][m]/c2[0][0]);
                        }
                        c2[n][m] = cPlus[n][m]*cPlus[n][m] + cMinus[n][m]* cMinus[n][m];
                        fprintf(f,"%f ",c2[n][m]/c2[0][0]);
                    }
                    
                    i++;
                }
            }
            fprintf(f,"\n");
            
            
            //      now print out the desired result
            for(int j = 0; j<nKeys; j++){
                if(j==patternNumber){fprintf(f,"%d ",1);}
                else{fprintf(f,"%d ",0);}
            }
            fprintf(f,"\n");
            
        }//for(id coeffs in coeffArray)
        
    }//for(id key in _coefficientsDictionary)
    
    fclose(f);
    
    
    const unsigned int num_input = nInput;
    const unsigned int num_output = nKeys;
    const unsigned int num_layers = 3;
    const unsigned int num_neurons_hidden = _nHiddenRot;
    const unsigned int max_epochs = 40000;
    const unsigned int epochs_between_reports = 1000;
    const float desired_error = _errorMaxRot;
//    const float desired_error = 0.0028;
    
    _nInputRot = nInput;
    _nOutputRot = nKeys;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateNeuralParams"
     object:self];
    
    float mse = 100.*desired_error;
    
    while(mse>desired_error){
        
        struct fann *ann = fann_create_standard(num_layers, num_input, num_neurons_hidden, num_output);
        
        //  run the neural network on the training data
        
        fann_train_on_file(ann, "train.data", max_epochs, epochs_between_reports, desired_error);
        mse = fann_get_MSE(ann);
        fann_save(ann, "invariantNeuralNetInfo.net");
        fann_destroy(ann);
        
    }//while(mse>desired_error)

    NSLog(@"END TRAINING");
}


-(void) createPatternList{
    //Creates a NSMutableArray of all the class labels

    
    patternList = [NSMutableArray array];
    int count = 0;
    for(id key in _coefficientsDictionary){
        [patternList addObject:key];
        id coeffArray = [_coefficientsDictionary objectForKey:key];
        count+= [coeffArray count];
    }
    
    nKeys = (int)[_coefficientsDictionary count];
}


-(void) validate{
    //For running k-fold cross validation
    
    if([_coefficientsDictionary count] == 0){
        NSLog(@"error: no entries in database");
        return;
    }
    
    _validateArray = [NSMutableArray array];
    
    
    //nk is the number of segments in the k-fold validation
    NSMutableArray* kfold = [NSMutableArray array];
    
    //kfold[k] holds the dictionary for the kth segment
    
    for(int k = 0; k<_nValidate; k++){
        [kfold addObject: [NSMutableDictionary dictionary]];
    }
    
    NSMutableArray* keyList = [NSMutableArray array];
    int total = 0;
    for(id key in _coefficientsDictionary){
        [keyList addObject:key];
        total += [[_coefficientsDictionary valueForKey:key] count];
    }
    
    
    int numKeys = (int)[keyList count];
    
    _confusionArray = malloc(sizeof(int*)*numKeys);
    for(int i = 0;i<numKeys;i++){
        _confusionArray[i] = malloc(sizeof(int)*numKeys);
    }
    
    for(int i = 0;i<numKeys;i++){
        for(int j = 0;j<numKeys; j++){
            _confusionArray[i][j] = 0;
        }
    }
//create list of patterns in some refernce order- used to help create confusion matrix.
    _patterns_list = [NSMutableArray array];
    for(id key in _coefficientsDictionary){
        [_patterns_list addObject:key];
    }
    
    
    
    
    
    int nValidation = 0;
    
    long seed = time(NULL);
    srand((int)seed);
    
    int k = 0;
    while (nValidation < total){
        int ran = rand() % numKeys;
        id key = keyList[ran];
        
        _patternName = key;
        id coeffArray = [_coefficientsDictionary objectForKey:key];
        int count = (int)[coeffArray count];

        if(count>0){
            int ran2 = rand() % count;
            id coeff = coeffArray[ran2];

            NSMutableDictionary* kDictionary = kfold[k%_nValidate];
            
            NSMutableArray* array;
            if([kDictionary objectForKey:_patternName]){
                //if key already exists
                array = [kDictionary valueForKey:_patternName];
            }else{
                array = [NSMutableArray array];
            }
            [array addObject:coeff];
            [kDictionary setValue:array forKey:_patternName];
            
            kfold[k] = kDictionary;
            [coeffArray removeObjectAtIndex:ran2];
            
            nValidation += 1;
            k+=1;
        }
    }


    int ensemble_nright = 0;
    int ensemble_nwrong = 0;
    
    //vCoefficientsDictionary = A dictionary containing coefficients for validation.
    NSMutableDictionary* vCoefficientsDictionary;
    
    //loop over the nk segments
    for(int k = 0; k<_nValidate;k++){
    
        NSLog(@"SEGMENT = %d",k);
        
        vCoefficientsDictionary = kfold[k];

        //clear the coefficientsDictionary and fill it with the dictionaries in the nk-1 segments
        _coefficientsDictionary = [NSMutableDictionary dictionary];
        for(int j = 0; j<_nValidate; j++) {
            if(j!=k){
                NSMutableDictionary* kDictionary = kfold[j];
                for(id key in kDictionary){
                    id coeffArray = [kDictionary objectForKey:key];
                    for(NSMutableArray* coeff in coeffArray){
                        NSMutableArray* array;
                        if([_coefficientsDictionary objectForKey:key]){
                            //if key already exists
                            array = [_coefficientsDictionary valueForKey:key];
                        }else{
                            array = [NSMutableArray array];
                        }
                    [array addObject:coeff];
                    [_coefficientsDictionary setValue:array forKey:key];
                    }//for(NSMutableArray* coeff in coeffArray)
                }
            }//if(j!=k)
            }//for(int j = 0; j<nk; j++)
        

        if(_trainingModel==1){
            [self createNeuralNet];
        }
        
        
        //now sum over the validation coefficients and find the misclassification rate
        
        
        int nright = 0;
        int nwrong = 0;

        for(id key in vCoefficientsDictionary){
            NSMutableArray* array = [vCoefficientsDictionary objectForKey:key];
            for(NSMutableArray* coeffArray in array){
                
                _patternName = key;
                
                //extract coeffs from coeffArray and calculate error
                
                double coeff[_n_max*_n_max];
                
                int i = 0;
                for(int n = 0; n<_n_max;n++){
                    for(int m = -n; m <= n; m++){
                        coeff[i] = [coeffArray[i] doubleValue];
                        i++;
                    }
                }
                
 
                [self calculateErrors:coeff];
                
                
                
                //find the name with the least error
                double errorMin = 9999.;
                NSString*  nameMin;
                for(id key in _errorDictionary){
                    double err =[[_errorDictionary valueForKey:key] doubleValue];
                    if(_trainingModel == 1) err = 1.-err;
                    if(err<errorMin){
                        nameMin = key;
                        errorMin = err;
                    }
                }
            
                
                if(![_patternName isEqualToString:nameMin]){
                    nwrong++;
                    NSLog(@"%@ misclassified as %@",_patternName,nameMin);
                }else{
                    nright++;
                }
                

                //find out the position in _patterns_List
                int i_pName,i_nameMin = -1;
                
                for(int j=0; j<[_patterns_list count]; j++){
                    if([_patterns_list[j] isEqualToString:_patternName]) i_pName = j;
                    if([_patterns_list[j] isEqualToString:nameMin]) i_nameMin = j;
                }
                _confusionArray[i_pName][i_nameMin]+=1;
                

            
            
            }//for(NSMutableArray* coeffArray in array)
        }//for(id key in vCoefficientsDictionary)
        
        int ntotal = nright+nwrong;
        NSLog(@"nright = %d, fraction = %f",nright,(double) nright / (double) ntotal);
        NSLog(@"nwrong = %d, fraction = %f",nwrong,(double) nwrong / (double) ntotal);
        NSLog(@"ntotal = %d, fraction = %f",ntotal,(double) ntotal / (double) ntotal);

        NSMutableArray* segmentResult = [NSMutableArray array];
        [segmentResult addObject:[NSNumber numberWithInt:nright]];
        [segmentResult addObject:segmentResult[1] = [NSNumber numberWithInt:ntotal]];
        
        [_validateArray addObject:segmentResult];
        
        ensemble_nright += nright;
        ensemble_nwrong += nwrong;
    }
    NSLog(@"\n\n");
    NSLog(@"ENSEMBLE results");
    int ensemble_ntotal = ensemble_nright+ensemble_nwrong;
    NSLog(@"nright = %d, fraction = %f",ensemble_nright,(double) ensemble_nright / (double) ensemble_ntotal);
    NSLog(@"nwrong = %d, fraction = %f",ensemble_nwrong,(double) ensemble_nwrong / (double) ensemble_ntotal);
    NSLog(@"ntotal = %d, fraction = %f",ensemble_ntotal,(double) ensemble_ntotal / (double) ensemble_ntotal);
    
    

//Finally get back the original coefficientsDictionary by adding back in the last segment
    int j = _nValidate-1;
    NSMutableDictionary* kDictionary = kfold[j];

      for(id key in kDictionary){
        id coeffArray = [kDictionary objectForKey:key];
        for(NSMutableArray* coeff in coeffArray){
            NSMutableArray* array;
            if([_coefficientsDictionary objectForKey:key]){
                //if key already exists
                array = [_coefficientsDictionary valueForKey:key];
            }else{
                array = [NSMutableArray array];
            }
            [array addObject:coeff];
            [_coefficientsDictionary setValue:array forKey:key];
        }//for(NSMutableArray* coeff in coeffArray)
    }//for(id key in kDictionary)
    
    //check
    

    _validated = 1;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateValidateTable"
     object:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateConfusionMatrix"
     object:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"redrawFitView"
     object:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateErrorTable"
     object:self];
    
}

-(void) changeModelName{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateModelImage"
     object:self];
}

-(void) wipeInfo{
    _coefficientsDictionary = [NSMutableDictionary dictionary];
    _errorDictionary = [NSMutableDictionary dictionary];
    _patternName = @"";
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateErrorTable"
     object:self];
    
}


-(void) cluster{
    //The k-fold clustering algorithm
    
    float tol = 1.e-3;
    
    float** clusterCentroid;
    float** newClusterCentroid;
    float** bestClusterCentroid;
    IndexedFloat* clusterIndex;
    float totalInCluster[_nCluster];

    clusterCentroid = malloc(sizeof(float*)*_nCluster);
    newClusterCentroid = malloc(sizeof(float*)*_nCluster);
    bestClusterCentroid = malloc(sizeof(float*)*_nCluster);
    clusterIndex = malloc(sizeof(IndexedFloat)*_nCluster);
    
    for(int i = 0;i<_nCluster; i++){
        clusterCentroid[i] = malloc(sizeof(float)*2);
        newClusterCentroid[i] = malloc(sizeof(float)*2);
        bestClusterCentroid[i] = malloc(sizeof(float)*2);
    }
    
    
    for(int i = 0; i<_nCluster; i++){
        clusterIndex[i].index = i;
    }

    
    float xf,yf;
    float greyScale;
    float sum,sumMin;
    
    sumMin = 9999.;
    for(int ntrials = 0; ntrials <10; ntrials++){

    
    for(int n = 0; n<20; n++){
        sum = 0.0;
        for(int i = 0;i<_nCluster; i++){
            newClusterCentroid[i][0] = 0.0;
            newClusterCentroid[i][1] = 0.0;
            totalInCluster[i] = 0.0;
        }
        
        int i =0;
        for (int y = 0; y < _picWidth; y++) {
            for (int x = 0; x < _picHeight; x++) {
                xf = x / (float) _picWidth;
                yf = 1.-y / (float) _picHeight;
                
                //find which centroid this pixel belongs to
                
                int jmin;
                
                float r2min = 0.0;
                if(n!=0){

                    jmin = assignCluster(_nCluster, clusterCentroid, clusterIndex,xf, yf,&r2min);
                }else{
                    jmin = rand() % _nCluster;
                }
                
                greyScale = _greyPicData[i]/255.;
                sum+=r2min*greyScale;
                
                newClusterCentroid[jmin][0]+=xf*greyScale;
                newClusterCentroid[jmin][1]+=yf*greyScale;
                totalInCluster[jmin] += greyScale;
                

                i+=1;
                
            }
        }
        
        float error = 0.;
        for(int i = 0; i<_nCluster; i++){
            float x = newClusterCentroid[i][0]/(float) totalInCluster[i];
            float y = newClusterCentroid[i][1]/(float) totalInCluster[i];

            float xdif = x-clusterCentroid[i][0];
            float ydif = y-clusterCentroid[i][1];
            error+= xdif*xdif+ydif*ydif;
            
            clusterCentroid[i][0] = x;
            clusterCentroid[i][1] = y;
        }
        error = sqrt(error/(float)_nCluster);
        
        if(error<tol) break;
        
    }//for(int n = 0; n<10; n++)

        if(sum<sumMin){
            sumMin = sum;
            for(int i = 0; i<_nCluster; i++){
                bestClusterCentroid[i][0] = clusterCentroid[i][0];
                bestClusterCentroid[i][1] = clusterCentroid[i][1];
            }
        }
    
    
    }


    
//order the centroids by x values

    for(int i = 0; i<_nCluster; i++){
        clusterIndex[i].value = bestClusterCentroid[i][0];
    }
    
    qsort(clusterIndex, _nCluster, sizeof(IndexedFloat), compareIndexed);
    
    
    
    int i = 0;
    for (int y = 0; y < _picWidth; y++) {
        for (int x = 0; x < _picHeight; x++) {
            xf = x / (float) _picWidth;
            yf = 1.-y / (float) _picHeight;

            float r2min;
            
            _belongsToCluster[i] = assignCluster(_nCluster, bestClusterCentroid,clusterIndex,xf, yf,&r2min);

            i++;
        
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"redrawClusterView"
     object:self];
    
    
}





-(void) calculateCluster{
  
    //Now that the clustering has been determined, evaluate the patterns based on each cluster
    
    
    NSMutableString* best = [NSMutableString string];
    NSArray* split;
    
    NSString* patternNameOrig = _patternName;
    
    NSLog(@"patternName = %@",_patternName);
    if(_training==1){
        split = [_patternName componentsSeparatedByString:@","];
        if([split count]!=_nCluster){
            NSAlert *alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"Ok" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Pattern name must have %i comma separated values",_nCluster];
            [alert runModal];
            return;
        }
        
        for(int i = 0; i<[split count]; i++){
            NSLog(@"SPLIT %i %@",i,split[i]);
        }
    }
    
    unsigned char *greyPicDataOrig;
    int *fitTotal;
    greyPicDataOrig = malloc(sizeof(unsigned char)*_picHeight*_picWidth);
    fitTotal = malloc(sizeof(int)*_fitPicHeight*_fitPicWidth);

    int i = 0;
    for (int y = 0; y < _picWidth; y++) {
        for (int x = 0; x < _picHeight; x++) {
            greyPicDataOrig[i] = _greyPicData[i];
            i++;
            
        }
    }
    
    
    i = 0;
    for (int y = 0; y < _fitPicWidth; y++) {
        for (int x = 0; x < _fitPicHeight; x++) {
            fitTotal[i] = 0;
            i++;
        }
    }
    

    
    for(int n = 0; n<_nCluster;n++){
        int i = 0;
        for (int y = 0; y < _picWidth; y++) {
            for (int x = 0; x < _picHeight; x++) {
                if(_belongsToCluster[i] == n) {
                    _greyPicData[i] = greyPicDataOrig[i];
                }else{
                    _greyPicData[i] = 0;
                }
                i++;
                
            }
        }

        if(_training==1) _patternName = split[n];
        [self calculate];
    
        
        i = 0;
        for (int y = 0; y < _fitPicWidth; y++) {
            for (int x = 0; x < _fitPicHeight; x++) {
                fitTotal[i]+=_fit[i];
                i++;
                
            }
        }
        
        if(_bestClass){
            if([best length]>0) [best appendString:@","];
            [best appendString:_bestClass];
        }
        
    }//for(int n = 0; n<_nCluster;n++)
    
    _bestClass = best;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateBestClassLabel"
     object:self];
    
    
    i = 0;
    for (int y = 0; y < _fitPicWidth; y++) {
        for (int x = 0; x < _fitPicHeight; x++) {
            if(fitTotal[i]>255) fitTotal[i] = 255;
            if(fitTotal[i]<0) fitTotal[i] = 0;
            _fit[i] = fitTotal[i];
            i++;
            
        }
    }
    
    
    i = 0;
    for (int y = 0; y < _picWidth; y++) {
        for (int x = 0; x < _picHeight; x++) {
            _greyPicData[i] = greyPicDataOrig[i];
            i++;
            
        }
    }


    
    
    _patternName = patternNameOrig;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"redrawFitView"
     object:self];
    
    
    
}


-(IBAction)kagglePressed:(id)sender{
//  Train on batch CSV file, e.g. the kaggle data
    
    
    NSLog(@"kaggle");
    
    FILE* stream = fopen("train.csv", "r");
    
    char line[4096];
    int i = 0;
    int class;
    while (fgets(line, 4096, stream))
    {
        i++;
        NSLog(@"i = %i",i);
        char* tmp = strdup(line);
        for(int k = 1; k<=28*28+1;k++){
            tmp = strdup(line);
            int a = atoi(getfield(tmp,k));
//            printf("%d,",a);
            if(k == 1) {
                class = a;
            }
            
            if(k!=1) _greyPicData[k-2] = a;
            free(tmp);
        }
        _patternName = [NSString stringWithFormat:@"%d",class];
        [self calculate];
//        if(i==21000) break;
    }
}




@end


const char* getfield(char* line, int num)
{
    const char* tok;
    for (tok = strtok(line, ",");
         tok && *tok;
         tok = strtok(NULL, ",\n"))
    {
        if (!--num)
            return tok;
    }
    return NULL;
}

int assignCluster(int nCluster, float** clusterCentroid,IndexedFloat* clusterIndex,float xf, float yf, float* r2min){
//Used by the clustering algorithm to assign a particular x-y coordinate to a particular cluster
    
    int jmin = -1;
    
    *r2min = 10.;
    float xdif,ydif,r2;
    for(int j = 0; j<nCluster; j++){
        int k = clusterIndex[j].index;
        xdif = xf - clusterCentroid[k][0];
        ydif = yf - clusterCentroid[k][1];
        r2 = xdif*xdif+ydif*ydif;
        if(r2<=*r2min) {
            *r2min = r2;
            jmin = j;
        }
    }
    return jmin;
}


void findAxes(unsigned char* greyData,int w,int h,float* xCenter, float* yCenter,
              float* xx, float* xy, float* yx, float* yy, float* xvar, float* yvar){
//Locate the center of the distribution and find the axes
    
    
    float greyScale,gsum;
    *xCenter = 0;
    *yCenter = 0;
    gsum = 0;

    float xf,yf;
    
    float ave_xx,ave_yy,ave_xy;
    ave_xx = 0;
    ave_xy = 0;
    ave_yy = 0;
    
    int i =0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            xf = x / (float) w;
            yf = 1.-y / (float) h;
            
            greyScale = greyData[i]/255.;
            *xCenter += greyScale * xf;
            *yCenter += greyScale * yf;
            gsum+=greyScale;
            
            i+=1;
        
        }
    }
    
    *xCenter = *xCenter/gsum;
    *yCenter = *yCenter/gsum;

// Now find the values of <xx> <xy> and <yy> wrt the origin
    
    i=0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            xf = x / (float) w - *xCenter;
            yf = 1.-y / (float) h - *yCenter;
            
            greyScale = greyData[i]/255.;
            ave_xx += greyScale * xf*xf;
            ave_yy += greyScale * yf*yf;
            ave_xy += greyScale * xf*yf;
            i+=1;
            
        }
    }

    ave_xx = ave_xx/gsum;
    ave_yy = ave_yy/gsum;
    ave_xy = ave_xy/gsum;
    
    //xx is the x component of the principal x axis.
    //xy is the y component of the principal x axis.
    //yx is the x component of the principal y axis.
    //yy is the y component of the principal y axis.
    
    
    float theta = (atan(2.*ave_xy/(ave_xx-ave_yy)))/2.;
    
    *xx = cos(theta);
    *xy = sin(theta);
    
    *yx = -sin(theta);
    *yy = cos(theta);

    *xvar = (ave_xx* *xx + ave_xy* *xy) / *xx;
    *yvar = (ave_xx* *yx + ave_xy* *yy) / *yx;
    
}

int compareIndexed(const void * elem1, const void * elem2) {
    IndexedFloat * i1, *i2;
    i1 = (IndexedFloat*)elem1;
    i2 = (IndexedFloat*)elem2;
    printf("compare %f %f\n",i1->value,i2->value);
    return i1->value > i2->value;
}








