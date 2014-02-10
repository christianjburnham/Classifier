//
//  SelectTableController.m
//  Classifier
//
//  Created by Christian Burnham on 04/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "SelectTableController.h"

@implementation SelectTableController

-(void) awakeFromNib{
    nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateTable)
               name:@"updateSelectTable"
             object:nil];
    list = [NSMutableArray array];


}

-(void) tableViewSelectionDidChange:(NSNotification*) notification{
    NSLog(@"selection did change");
    [patternNameTextField setStringValue:@"fff"];
    int selectedRow = (int)[selectTable selectedRow];
    NSString* patternName = [list objectAtIndex:selectedRow];
    [patternNameTextField setStringValue:patternName];
    [model setPatternName:patternName];
}


-(id) tableView:(NSTableView*) tv
objectValueForTableColumn:(NSTableColumn *) tableColumn
            row:(NSInteger)row {
    if([[tableColumn identifier] isEqualToString:@"Name"])return [list objectAtIndex:row];
    return NULL;
}


-(NSInteger) numberOfRowsInTableView:(NSTableView*) tv{
    return [list count];
}

-(void) updateTable{
    NSDictionary* dictionary = [model dictionary];
    list = [NSMutableArray array];
    for(id key in dictionary){
        [list addObject:key];
    }

    [selectTable reloadData];
}

-(IBAction)enterPatternName:(id)sender{
    NSString* name = [patternNameTextField stringValue];
    [model setPatternName:name];
}


@end
