//
//  DrawView.h
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface DrawView : NSOpenGLView{
    NSPoint startPoint;
    unsigned char* grid;
    int max;
    NSNotificationCenter* nc;
    IBOutlet Model* model;
    int inverse;
}
@property unsigned char* grid;
@property int max;
@end
