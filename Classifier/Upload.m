//
//  Upload.m
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "Upload.h"

@implementation Upload

-(IBAction)uploadButtonPressed:(id)sender{
    NSLog(@"upload button pressed");

    NSImage* image=[NSImage imageNamed:@"3i.jpg"];
    NSBitmapImageRep* bmp = ImageRepFromImage(image);
    
    unsigned char* data = [bmp bitmapData];
    int picHeight = (int)[bmp pixelsHigh];
    int picWidth = (int)[bmp pixelsWide];

    unsigned char* imageData = malloc(sizeof(unsigned char*)*picHeight*picWidth*4);
    for(int i = 0;i<4*picHeight*picWidth;i++){
        imageData[i] = data[i];
    }

    
    [model setPicHeight:picHeight];
    [model setPicWidth:picWidth];
    [model setData:imageData];

}


@end


NSBitmapImageRep *ImageRepFromImage(NSImage *image)
{
    int width = [image size].width;
    int height = [image size].height;
    
    NSLog(@"h = %i / w = %i",height,width);
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSCalibratedRGBColorSpace
                             bytesPerRow: width * 4
                             bitsPerPixel: 32];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep: rep];
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    
    [image drawAtPoint: NSZeroPoint fromRect: NSZeroRect operation: NSCompositeCopy fraction: 1.0];
    
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}