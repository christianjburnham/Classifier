//
//  AppDelegate.h
//  Classifier
//
//  Created by Christian Burnham on 02/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SaveController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet SaveController* saveController;
}

@property (assign) IBOutlet NSWindow *window;

@end
