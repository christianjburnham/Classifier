//
//  ClusterButtonController.h
//  Classifier
//
//  Created by Christian Burnham on 09/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface ClusterButtonController : NSObject{
    IBOutlet Model* model;
    IBOutlet NSTextField* nClusterText;

}
-(IBAction)clusterButtonPressed:(id)sender;
-(IBAction) nClusterStepped:(id) sender;
-(IBAction) nClusterTextEntered:(id)sender;
-(IBAction) calculateCluster:(id)sender;

@end
