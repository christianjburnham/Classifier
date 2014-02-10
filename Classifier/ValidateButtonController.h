//
//  ValidateButtonController.h
//  Classifier
//
//  Created by Christian Burnham on 11/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ValidateButtonController : NSObject{
    IBOutlet Model* model;
}
-(IBAction)validateButtonPressed:(id)sender;
@end
