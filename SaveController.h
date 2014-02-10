//
//  SaveController.h
//  Classifier
//
//  Created by Christian Burnham on 07/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface SaveController : NSMenu{
    IBOutlet Model* model;
    NSMutableString* defaultFileName;
    NSString* defaultPath;
}
- (IBAction)doSaveAs:(id)pId;
- (IBAction)doOpen:(id)pId;
@end
