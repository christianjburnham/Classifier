//
//  LaunchNeuralWindowController.m
//  Classifier
//
//  Created by Christian Burnham on 18/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import "LaunchNeuralWindowController.h"

@implementation LaunchNeuralWindowController
-(IBAction) launchNeuralWindow:(id)sender{
    NSLog(@"launch neural");
    if(!neuralWindowController){
        neuralWindowController = [[NeuralWindowController alloc] init];
    }
    [neuralWindowController setModel:model];
    [neuralWindowController showWindow:self];

}

@end
