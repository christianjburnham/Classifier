//
//  FitView.h
//  Classifier
//
//  Created by Christian Burnham on 10/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface FitView : NSOpenGLView{
    IBOutlet Model* model;
    NSNotificationCenter* nc;
    int inverse;
    int readyToDraw;
}

@end



