//
//  NewModel.m
//  Classifier
//
//  Created by Christian Burnham on 22/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "NewDatabase.h"

@implementation NewDatabase

-(IBAction) createNewDatabase:(id)sender{
    if(!newDatabaseWindowController){
        newDatabaseWindowController = [[NewDatabaseWindowController alloc] init];
        [newDatabaseWindowController setModel:model];
    }
    [newDatabaseWindowController showWindow:self];
}

@end
