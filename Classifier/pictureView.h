//
//  pictureView.h
//  Classifier
//
//  Created by Christian Burnham on 07/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface pictureView : NSOpenGLView{
    IBOutlet Model* model;
    NSNotificationCenter* nc;
}

@end
