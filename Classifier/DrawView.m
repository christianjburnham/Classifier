//
//  DrawView.m
//  Classifier
//
//  Created by Christian Burnham on 29/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "DrawView.h"
#import <GLUT/Glut.h>


@implementation DrawView




-(void) awakeFromNib{
    nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(uploadDrawingToModel)
               name:@"uploadDrawingToModel"
             object:nil];
    [nc addObserver:self
           selector:@selector(clearDrawing)
               name:@"clearDrawing"
             object:nil];
    [nc addObserver:self
           selector:@selector(getPicFromModel)
               name:@"putPicFromModelIntoDrawView"
             object:nil];
    [nc addObserver:self
           selector:@selector(updateDrawView)
               name:@"updateDrawView"
             object:nil];
    
    
    [self prepare];
}

-(void) prepare{
    NSOpenGLContext* glcontext=[self openGLContext];
    [glcontext makeCurrentContext];
    glDisable(GL_DEPTH_TEST);

    max = [model picHeightMax];
    grid = malloc(sizeof(unsigned char)*max*max);
    for(int i = 0;i<max*max;i++){
        grid[i] = 0.0;
    }
    
    
    [model setGreyPicData:grid];

}


-(void) uploadDrawingToModel{
    [model setPicHeight:max];
    [model setPicWidth:max];
    [model setGreyPicData:grid];
}

-(void) clearDrawing{
    int k = 0;
    for(int i = 0;i<max;i++){
        for(int j = 0;j < max; j++){
            grid[k] = 0;
            k++;
        }
    }
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    inverse = [model inverse];
    
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
    
    float deltaX = 1./(float) max;
    float deltaY = 1./(float) max;
    float greyScale;
    
    glBegin(GL_TRIANGLES);

    
    int i =0;
    for (int y = 0; y < max; y++) {
        float yf = 1.-y*deltaY;
        for (int x = 0; x < max; x++) {
            float xf = x*deltaX;
            greyScale = grid[i]/255.;
            i++;
            
            
            if(inverse == 0)glColor3f(greyScale, greyScale, greyScale);
            if(inverse == 1)glColor3f(1.-greyScale, 1.-greyScale, 1.-greyScale);
            
            
            glVertex2f(xf,yf);
            glVertex2f(xf+deltaX,yf);
            glVertex2f(xf+deltaX,yf+deltaY);
            
            
            glVertex2f(xf,yf);
            glVertex2f(xf,yf+deltaY);
            glVertex2f(xf+deltaX,yf+deltaY);
        }
    }

    glEnd();
    
    
    glFinish();

}

-(void) updateDrawView{
        max = [model picHeight];
    [self setNeedsDisplay:YES];
}

-(void) getPicFromModel{
    grid = [model greyPicData];
}


-(BOOL) acceptsFirstResponder{
    [self setNeedsDisplay:YES];
    return YES;
    
}

-(BOOL) resignFirstResponder{
    [self setKeyboardFocusRingNeedsDisplayInRect:[self bounds]];
    return YES;
}

-(void) mouseDragged:(NSEvent *)theEvent{
    [self drawCircle:theEvent];
    [self setNeedsDisplay:YES];
}


-(void) mouseDown:(NSEvent *)theEvent{
    [self drawCircle:theEvent];
    [self setNeedsDisplay:YES];
}


-(void) drawCircle:(NSEvent *) theEvent{
    NSPoint p=[theEvent locationInWindow];
    NSPoint point=[self convertPoint:p fromView:nil];
    
    NSRect bounds = [self bounds];
    
    float xf = (float)point.x/(float)bounds.size.width;
    float yf = (float)point.y/(float)bounds.size.height;

    if(xf>=0 && xf<=1. && yf >=0 && yf <=1.){
    
        float maxi = 1./(float) max;

        float penRadius2 = 0.0005;
    for(int i = 0;i<max;i++){
        float xf2 = (float) i *maxi;
        float xx = (xf2-xf)*(xf2-xf);
        if(xx<penRadius2){
        for(int j = 0;j<max;j++){
            float yf2 = (float) j *maxi;
            float yy = (yf2-yf)*(yf2-yf);

            if(yy<penRadius2){
            float r2 = xx+yy;
            if(r2<penRadius2) {
                
                grid[i+(max-j)*max] = 255.;
            }
            }
        }
            
        }
    }
    }
    
    
    
    
    
}



@end
