//
//  SaveController.m

//  Classifier//
//  Created by Christian Burnham on 07/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "SaveController.h"

@implementation SaveController

-(void) awakeFromNib{
    defaultFileName = @"";
    defaultPath = @"";
}

-(IBAction)doSaveAs:(id)pId{
    
    NSSavePanel *savePanel	= [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"clsf"]];

    defaultFileName = [NSMutableString string];
    NSString* databaseName = [model databaseName];
    [defaultFileName appendString:databaseName];
    [defaultFileName appendString:@".clsf"];

    
    [savePanel setNameFieldStringValue:defaultFileName];
    [savePanel setDirectoryURL:[NSURL fileURLWithPath:defaultPath]];
    
    int i	= (int)[savePanel runModal];
    if(i == NSOKButton){
    } else if(i == NSCancelButton) {
     	return;
    } else {
     	return;
    } // end if

//change model's databasename based on new filename
    NSURL * fileName = [savePanel URL];
    defaultPath = [fileName path];
    NSString* nameOfFile = [[fileName path] lastPathComponent];
    defaultFileName = [nameOfFile componentsSeparatedByString:@"."][0];
    [model setDatabaseName:defaultFileName];

    [model setDatabaseName:defaultFileName];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"resetDatabaseLabel"
     object:self];
    
    
    NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];

    NSMutableDictionary* coefficientsDictionary = [model coefficientsDictionary];
    [rootObject setValue:coefficientsDictionary forKey:@"coefficientsDictionary"];
    
    NSNumber* nmax = [NSNumber numberWithInt:[model n_max]];
    [rootObject setValue:nmax forKey:@"nmax"];

    [NSKeyedArchiver archiveRootObject:rootObject toFile: [fileName path]];
    
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:fileName];
}
-(IBAction)doOpen:(id)pId{
    NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"clsf"]];

    NSInteger i	= [openPanel runModal];
    if(i == NSOKButton){
    } else if(i == NSCancelButton) {
        return;
    } else {
        return;
    } // end if
    
    NSURL * fileName = [openPanel URL];
    NSMutableDictionary* parameters=[NSKeyedUnarchiver unarchiveObjectWithFile:[fileName path]];
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:fileName];

    defaultPath = [fileName path];
    NSString* nameOfFile = [[fileName path] lastPathComponent];
    defaultFileName = [nameOfFile componentsSeparatedByString:@"."][0];
    
    
    [model setDatabaseName:defaultFileName];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"resetDatabaseLabel"
     object:self];
    
    NSMutableDictionary* coefficientsDictionary = [parameters valueForKey:@"coefficientsDictionary"];
    [model setCoefficientsDictionary:coefficientsDictionary];
    int nmax = (int)[[parameters valueForKey:@"nmax"] integerValue];
    [model setN_max:nmax];
    
    [model setTraining:0];
    
    [model createNeuralNet];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"uploadDrawingToModel"
     object:self];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"selectRadioButton"
     object:self];
    
    [model calculate];
}

@end
