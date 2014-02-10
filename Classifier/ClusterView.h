//
//  ClusterView.h
//  Classifier
//
//  Created by Christian Burnham on 09/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"


@interface ClusterView : NSOpenGLView{
IBOutlet Model* model;
    int inverse;
    int readyToDraw;
}



@end
