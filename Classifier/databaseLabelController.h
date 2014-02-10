//
//  DatabaseLabelController.h
//  Classifier
//
//  Created by Christian Burnham on 24/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface DatabaseLabelController : NSObject{
    IBOutlet Model* model;
    IBOutlet NSTextField* databaseLabel;
}

-(void)resetDatabaseLabel;

@end
