//
//  Clear.m
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "Clear.h"

@implementation Clear

-(IBAction) clearButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"clearDrawing"
     object:self];
}

@end
