//
//  RunValidateController.m
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "RunValidateController.h"

@implementation RunValidateController

-(void) awakeFromNib{
    model = [validateWindowController model];
    int nValidate = [model nValidate];
    [kText setIntegerValue:nValidate];
    NSLog(@"nValidate = %d",nValidate);
}


-(IBAction) runValidate:(id)sender{
    NSLog(@"run validate");
    model  = [validateWindowController model];
    [model validate];
}

-(IBAction) kEntered:(id)sender{
    int nValidate = [sender intValue];
    NSLog(@"nValidate = %d",nValidate);
    [model setNValidate:nValidate];
}

-(IBAction)kStepped:(id)sender{
    int nValidate = [kText intValue];
    nValidate+=[kStepper intValue];
    [kStepper setIntegerValue:0];
    [kText setIntegerValue:nValidate];
    [model setNValidate:nValidate];
}


@end
