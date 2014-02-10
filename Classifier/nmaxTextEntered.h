//
//  NmaxTextEntered.h
//  Classifier
//
//  Created by Christian Burnham on 23/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewDatabaseWindowController.h"
#import "Model.h"

@interface NmaxTextEntered : NSObject{
    IBOutlet NSTextField* nmaxText;
    IBOutlet NewDatabaseWindowController* newDatabaseWindowController;
    IBOutlet NSStepper* nmaxStepper;
    Model* model;
}
-(IBAction)nmaxTextEntered:(id)sender;
-(IBAction)nmaxStepped:(id)sender;
@end
