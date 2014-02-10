//
//  MainView.m
//  Classifier
//
//  Created by Christian Burnham on 03/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//


#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) awakeFromNib{
    [[self window] setBackgroundColor:[NSColor colorWithPatternImage:[NSImage imageNamed:@"textured_paper.png"]]];
}


- (void)drawRect:(NSRect)dirtyRect
{
 
}



@end







