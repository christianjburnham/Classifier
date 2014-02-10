//
//  BestClassLabelController.m
//  Classifier
//
//  Created by Christian Burnham on 12/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "BestClassLabelController.h"

@implementation BestClassLabelController

-(void) awakeFromNib{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(setLabel)
               name:@"updateBestClassLabel"
             object:nil];
    
    [bestFitLabel setStringValue:@""];

}

-(void) setLabel{
    [bestFitLabel setStringValue:[NSString stringWithFormat:@"Best fit = %@",[model bestClass]]];

}

@end
