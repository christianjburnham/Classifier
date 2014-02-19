//
//  NeuralParametersController.h
//  Classifier
//
//  Created by Christian Burnham on 18/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeuralWindowController.h"
#import "Model.h"

@interface NeuralParametersController : NSObject{
    IBOutlet NSTextField* nHiddenNoRotText;
    IBOutlet NSTextField* nHiddenRotText;
    IBOutlet NSTextField* errorMaxNoRotText;
    IBOutlet NSTextField* errorMaxRotText;
    IBOutlet NeuralWindowController* neuralWindowController;
    IBOutlet NSTextField* nInputNoRotText;
    IBOutlet NSTextField* nInputRotText;
    IBOutlet NSTextField* nOutputNoRotText;
    IBOutlet NSTextField* nOutputRotText;
    
    Model* model;
}

-(IBAction) nHiddenNoRotTextEntered:(id)sender;
-(IBAction) nHiddenRotTextEntered:(id)sender;
-(IBAction) nHiddenNoRotTextStepped:(id)sender;
-(IBAction) nHiddenRotTextStepped:(id)sender;
-(IBAction) errorMaxNoRotTextEntered:(id)sender;
-(IBAction) errorMaxRotTextEntered:(id)sender;


@end
