//
//  GridView.h
//  Tiled
//
//  Created by Matt Donahoe on 11/20/08.
//  Copyright Serious Sandbox LLC 2008. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Texture2D.h"


#define WIDTH 12
#define NN 3*WIDTH*WIDTH/2

@class Texture2D;

@interface GridView : UIView {

@private
    GLint backingWidth;
    GLint backingHeight;
    float angle[NN];
	float vel[NN];
	float acc[NN];
	float lite[3];
	int litemode;
	int width;
    EAGLContext *context;
    GLuint viewRenderbuffer, viewFramebuffer;
    GLuint depthRenderbuffer;
}

@property (nonatomic, retain) NSTimer *animationTimer;
@property NSTimeInterval animationInterval;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;

@end
