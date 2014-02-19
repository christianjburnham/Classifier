//
//  Model.h
//  Classifier
//
//  Created by Christian Burnham on 07/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeuralGreenLight.h"


@interface Model : NSObject{
    NSString* databaseName;
    unsigned char *data;
    unsigned char *picData;
    unsigned char *greyPicData;
    unsigned char* fit;

    int picWidth,picHeight,fitPicWidth,fitPicHeight;
    int picWidthMax,picHeightMax,fitPicWidthMax,fitPicHeightMax;

    NSString* patternName;
    
    int n_max;
    
    float xx, xy, yx, yy, xvar, yvar,xCenter,yCenter;
    NSMutableDictionary* coefficientsDictionary;
    NSMutableDictionary* errorDictionary;
    int training;
    int validateFlag;
    
    int nKeys;
    NSMutableArray* patternList;
    
    int trainingModel;
    
    int invariant;
    
    int inverse;

    int nValidate;
    
    NSMutableArray* validateArray;
    IBOutlet NeuralGreenLight* neuralGreenLight;
    
    int* confusionArray;
    int validated;
    
    NSMutableArray* patterns_list;
    
    int* belongsToCluster;

    int nCluster;
    
    NSString* bestClass;
    
    int nHiddenNoRot,nHiddenRot;
    float errorMaxNoRot,errorMaxRot;
    
    int nInputNoRot,nInputRot,nOutputNoRot,nOutputRot;
    
}
@property int n_max;
@property NSString* databaseName;
@property unsigned char *data;
@property unsigned char *picData;
@property unsigned char *greyPicData;
@property float xx,xy,yx,yy,xvar,yvar,xCenter,yCenter;

@property int picWidth;
@property int picHeight;
@property int picWidthMax;
@property int picHeightMax;

@property int fitPicWidth,fitPicHeight;
@property int fitPicWidthMax,fitPicHeightMax;

@property int nHiddenNoRot,nHiddenRot;
@property int nInputNoRot,nInputRot;
@property int nOutputNoRot,nOutputRot;
@property float errorMaxRot,errorMaxNoRot;

@property unsigned char* fit;
@property NSMutableDictionary* coefficientsDictionary;
@property NSMutableDictionary* errorDictionary;

@property NSString* patternName;
@property int training;
@property int trainingModel;
@property int invariant;
@property int inverse;
@property NSMutableArray* validateArray;

@property int nValidate;
@property int** confusionArray;
@property int validated;

@property NSMutableArray* patterns_list;

@property int* belongsToCluster;
@property int nCluster;
@property NSString* bestClass;

-(void) validate;
-(void) calculate;
-(void) createNeuralNet;
-(void) changeModelName;
-(void) wipeInfo;
-(void) cluster;
-(void) calculateCluster;

-(IBAction)kagglePressed:(id)sender;


@end

typedef struct IndexedFloat {
    float value;
    int index;
} IndexedFloat;

const char* getfield(char* line, int num);

NSBitmapImageRep *ImageRepFromImage(NSImage *image);
void findAxes(unsigned char* greyData,int w,int h, float* xCenter, float* yCenter,
              float* xx,float* xy,float* yx,float* yy,float* xvar,float* yvar);
int assignCluster(int nCluster, float** clusterCentroid, IndexedFloat* clusterIndex, float xf, float yf,float* r2min);

int compareIndexed(const void * elem1, const void * elem2);
