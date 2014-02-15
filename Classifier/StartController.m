//
//  StartController.m
//  Classifier
//
//  Created by Christian Burnham on 07/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "StartController.h"

@implementation StartController

-(IBAction) startButtonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"uploadDrawingToModel"
     object:self];
    

    NSString* patternName = [patternNameTextField stringValue];
    
    patternName = [patternName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    [model setPatternName:patternName];

    int training = [model training];
    
    if(training == 1 && [patternName length] == 0){
        NSAlert *alert = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"Ok" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Pattern must first be named"];
        [alert runModal];
    }else{
    [model calculate];
    }
    };


@end
