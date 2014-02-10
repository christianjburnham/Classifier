//
//  ClusterView.m
//  Classifier
//
//  Created by Christian Burnham on 09/12/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "ClusterView.h"
#import <GLUT/Glut.h>


@implementation ClusterView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void) awakeFromNib{
    NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(redraw)
               name:@"redrawClusterView"
             object:nil];
    
    [self prepare];
}

-(void) prepare{
    NSOpenGLContext* glcontext=[self openGLContext];
    [glcontext makeCurrentContext];
    glDisable(GL_DEPTH_TEST);
    readyToDraw = 0;
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    if(!readyToDraw) return;
    
    inverse = [model inverse];
    
    int picWidth = [model picWidth];
    int picHeight = [model picHeight];
    unsigned char* greyPicData = [model greyPicData];
    int* belongsToCluster = [model belongsToCluster];
    int nCluster = [model nCluster];
    NSLog(@"bbb %d",belongsToCluster[0]);
    
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    glOrtho (0.,1.,
             0.,1.,
             -200.,200.);
    if(inverse == 0) glClearColor(0.0, 0.0, 0.0, 0.0);
    if(inverse == 1) glClearColor(1.0, 1.0, 1.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();
    
    if(picWidth*picHeight!=0){
        glBegin(GL_TRIANGLES);
        
        double deltaX = 1./picWidth;
        double deltaY = 1./picHeight;
        
        
        NSLog(@"picHeight, picWidth %d %d",picHeight,picWidth);
        
        
        
        float dr[nCluster],dg[nCluster],db[nCluster];
        for(int n = 0; n<nCluster; n++){
            dr[n] =0.4*( 0.5*(float) rand()/(float) RAND_MAX-1.);
            dg[n] =0.4*( 0.5*(float) rand()/(float) RAND_MAX-1.);
            db[n] =0.4*( 0.5*(float) rand()/(float) RAND_MAX-1.);
        }

        
        
        int pixel = 0;
        
        for (int y = 0; y < picHeight; y++) {
            double yf = 1.-y*deltaY;
            for (int x = 0; x < picWidth; x++) {
                
                double func = 0;
                
                double xf = x*deltaX;
                
                func = greyPicData[pixel]/255.;
                
                if(func<0) func = 0.;
                if(func>1.) func = 1.;
                
                float red,green,blue;
                
                red = func;
                green = func;
                blue = func;
                
                if(inverse == 1){
                    red = 1.-func;
                    green = 1. - func;
                    blue = 1. - func;
                };

                int n = belongsToCluster[pixel];
                    red = red + dr[n];
                    green = green +dg[n];
                    blue  = blue +db[n];

                if(red<0) red = 0.;
                if(green<0) green = 0;
                if(blue<0) blue = 0;
                if(red>1.) red = 1.;
                if(green>1.) green = 1.;
                if(blue>1.) blue = 1.;
                
                glColor3f(red, green,blue);
                
                glVertex2f(xf,yf);
                glVertex2f(xf+deltaX,yf);
                glVertex2f(xf+deltaX,yf+deltaY);
                
                
                glVertex2f(xf,yf);
                glVertex2f(xf,yf+deltaY);
                glVertex2f(xf+deltaX,yf+deltaY);
                
                pixel+=1;

            }
        }
        
        glEnd();
        
    }
    
    
    glFinish();
    

}

-(void) redraw{
    readyToDraw = 1;
    [self setNeedsDisplay:YES];
}


@end
