//
//  LaunchValidateWindowController.m
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "LaunchValidateWindowController.h"

@implementation LaunchValidateWindowController

-(IBAction) launchValideateWindow:(id)sender{

    if(!validateWindowController){
        validateWindowController = [[ValidateWindowController alloc] init];
    }
    [validateWindowController setModel:model];
    [validateWindowController showWindow:self];
}


@end
