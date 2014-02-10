//
//  BuildNetController.m
//  Classifier
//
//  Created by Christian Burnham on 18/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "BuildNetController.h"

@implementation BuildNetController

-(IBAction)buildNetButtonPressed:(id)sender{
    [model createNeuralNet];
}

@end
