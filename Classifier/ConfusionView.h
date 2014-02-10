//
//  ConfusionView.h
//  Classifier
//
//  Created by Christian Burnham on 03/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "ValidateWindowController.h"

@interface ConfusionView : NSView{
    IBOutlet ValidateWindowController* validateWindowController;
    Model* model;
    int validated;
    int max;
    int boxWidth;
    int** confusionArray;
    IBOutlet NSTextField* confusionLabel;
    int margin;
}
@end
