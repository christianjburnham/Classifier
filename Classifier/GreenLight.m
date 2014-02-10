//
//  GreenLight.m
//  Classifier
//
//  Created by Christian Burnham on 21/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "GreenLight.h"

@implementation GreenLight

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void) awakeFromNib{
    _status = 0;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    NSImage* image;
    if(_status == 0) image = [NSImage imageNamed:@"status-away.tiff"];
    if(_status == 1) image=[NSImage imageNamed:@"status-available.tiff"];
        [image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
}

-(void) redraw{
    [self setNeedsDisplay:YES];
}

@end
