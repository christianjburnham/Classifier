//
//  ErrorTableController.m
//  Classifier
//
//  Created by Christian Burnham on 06/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ErrorTableController.h"

@implementation ErrorTableController

-(void) awakeFromNib{
    nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateTable)
               name:@"updateErrorTable"
             object:nil];
    Name = [NSMutableArray array];
    Error = [NSMutableArray array];
    NumberOfValues = [NSMutableArray array];
}

-(id) tableView:(NSTableView*) tv
objectValueForTableColumn:(NSTableColumn *) tableColumn
            row:(NSInteger)row {
    if([[tableColumn identifier] isEqualToString:@"Name"]){
        return [Name objectAtIndex:row];
    }else if([[tableColumn identifier] isEqualToString:@"Error"]){
        return [Error objectAtIndex:row];
    }else if([[tableColumn identifier] isEqualToString:@"Count"]){
        return [NumberOfValues objectAtIndex:row];
    }
    return NULL;
}

-(NSInteger) numberOfRowsInTableView:(NSTableView*) tv{
    return [Name count];
}

-(void) tableViewSelectionDidChange:(NSNotification*) notification{
    int selectedRow = (int)[errorTable selectedRow];
    if(selectedRow<[Name count]){
    NSString* patternName = [Name objectAtIndex:selectedRow];
    [patternNameTextField setStringValue:patternName];
    [model setPatternName:patternName];
    _selectedName = patternName;
    }
}

-(IBAction)enterPatternName:(id)sender{
    NSString* name = [patternNameTextField stringValue];
    [model setPatternName:name];
}


-(void) updateTable{
    
    NSMutableDictionary* errorDictionary = [model errorDictionary];
    NSMutableDictionary* coefficientsDictionary = [model coefficientsDictionary];

    Name = [NSMutableArray array];
    Error = [NSMutableArray array];
    NumberOfValues = [NSMutableArray array];
    
    if([errorDictionary count]>0){
        
        
        int trainingModel = [model trainingModel];
        
        //sort matches dictionary by error
        NSArray* sortedKeys = [errorDictionary keysSortedByValueUsingComparator:^(id first, id second) {
            if(trainingModel == 0){
            if ([first doubleValue] > [second doubleValue])
                return (NSComparisonResult)NSOrderedDescending;
            
            if ([first doubleValue] < [second doubleValue])
                return (NSComparisonResult)NSOrderedAscending;
            }else if(trainingModel == 1){
                if ([first doubleValue] > [second doubleValue])
                    return (NSComparisonResult)NSOrderedAscending;
                
                if ([first doubleValue] < [second doubleValue])
                    return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        

        
        for(int i = 0; i<[sortedKeys count]; i++){
            [Name addObject:sortedKeys[i]];
            double error = [[errorDictionary valueForKey:sortedKeys[i]] doubleValue];
            if(!isnan(error)){
            [Error addObject:[errorDictionary valueForKey:sortedKeys[i]]];
            }else{
            [Error addObject:@" "];
            }
            int count = (int)[[coefficientsDictionary valueForKey:sortedKeys[i]] count];
            [NumberOfValues addObject:[NSNumber numberWithInt:count]];
        }
        
    }//if([errorDictionary count]>0)
    
    
    int training = [model training];
    
    if(training == 1){
        NSString* patternName = [model patternName];
        if([patternName length] > 0
           && ![Name containsObject:patternName]){
               [Name addObject:patternName];
               [Error addObject:@" "];
               [NumberOfValues addObject:[NSNumber numberWithInt:1]];
        }
    }
    
    


    


        [errorTable reloadData];
}



@end
