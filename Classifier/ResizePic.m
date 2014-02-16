//
//  Resize.m
//  Classifier
//
//  Created by Christian Burnham on 16/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import "ResizePic.h"

@implementation ResizePic
-(NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    
    //code taken from
    //http://stackoverflow.com/questions/11949250/how-to-resize-nsimage
    
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid])
    {
        NSLog(@"Invalid Image");
    } else
    {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

@end
