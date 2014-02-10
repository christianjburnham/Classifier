//
//  NeuronView.h
//  Classifier
//
//  Created by Christian Burnham on 21/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface ModelImageView : NSView{
NSImage* image;
    IBOutlet Model* model;
}
@property NSImage* image;
@end
