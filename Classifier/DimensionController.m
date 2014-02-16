//
//  DimensionController.m
//  Classifier
//
//  Created by Christian Burnham on 04/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import "DimensionController.h"

@implementation DimensionController

-(void) awakeFromNib{
    int dim = (int)[fitDimText integerValue];
    [model setFitPicWidth:dim];
    [model setFitPicHeight:dim];

    dim = (int)[dimText integerValue];
    [model setPicWidth:dim];
    [model setPicHeight:dim];
    
    fitDimMax = [model fitPicHeightMax];
    dimMax = [model picHeightMax];
}


-(IBAction) dimValueEntered:(id)sender{
    int dim = (int) [sender integerValue];

    if(dim<1){
        dim = 1;
        [dimText setIntegerValue:dim];
    }else if(dim>dimMax){
        dim = dimMax;
        [dimText setIntegerValue:dim];
    }

    
    
    [model setPicHeight:dim];
    [model setPicWidth:dim];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateDrawView"
     object:self];
}


-(IBAction) fitDimValueEntered:(id)sender{
    int dim = (int) [sender integerValue];
    
    if(dim<1){
        dim = 1;
        [fitDimText setIntegerValue:dim];
    }else if(dim>dimMax){
        dim = dimMax;
        [fitDimText setIntegerValue:dim];
    }
    
    [model setFitPicHeight:dim];
    [model setFitPicWidth:dim];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"redrawFitView"
     object:self];
}

-(IBAction) dimValueStepped:(id)sender{
    int dim = (int)[dimText integerValue];
    dim+= [sender integerValue];
    
    if(dim<1){
        dim = 1;
        [dimText setIntegerValue:dim];
    }else if(dim>dimMax){
        dim = dimMax;
        [dimText setIntegerValue:dim];
    }
    
    
    [dimText setIntegerValue:dim];
    [model setPicHeight:dim];
    [model setPicWidth:dim];
    
    [sender setIntegerValue:0];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateDrawView"
     object:self];
}

-(IBAction) fitDimValueStepped:(id)sender{
    int dim = (int)[fitDimText integerValue];
    dim+= [sender integerValue];

    if(dim<1){
        dim = 1;
        [fitDimText setIntegerValue:dim];
    }else if(dim>dimMax){
        dim = dimMax;
        [fitDimText setIntegerValue:dim];
    }
    
    
    [fitDimText setIntegerValue:dim];
    [model setFitPicHeight:dim];
    [model setFitPicWidth:dim];
    
    [sender setIntegerValue:0];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"redrawFitView"
     object:self];
}


@end
