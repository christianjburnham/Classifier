//
//  InvariantController.h
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface InvariantController : NSObject{
    IBOutlet Model* model;
    IBOutlet NSButton* rotationButton;
}

-(IBAction)rotationButtonPressed:(id)sender;


@end
