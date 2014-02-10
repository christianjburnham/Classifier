//
//  BuildNetController.h
//  Classifier
//
//  Created by Christian Burnham on 18/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface BuildNetController : NSObject{
    IBOutlet  Model* model;
}
-(IBAction)buildNetButtonPressed:(id)sender;

@end
