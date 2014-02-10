//
//  ErrorTableController.h
//  Classifier
//
//  Created by Christian Burnham on 06/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ErrorTableController : NSObject{
    IBOutlet NSTableView* errorTable;
    IBOutlet Model* model;
    IBOutlet NSTextField* patternNameTextField;
    NSNotificationCenter* nc;
    NSMutableArray* Name,*Error,*NumberOfValues;
    NSString* selectedName;
}

@property NSString* selectedName;

-(IBAction)enterPatternName:(id)sender;

-(void) tableViewSelectionDidChange:(NSNotification*) notification;

@end
