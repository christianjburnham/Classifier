//
//  Upload.h
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "ResizePic.h"

@interface UploadPhoto : NSObject{
    IBOutlet Model* model;
}
-(IBAction)uploadButtonPressed:(id)sender;
@end

//NSBitmapImageRep *ImageRepFromImage(NSImage *image);
