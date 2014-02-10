//
//  UploadDrawing.m
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "UploadDrawing.h"

@implementation UploadDrawing

-(IBAction)uploadButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"uploadDrawingToModel"
     object:self];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"updateSelectTable"
     object:self];

}
@end
