//
//  NeuralGreenLight.m
//  Classifier
//
//  Created by Christian Burnham on 21/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "NeuralGreenLight.h"

@implementation NeuralGreenLight

-(void) awakeFromNib{
    status = 0;
    [super setStatus:status];
}

-(void) setStatus:(int)s{
    [super setStatus:s];
    [self setNeedsDisplay:YES];
}

@end
