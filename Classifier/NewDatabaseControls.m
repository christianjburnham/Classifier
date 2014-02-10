//
//  NmaxTextEntered.m
//  Classifier
//
//  Created by Christian Burnham on 23/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "NewDatabaseControls.h"

@implementation NewDatabaseControls
-(void) awakeFromNib{
    model = [newDatabaseWindowController model];
    [nmaxText setIntegerValue:9];
    databaseName = @"untitled";
}

-(IBAction)nmaxTextEntered:(id)sender{
    nmax = (int)[nmaxText integerValue];
}

-(IBAction)nmaxStepped:(id)sender{
    nmax = (int)[nmaxText integerValue];
    nmax+=[sender integerValue];
    [nmaxText setIntegerValue:nmax];
    [nmaxStepper setIntegerValue:0];
}


-(IBAction)createNewDatabase:(id)sender{
    nmax = (int)[nmaxText integerValue];
    [model setN_max:nmax];
    [model setDatabaseName:databaseName];
    [model wipeInfo];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"resetDatabaseLabel"
     object:self];
    
    
    [nmaxText setIntegerValue:9];
    [nameText setStringValue:@""];

    [[newDatabaseWindowController window] orderOut:self];
}

-(IBAction)nameEntered:(id)sender{
    databaseName = [sender stringValue];
}



@end
