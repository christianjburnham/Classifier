//
//  LaunchNeuralWindowController.h
//  Classifier
//
//  Created by Christian Burnham on 18/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "NeuralWindowController.h"

@interface LaunchNeuralWindowController : NSObject{
    IBOutlet Model* model;
    NeuralWindowController* neuralWindowController;
}
-(IBAction) launchNeuralWindow:(id)sender;
@end
