//
//  ErrorTable.h
//  Classifier
//
//  Created by Christian Burnham on 22/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "ErrorTableController.h"

@interface ErrorTable : NSTableView{
    IBOutlet Model* model;
    IBOutlet ErrorTableController* errorTableController;
}


@end
