//
//  TrainingModelRadioController.m
//  Classifier
//
//  Created by Christian Burnham on 19/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "TrainingModelRadioController.h"

@implementation TrainingModelRadioController

-(IBAction)trainingModelButtonPressed:(id)sender{
    NSButtonCell *selCell = [sender selectedCell];
    int trainingModel = (int) [selCell tag];
    [model setTrainingModel:trainingModel];
    [model changeModelName];
}

@end
