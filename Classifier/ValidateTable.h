//
//  ValidateTable.h
//  Classifier
//
//  Created by Christian Burnham on 20/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValidateWindowController.h"
#import "Model.h"

@interface ValidateTable : NSObject{
    IBOutlet ValidateWindowController* validateWindowController;
    IBOutlet NSTableView* validateTable;
    NSMutableArray* validateArray;
    Model* model;
    NSNotificationCenter* nc;
    
    int nTotal;
    double fcorrect;
}

@end
