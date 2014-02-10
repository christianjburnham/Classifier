//
//  SelectTableController.h
//  Classifier
//
//  Created by Christian Burnham on 04/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface SelectTableController : NSObject{
    IBOutlet NSTableView* selectTable;
    IBOutlet Model* model;
    IBOutlet NSTextField* patternNameTextField;
    NSNotificationCenter* nc;
    NSMutableArray* list;
}

-(IBAction)enterPatternName:(id)sender;

@end
