//
//  NewModelWindowController.h
//  Classifier
//
//  Created by Christian Burnham on 22/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface NewDatabaseWindowController : NSWindowController{
    Model* model;
}

@property Model* model;
@end
