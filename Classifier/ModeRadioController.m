//
//  ModeRadioController.m
//  Classifier
//
//  Created by Christian Burnham on 06/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ModeRadioController.h"

@implementation ModeRadioController

-(void) awakeFromNib{
    
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(selectButton)
               name:@"selectRadioButton"
             object:nil];

    
}

-(IBAction)modeRadioButtonSelected:(id)sender{
    NSButtonCell *selCell = [sender selectedCell];
    int training = 1-(int)[selCell tag];
    if(training == 0) [input setEnabled:false];
    if(training == 1) [input setEnabled:true];
    [model setTraining:training];
}

-(void) selectButton{
    int t = [model training];
    if(t == 0){
        [radioButton selectCellWithTag:1];
        [input setEnabled:false];
    }else if(t == 1){
        [radioButton selectCellWithTag:0];
        [input setEnabled:true];
    }
}


@end
