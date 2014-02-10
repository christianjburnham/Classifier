//
//  ValidateButtonController.m
//  Classifier
//
//  Created by Christian Burnham on 11/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ValidateButtonController.h"


@implementation ValidateButtonController
-(IBAction)validateButtonPressed:(id)sender{
    [model validate];
}
@end
