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

@interface NewDatabaseControls : NSObject{
    IBOutlet NSTextField* nmaxText;
    IBOutlet NewDatabaseWindowController* newDatabaseWindowController;
    IBOutlet NSStepper* nmaxStepper;
    IBOutlet NSTextField* nameText;
    Model* model;
    NSString* databaseName;
    int nmax;
}
-(IBAction)nmaxTextEntered:(id)sender;
-(IBAction)nmaxStepped:(id)sender;
-(IBAction)createNewDatabase:(id)sender;
-(IBAction)nameEntered:(id)sender;
@end
