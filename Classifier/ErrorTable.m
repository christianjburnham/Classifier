//
//  ErrorTable.m
//  Classifier
//
//  Created by Christian Burnham on 22/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ErrorTable.h"

@implementation ErrorTable

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
	
    // Drawing code here.
}


- (void)keyDown:(NSEvent *)event
{
    
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter)
    {
        
        NSMutableDictionary* coefficientsDictionary = [model coefficientsDictionary];
        NSMutableDictionary* errorDictionary = [model errorDictionary];

        if([coefficientsDictionary count]>0){
        
        NSString* selectedName = [errorTableController selectedName];

        [coefficientsDictionary removeObjectForKey:selectedName];
        [errorDictionary removeObjectForKey:selectedName];
        
        [model setCoefficientsDictionary:coefficientsDictionary];
        [model setErrorDictionary:errorDictionary];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"updateErrorTable"
         object:self];
        }
        
        return;
    }
    
    // still here?
    [super keyDown:event];
}

@end
