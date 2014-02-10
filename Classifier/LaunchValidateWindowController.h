//
//  LaunchValidateWindowController.h
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "ValidateWindowController.h"

@interface LaunchValidateWindowController : NSObject{
    IBOutlet Model* model;
    ValidateWindowController* validateWindowController;
}
-(IBAction) launchValideateWindow:(id)sender;
@end
