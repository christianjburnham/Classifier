//
//  ModeRadioController.h
//  Classifier
//
//  Created by Christian Burnham on 06/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
@interface ModeRadioController : NSObject{
    IBOutlet Model* model;
    IBOutlet NSMatrix* radioButton;
    IBOutlet NSTextField* input;
}
-(IBAction)modeRadioButtonSelected:(id)sender;

-(void) selectButton;

@end
