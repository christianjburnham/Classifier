//
//  Upload.m
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "UploadPhoto.h"

@implementation UploadPhoto

-(IBAction)uploadButtonPressed:(id)sender{

    
    
    NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
    
    NSInteger i	= [openPanel runModal];
    if(i == NSOKButton){
    } else if(i == NSCancelButton) {
        return;
    } else {
        return;
    } // end if
    
    NSURL * fileName = [openPanel URL];
    NSData *picData = [fileName resourceDataUsingCache:NO];
    NSImage* image=[[NSImage alloc] initWithData:picData];

    int width = [model picWidth];
    int height = [model picHeight];
    
    NSSize newSize = NSMakeSize(width, height);
    [self imageResize:image newSize:newSize];
    
    
//    NSImage* image=[NSImage imageNamed:@"leafTest.tiff"];
    NSBitmapImageRep* bmp = ImageRepFromImage(image);
    
    unsigned char* data = [bmp bitmapData];
    int picHeight = (int)[bmp pixelsHigh];
    int picWidth = (int)[bmp pixelsWide];

    unsigned char* imageData = malloc(sizeof(unsigned char*)*picHeight*picWidth*4);
    for(int i = 0;i<4*picHeight*picWidth;i++){
        imageData[i] = data[i];
    }

    
    unsigned char* grid = malloc(sizeof(unsigned char)*picHeight*picWidth);
    
    int j = 0;
    for(int i = 0;i<picHeight*picWidth;i++){
        grid[i]=(data[j]+data[j+1]+data[j+2])/3.;
        j+=4;
    }
    
    
    [model setPicHeight:picHeight];
    [model setPicWidth:picWidth];
    [model setGreyPicData:grid];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"putPicFromModelIntoDrawView"
     object:self];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateDrawView"
     object:self];
    
}


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


NSBitmapImageRep *ImageRepFromImage(NSImage *image)
{
    //code taken from https://www.mikeash.com/pyblog/friday-qa-2012-08-31-obtaining-and-interpreting-image-data.html
    
    
    int width = [image size].width;
    int height = [image size].height;
    
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