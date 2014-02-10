//
//  verticalLabelView.m
//  Classifier
//
//  Created by Christian Burnham on 04/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "verticalLabelView.h"

@implementation verticalLabelView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    [self rotateByAngle:90.0];
    [@"Predicted" drawAtPoint:NSMakePoint(20,-20)
                       withAttributes:nil];
    [self rotateByAngle:-90.0];}

@end
