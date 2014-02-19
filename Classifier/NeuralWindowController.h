//
//  NeuralWindowController.h
//  Classifier
//
//  Created by Christian Burnham on 18/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface NeuralWindowController : NSWindowController{
    Model* model;
}
@property Model* model;

@end
