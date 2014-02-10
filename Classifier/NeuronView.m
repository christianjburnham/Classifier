//
//  NeuronView.m
//  Classifier
//
//  Created by Christian Burnham on 21/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "NeuronView.h"

@implementation NeuronView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = [NSImage imageNamed:@"nearest.png"];
        NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];

        [nc addObserver:self
               selector:@selector(updateModelImage)
                   name:@"updateModelImage"
                 object:nil];
    
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	

    [_image drawInRect: [self bounds]
             fromRect:NSMakeRect(0, 0, [_image size].width, [_image size].height)
            operation:NSCompositeSourceOver
             fraction:1.];
    
}

-(void) updateModelImage{
    int trainingModel = [model trainingModel];
    if(trainingModel == 0) _image = [NSImage imageNamed:@"nearest.png"];
    if(trainingModel == 1) _image = [NSImage imageNamed:@"neuron.png"];
    [self setNeedsDisplay:YES];
}


@end
