//
//  BestClassLabelController.h
//  Classifier
//
//  Created by Christian Burnham on 12/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface BestClassLabelController : NSObject{
    IBOutlet NSTextField* bestFitLabel;
    IBOutlet Model* model;
}

@end
