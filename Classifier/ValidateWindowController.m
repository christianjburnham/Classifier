//
//  ValidateWindowController.m
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ValidateWindowController.h"

@interface ValidateWindowController ()

@end

@implementation ValidateWindowController

-(id) init{
    NSLog(@"attempting init");
    self = [super initWithWindowNibName:@"Validate"];
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



@end
