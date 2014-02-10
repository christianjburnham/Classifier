//
//  NewModel.h
//  Classifier
//
//  Created by Christian Burnham on 22/11/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewDatabaseWindowController.h"
#import "Model.h"

@interface NewDatabase : NSObject{
    NewDatabaseWindowController* newDatabaseWindowController;
    IBOutlet Model* model;
}
-(IBAction) createNewDatabase:(id)sender;


@end
