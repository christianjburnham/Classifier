//
//  DimensionController.h
//  Classifier
//
//  Created by Christian Burnham on 04/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


@interface DimensionController : NSObject{
    IBOutlet Model* model;
    IBOutlet NSTextField* dimText, *fitDimText;
    int dimMax,fitDimMax;
}

-(IBAction) dimValueEntered:(id)sender;
-(IBAction) fitDimValueEntered:(id)sender;

-(IBAction) dimValueStepped:(id) sender;
-(IBAction) fitDimValueStepped:(id) sender;



@end
