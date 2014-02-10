//
//  ConfusionView.m
//  Classifier
//
//  Created by Christian Burnham on 03/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ConfusionView.h"

@implementation ConfusionView


-(void) awakeFromNib{

    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateView)
               name:@"updateConfusionMatrix"
             object:nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(detectMouse)
                                   userInfo:nil
                                    repeats:YES];
    validated = 0;
    max = 0;
    [confusionLabel setStringValue:@""];
    margin = 20;
    int width = [self bounds].size.width;
    boxWidth = width - margin;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    NSMutableDictionary * stringAttributes = [NSMutableDictionary dictionary];

    [stringAttributes setObject:[NSFont fontWithName:@"Helvetica" size:15] forKey:NSFontAttributeName];

    
    
    

    
	

    
    model = [validateWindowController model];

    max = (int)[[model errorDictionary] count];

    if(max>0){
        confusionArray = [model confusionArray];
        validated = [model validated];
        
        if(validated){
            
            [@"Actual" drawAtPoint:NSMakePoint(150,0)
                    withAttributes:stringAttributes];
            
            [self rotateByAngle:90.0];
            [@"Predicted" drawAtPoint:NSMakePoint(150,-20)
                       withAttributes:stringAttributes];
            [self rotateByAngle:-90.0];
            
            
            int count = 0;
            for(int i = 0; i<max; i++) {
                for(int j = 0; j<max; j++){
                    count += confusionArray[i][j];
                }
            }
            
            
            
            
    
    for(int i = 0; i<max; i++){
        NSMutableArray* patterns_list = [model patterns_list];
        int nValues = (int)[[[model coefficientsDictionary] valueForKey:patterns_list[i]] count];
        for(int j = 0; j<max; j++){
            float grey = (float)confusionArray[i][j]/(float)nValues;
//            NSLog(@"grey = %d %d %f",i,j,grey);
            [[NSColor colorWithCalibratedRed:grey green:grey blue:grey alpha:1.0f] set];

            
            
            float xOrigin = (float) margin + (float) i * boxWidth /(float) max;
            float yOrigin = (float) margin + (float) j * boxWidth /(float) max;
                
            NSRect rect = NSMakeRect(xOrigin, yOrigin, boxWidth/(float) max, boxWidth / (float) max);
    
        NSRectFill( rect ) ;
        }
    }
        
        }
    }
    
}


-(void) detectMouse{
    if(validated){
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation]; //get current mouse position
    NSPoint q=[[self window] convertScreenToBase:mouseLoc];
    NSPoint p=[self convertPoint:q fromView:nil];


    
        float fx = (p.x - margin)/ boxWidth;
        float fy = (p.y - margin)/ boxWidth;
        
        if(fx>=0 && fx<=1 && fy>=0 && fy<=1){
        int ix = (int) (fx *max);
        int iy = (int) (fy *max);
        
            NSMutableArray* patterns_list = [model patterns_list];
  

            int nValues = (int)[[[model coefficientsDictionary] valueForKey:patterns_list[ix]] count];
            
        [confusionLabel setStringValue:[NSString stringWithFormat:@"%@ classified as %@   %d / %d times",patterns_list[ix],patterns_list[iy],confusionArray[ix][iy],nValues]];

        
        
        }else{
            [confusionLabel setStringValue:@""];
        
            
            
        }
    
    }

}



-(void) updateView{
    NSLog(@"updateConfusionView");
    [self setNeedsDisplay:YES];
}

@end
