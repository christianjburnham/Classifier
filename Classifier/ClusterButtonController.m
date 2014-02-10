//
//  ClusterButtonController.m
//  Classifier
//
//  Created by Christian Burnham on 09/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ClusterButtonController.h"

@implementation ClusterButtonController

-(id) init{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateNClusterText)
               name:@"updateNClusterText"
             object:nil];
    return  self;
}



-(IBAction)clusterButtonPressed:(id)sender{
    [model cluster];
}
-(IBAction) nClusterStepped:(id) sender{
    int nCluster = [model nCluster];
    nCluster += [sender integerValue];
    [sender setIntegerValue:0];
    [nClusterText setIntegerValue:nCluster];
    [model setNCluster:nCluster];
}
-(IBAction) nClusterTextEntered:(id)sender{
    int nCluster = (int)[sender integerValue];
    [model setNCluster:nCluster];
}

-(void) updateNClusterText{
    int nCluster = [model nCluster];
    [nClusterText setIntegerValue:nCluster];
}

-(IBAction) calculateCluster:(id)sender{
    [model calculateCluster];
}

@end
