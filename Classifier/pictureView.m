//
//  pictureView.m
//  Classifier
//
//  Created by Christian Burnham on 07/10/2013.
//  Copyright (c) 2013 Christian Burnham. All rights reserved.
//

#import "pictureView.h"
#import <GLUT/Glut.h>

@implementation pictureView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
   }
    
    return self;
}


-(id) init{

    
    return self;
}



-(void) awakeFromNib{
    nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(redraw)
               name:@"redrawPictureView"
             object:nil];
    
    [self prepare];
}


-(void) prepare{

    NSOpenGLContext* glcontext=[self openGLContext];
    [glcontext makeCurrentContext];
    glDisable(GL_DEPTH_TEST);


}

-(void) redraw{
    [self setNeedsDisplay:YES];
}


- (void)drawRect:(NSRect)dirtyRect
{
    
    int picWidth = [model picWidth];
    int picHeight = [model picHeight];
    


    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    glOrtho (0.,1.,
             0.,1.,
             -200.,200.);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode (GL_MODELVIEW);
    glLoadIdentity();
    
    
    if(picWidth*picHeight!=0){
        unsigned char* greyPicData = [model greyPicData];

        glBegin(GL_TRIANGLES);

        float greyScale;
        
        float deltaX = 1./picWidth;
        float deltaY = 1./picHeight;
        
        int i =0;
        for (int y = 0; y < picHeight; y++) {
            float yf = 1.-y*deltaY;
            for (int x = 0; x < picWidth; x++) {
                float xf = x*deltaX;
                
                greyScale = greyPicData[i]/255.;
                i++;


                
                glColor3f(greyScale, greyScale, greyScale);

                glVertex2f(xf,yf);
                glVertex2f(xf+deltaX,yf);
                glVertex2f(xf+deltaX,yf+deltaY);

                
                glVertex2f(xf,yf);
                glVertex2f(xf,yf+deltaY);
                glVertex2f(xf+deltaX,yf+deltaY);
                

            }
        }

    }
    glEnd();
    

    
    glFinish();

}

@end
