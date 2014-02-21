//
//  AppDelegate.m
//  Classifier
//
//  Created by Christian Burnham on 02/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename{
    [saveController openFile:filename];
    
    return YES;
}


@end
