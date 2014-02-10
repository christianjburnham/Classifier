//
//  FitView.m
//  Classifier
//
//  Created by Christian Burnham on 10/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "FitView.h"
#import "Polynomials.h"
#import "Cmath.h"
#import <GLUT/Glut.h>

@implementation FitView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) awakeFromNib{
    nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(redraw)
               name:@"redrawFitView"
             object:nil];
    readyToDraw = 0;

        [self prepare];
}

-(void) prepare{
    NSOpenGLContext* glcontext=[self openGLContext];
    [glcontext makeCurrentContext];
    glDisable(GL_DEPTH_TEST);
    
}

-(void) redraw{
    readyToDraw = 1;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    inverse = [model inverse];
    
    int picWidth = [model fitPicWidth];
    int picHeight = [model fitPicHeight];
    
    unsigned char* fit = [model fit];
    
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
    
    if(readyToDraw){
        glBegin(GL_TRIANGLES);
        
        double deltaX = 1./picWidth;
        double deltaY = 1./picHeight;
        
        
        int pixel = 0;

        for (int y = 0; y < picHeight; y++) {
            double yf = 1.-y*deltaY;
            for (int x = 0; x < picWidth; x++) {

                double func = 0;
                
                double xf = x*deltaX;
                
                func = fit[pixel]/255.;
                pixel+=1;

                if(func<0) func = 0.;
                if(func>1.) func = 1.;

                if(inverse == 0)glColor3f(func, func, func);
                if(inverse == 1)glColor3f(1.-func, 1.-func, 1.-func);
                
                glVertex2f(xf,yf);
                glVertex2f(xf+deltaX,yf);
                glVertex2f(xf+deltaX,yf+deltaY);
                
                
                glVertex2f(xf,yf);
                glVertex2f(xf,yf+deltaY);
                glVertex2f(xf+deltaX,yf+deltaY);
            
            
            }
        }
        
        glEnd();
        
    }
    
    
    glFinish();
    
    }

@end









