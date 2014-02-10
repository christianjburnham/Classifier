//
//  NmaxTextEntered.m
//  Classifier
//
//  Created by Christian Burnham on 23/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "NmaxTextEntered.h"

@implementation NmaxTextEntered
-(void) awakeFromNib{
    model = [newDatabaseWindowController model];
    [nmaxText setIntegerValue:9];
}

-(IBAction)nmaxTextEntered:(id)sender{
    int nmax = (int)[nmaxText integerValue];

    NSLog(@"nmax = %d",nmax);
    [model setN_max:nmax];
    
}

-(IBAction)nmaxStepped:(id)sender{
    int nmax = (int)[nmaxText integerValue];
    nmax+=[sender integerValue];
    [nmaxText setIntegerValue:nmax];
    [nmaxStepper setIntegerValue:0];
    [model setN_max:nmax];
}


@end
