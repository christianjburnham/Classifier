//
//  ValidateTable.m
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ValidateTable.h"

@implementation ValidateTable

-(void) awakeFromNib{
    validateArray = [NSMutableArray array];
    
    nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateTable)
               name:@"updateValidateTable"
             object:nil];
}


-(NSInteger) numberOfRowsInTableView:(NSTableView*) tv{

    return [validateArray count]+3;
}

-(id) tableView:(NSTableView*) tv
objectValueForTableColumn:(NSTableColumn *) tableColumn
            row:(NSInteger)row {
    if((int) row<[validateArray count]){
        if([[tableColumn identifier] isEqualToString:@"Correct"]){
        double correct = [validateArray[row][0] doubleValue]/[validateArray[row][1] doubleValue];
        return [NSNumber numberWithDouble:correct];
        }else if([[tableColumn identifier] isEqualToString:@"Count"]){
            return validateArray[row][1];
        }
    }else if(row == [validateArray count]+2 && [validateArray count]>0){
        if([[tableColumn identifier] isEqualToString:@"Correct"]){
            return [NSNumber numberWithDouble:fcorrect];
        }else if([[tableColumn identifier] isEqualToString:@"Count"]){
            return [NSNumber numberWithInt:nTotal];
        }
    }
    return NULL;
}

-(void) updateTable{
    NSLog(@"updating validate table");
    model = [validateWindowController model];
    validateArray = [model validateArray];

    int nCorrect = 0;
    nTotal = 0;
    for(int i = 0;i<[validateArray count]; i++){
        nCorrect+=[validateArray[i][0] intValue];
        nTotal+=[validateArray[i][1] intValue];
    }
    fcorrect = (double) nCorrect/(double) nTotal;

    
    [validateTable reloadData];

}

@end
