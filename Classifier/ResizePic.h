//
//  Resize.h
//  Classifier
//
//  Created by Christian Burnham on 16/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResizePic : NSObject
-(NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize;
@end
