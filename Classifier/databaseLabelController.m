//
//  DatabaseLabelController.m
//  Classifier
//
//  Created by Christian Burnham on 24/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "DatabaseLabelController.h"

@implementation DatabaseLabelController

-(void) awakeFromNib{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(resetDatabaseLabel)
               name:@"resetDatabaseLabel"
             object:nil];
}

-(void)resetDatabaseLabel{
    NSString* databaseName = [model databaseName];
    [databaseLabel setStringValue:databaseName];
}

@end
