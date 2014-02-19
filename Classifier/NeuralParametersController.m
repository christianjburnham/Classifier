//
//  NeuralParametersController.m
//  Classifier
//
//  Created by Christian Burnham on 18/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import "NeuralParametersController.h"

@implementation NeuralParametersController

-(void) awakeFromNib{
    
    model = [neuralWindowController model];
    int nHiddenNoRot  = [model nHiddenNoRot];
    [nHiddenNoRotText setIntegerValue:nHiddenNoRot];
    int nHiddenRot = [model nHiddenRot];
    [nHiddenRotText setIntegerValue:nHiddenRot];
    
    float errorMaxNoRot = [model errorMaxNoRot];
    float errorMaxRot = [model errorMaxRot];
    
    NSString* formattedNumber = [NSString stringWithFormat:@"%f", errorMaxNoRot];
    [errorMaxNoRotText setStringValue:formattedNumber];

    formattedNumber = [NSString stringWithFormat:@"%f", errorMaxRot];
    [errorMaxRotText setStringValue:formattedNumber];

    int nInputNoRot = [model nInputNoRot];
    int nInputRot = [model nInputRot];
    int nOutputNoRot = [model nOutputNoRot];
    int nOutputRot = [model nOutputRot];
    
    [nInputNoRotText setIntegerValue:nInputNoRot];
    [nInputRotText setIntegerValue:nInputRot];
    [nOutputNoRotText setIntegerValue:nOutputNoRot];
    [nOutputRotText setIntegerValue:nOutputRot];
    
    
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateNeuralParams)
               name:@"updateNeuralParams"
             object:nil];

}


-(IBAction)nHiddenNoRotTextEntered:(id)sender{
    int nHiddenNoRot = (int)[sender integerValue];
    [model setNHiddenNoRot:nHiddenNoRot];
}

-(IBAction)nHiddenRotTextEntered:(id)sender{
    int nHiddenRot = (int)[sender integerValue];
    [model setNHiddenRot:nHiddenRot];
}

-(IBAction)nHiddenNoRotTextStepped:(id)sender{
    int nHiddenNoRot = (int) [nHiddenNoRotText integerValue];
    nHiddenNoRot += [sender integerValue];
    [sender setIntegerValue:0];
    
    [nHiddenNoRotText setIntegerValue:nHiddenNoRot];
    [model setNHiddenNoRot:nHiddenNoRot];
    
}

-(IBAction)nHiddenRotTextStepped:(id)sender{
    int nHiddenRot = (int) [nHiddenRotText integerValue];
    nHiddenRot += [sender integerValue];
    [sender setIntegerValue:0];
    
    [nHiddenRotText setIntegerValue:nHiddenRot];
    [model setNHiddenRot:nHiddenRot];
}

-(IBAction)errorMaxNoRotTextEntered:(id)sender{
    float errorMaxNoRot = [sender floatValue];
    [model setErrorMaxNoRot:errorMaxNoRot];
}

-(IBAction)errorMaxRotTextEntered:(id)sender{
    float errorMaxRot = [sender floatValue];
    [model setErrorMaxRot:errorMaxRot];
}

-(void) updateNeuralParams{
    int nInputNoRot = [model nInputNoRot];
    int nInputRot = [model nInputRot];
    int nOutputNoRot = [model nOutputNoRot];
    int nOutputRot = [model nOutputRot];
    
    [nInputNoRotText setIntegerValue:nInputNoRot];
    [nInputRotText setIntegerValue:nInputRot];
    [nOutputNoRotText setIntegerValue:nOutputNoRot];
    [nOutputRotText setIntegerValue:nOutputRot];
}



@end
