//
//  NeuralWindowController.m
//  Classifier
//
//  Created by Christian Burnham on 18/02/2014.
//  Copyright (c) 2014 Christian Burnham. All rights reserved.
//

#import "NeuralWindowController.h"

@interface NeuralWindowController ()

@end

@implementation NeuralWindowController

-(id) init{
    self = [super initWithWindowNibName:@"Neural"];
    NSLog(@"neural window controller init");
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
