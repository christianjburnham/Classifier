//
//  InvariantController.m
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "InvariantController.h"

@implementation InvariantController

-(IBAction)rotationButtonPressed:(id)sender{
    int invariant = (int) [sender state];
    [model setInvariant:invariant];
    [model changeModelName];
}

@end
