//
//  StartController.h
//  Classifier
//
//  Created by Christian Burnham on 07/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface StartController : NSObject{
    IBOutlet  Model* model;
    IBOutlet NSTextField* patternNameTextField;
}

-(IBAction)startButtonPressed:(id)sender;

@end
