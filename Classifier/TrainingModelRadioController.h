//
//  TrainingModelRadioController.h
//  Classifier
//
//  Created by Christian Burnham on 19/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "ModelImageView.h"

@interface TrainingModelRadioController : NSObject{
    IBOutlet Model* model;
    IBOutlet NSMatrix* radioButton;
}

-(IBAction)trainingModelButtonPressed:(id)sender;


@end
