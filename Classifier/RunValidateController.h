//
//  RunValidateController.h
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidateWindowController.h"
#import "Model.h"

@interface RunValidateController : NSObject{
    IBOutlet ValidateWindowController* validateWindowController;
    Model* model;
    IBOutlet NSTextField* kText;
    IBOutlet NSStepper* kStepper;
}
-(IBAction) runValidate:(id)sender;

-(IBAction) kEntered:(id)sender;

-(IBAction) kStepped:(id)sender;

@end
