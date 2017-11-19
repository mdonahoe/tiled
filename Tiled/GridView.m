//
//  GridView.m
//  Tiled
//
//  Created by Matt Donahoe on 11/20/08.
//  Copyright Serious Sandbox LLC 2008. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "GridView.h"

#define USE_DEPTH_BUFFER 1


// A class extension to declare private methods
@interface GridView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation GridView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            return nil;
        }
        width = WIDTH;
        lite[0] = 0.3;
        lite[1] = 0.0;
        lite[2] = 0.3;
        litemode = 1;
        for (int i=0;i<3*width*width/2;i++){
            angle[i] = arc4random()%2 * 360*3;
        }
        glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);//, GL_ONE);
        // Enable blending
        glEnable(GL_BLEND);
        glEnable(GL_LIGHT0);
        glEnable(GL_LIGHTING);
        // Create light components
        GLfloat ambientLight[] = { 0.2f, 0.2f, 0.2f, 1.0f };
        GLfloat diffuseLight[] = { 0.8f, 0.8f, 0.8, 1.0f };
        GLfloat specularLight[] = { 0.5f, 0.5f, 0.5f, 1.0f };
        GLfloat position[] = { 1.5f, 1.0f, 4.0f, 0.0f };
        
        // Assign created components to GL_LIGHT0
        glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
        glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
        glLightfv(GL_LIGHT0, GL_SPECULAR, specularLight);
        glLightfv(GL_LIGHT0, GL_POSITION, position);
        
        glEnable(GL_DEPTH_TEST);
        glDisable(GL_DITHER);
        glShadeModel(GL_SMOOTH);
        
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_VERTEX_ARRAY);
    }
    return self;
}
- (void) drawBlock {
    
    static const GLfloat vp[] = {
        -0.463841,-0.125,-0.463841,
        0.463841,-0.125,-0.463841,
        0.463841,-0.125,0.463841,
        -0.463841,-0.125,-0.463841,
        0.463841,-0.125,0.463841,
        -0.463841,-0.125,0.463841,
        0.463841,-0.088841,0.5,
        0.463841,0.088841,0.5,
        -0.463841,0.088841,0.5,
        0.463841,-0.088841,0.5,
        -0.463841,0.088841,0.5,
        -0.463841,-0.088841,0.5,
        -0.5,0.088841,0.463841,
        -0.5,0.088841,-0.463841,
        -0.5,-0.088841,-0.463841,
        -0.5,0.088841,0.463841,
        -0.5,-0.088841,-0.463841,
        -0.5,-0.088841,0.463841,
        0.5,-0.088841,-0.463841,
        0.5,0.088841,-0.463841,
        0.5,0.088841,0.463841,
        0.5,-0.088841,-0.463841,
        0.5,0.088841,0.463841,
        0.5,-0.088841,0.463841,
        0.463841,0.125,0.463841,
        0.463841,0.125,-0.463841,
        -0.463841,0.125,-0.463841,
        0.463841,0.125,0.463841,
        -0.463841,0.125,-0.463841,
        -0.463841,0.125,0.463841,
        0.463841,0.088841,-0.5,
        0.463841,-0.088841,-0.5,
        -0.463841,-0.088841,-0.5,
        0.463841,0.088841,-0.5,
        -0.463841,-0.088841,-0.5,
        -0.463841,0.088841,-0.5,
        -0.463841,-0.125,0.463841,
        -0.5,-0.088841,0.463841,
        -0.5,-0.088841,-0.463841,
        -0.463841,-0.125,0.463841,
        -0.5,-0.088841,-0.463841,
        -0.463841,-0.125,-0.463841,
        -0.463841,-0.088841,0.5,
        -0.463841,-0.125,0.463841,
        0.463841,-0.125,0.463841,
        -0.463841,-0.088841,0.5,
        0.463841,-0.125,0.463841,
        0.463841,-0.088841,0.5,
        -0.5,-0.088841,0.463841,
        -0.463841,-0.088841,0.5,
        -0.463841,0.088841,0.5,
        -0.5,-0.088841,0.463841,
        -0.463841,0.088841,0.5,
        -0.5,0.088841,0.463841,
        0.5,-0.088841,0.463841,
        0.463841,-0.125,0.463841,
        0.463841,-0.125,-0.463841,
        0.5,-0.088841,0.463841,
        0.463841,-0.125,-0.463841,
        0.5,-0.088841,-0.463841,
        0.463841,-0.088841,0.5,
        0.5,-0.088841,0.463841,
        0.5,0.088841,0.463841,
        0.463841,-0.088841,0.5,
        0.5,0.088841,0.463841,
        0.463841,0.088841,0.5,
        -0.5,0.088841,0.463841,
        -0.463841,0.125,0.463841,
        -0.463841,0.125,-0.463841,
        -0.5,0.088841,0.463841,
        -0.463841,0.125,-0.463841,
        -0.5,0.088841,-0.463841,
        -0.463841,0.125,0.463841,
        -0.463841,0.088841,0.5,
        0.463841,0.088841,0.5,
        -0.463841,0.125,0.463841,
        0.463841,0.088841,0.5,
        0.463841,0.125,0.463841,
        0.463841,0.125,0.463841,
        0.5,0.088841,0.463841,
        0.5,0.088841,-0.463841,
        0.463841,0.125,0.463841,
        0.5,0.088841,-0.463841,
        0.463841,0.125,-0.463841,
        -0.5,0.088841,-0.463841,
        -0.463841,0.088841,-0.5,
        -0.463841,-0.088841,-0.5,
        -0.5,0.088841,-0.463841,
        -0.463841,-0.088841,-0.5,
        -0.5,-0.088841,-0.463841,
        -0.463841,0.088841,-0.5,
        -0.463841,0.125,-0.463841,
        0.463841,0.125,-0.463841,
        -0.463841,0.088841,-0.5,
        0.463841,0.125,-0.463841,
        0.463841,0.088841,-0.5,
        0.463841,0.088841,-0.5,
        0.5,0.088841,-0.463841,
        0.5,-0.088841,-0.463841,
        0.463841,0.088841,-0.5,
        0.5,-0.088841,-0.463841,
        0.463841,-0.088841,-0.5,
        -0.463841,-0.125,-0.463841,
        -0.463841,-0.088841,-0.5,
        0.463841,-0.088841,-0.5,
        -0.463841,-0.125,-0.463841,
        0.463841,-0.088841,-0.5,
        0.463841,-0.125,-0.463841,
        -0.5,-0.088841,0.463841,
        -0.463841,-0.125,0.463841,
        -0.463841,-0.088841,0.5,
        0.463841,-0.125,0.463841,
        0.5,-0.088841,0.463841,
        0.463841,-0.088841,0.5,
        -0.463841,0.125,0.463841,
        -0.5,0.088841,0.463841,
        -0.463841,0.088841,0.5,
        0.5,0.088841,0.463841,
        0.463841,0.125,0.463841,
        0.463841,0.088841,0.5,
        -0.463841,0.088841,-0.5,
        -0.5,0.088841,-0.463841,
        -0.463841,0.125,-0.463841,
        0.5,0.088841,-0.463841,
        0.463841,0.088841,-0.5,
        0.463841,0.125,-0.463841,
        -0.463841,-0.125,-0.463841,
        -0.5,-0.088841,-0.463841,
        -0.463841,-0.088841,-0.5,
        0.5,-0.088841,-0.463841,
        0.463841,-0.125,-0.463841,
        0.463841,-0.088841,-0.5
    };
    static const GLfloat vn[] = {
        0.0,-1.0,0.0,
        0.0,-1.0,0.0,
        0.0,-1.0,0.0,
        0.0,-1.0,0.0,
        0.0,-1.0,0.0,
        0.0,-1.0,0.0,
        0.0,0.0,1.0,
        0.0,0.0,1.0,
        0.0,0.0,1.0,
        0.0,0.0,1.0,
        0.0,0.0,1.0,
        0.0,0.0,1.0,
        -1.0,0.0,0.0,
        -1.0,0.0,0.0,
        -1.0,0.0,0.0,
        -1.0,0.0,0.0,
        -1.0,0.0,0.0,
        -1.0,0.0,0.0,
        1.0,0.0,0.0,
        1.0,0.0,0.0,
        1.0,0.0,0.0,
        1.0,0.0,0.0,
        1.0,0.0,0.0,
        1.0,0.0,0.0,
        0.0,1.0,0.0,
        0.0,1.0,0.0,
        0.0,1.0,0.0,
        0.0,1.0,0.0,
        0.0,1.0,0.0,
        0.0,1.0,0.0,
        0.0,0.0,-1.0,
        0.0,0.0,-1.0,
        0.0,0.0,-1.0,
        0.0,0.0,-1.0,
        0.0,0.0,-1.0,
        0.0,0.0,-1.0,
        -0.707107,-0.707107,0.0,
        -0.707107,-0.707107,0.0,
        -0.707107,-0.707107,0.0,
        -0.707107,-0.707107,0.0,
        -0.707107,-0.707107,0.0,
        -0.707107,-0.707107,0.0,
        0.0,-0.707107,0.707107,
        0.0,-0.707107,0.707107,
        0.0,-0.707107,0.707107,
        0.0,-0.707107,0.707107,
        0.0,-0.707107,0.707107,
        0.0,-0.707107,0.707107,
        -0.707107,0.0,0.707107,
        -0.707107,0.0,0.707107,
        -0.707107,0.0,0.707107,
        -0.707107,0.0,0.707107,
        -0.707107,0.0,0.707107,
        -0.707107,0.0,0.707107,
        0.707107,-0.707107,0.0,
        0.707107,-0.707107,0.0,
        0.707107,-0.707107,0.0,
        0.707107,-0.707107,0.0,
        0.707107,-0.707107,0.0,
        0.707107,-0.707107,0.0,
        0.707107,0.0,0.707107,
        0.707107,0.0,0.707107,
        0.707107,0.0,0.707107,
        0.707107,0.0,0.707107,
        0.707107,0.0,0.707107,
        0.707107,0.0,0.707107,
        -0.707107,0.707107,0.0,
        -0.707107,0.707107,0.0,
        -0.707107,0.707107,0.0,
        -0.707107,0.707107,0.0,
        -0.707107,0.707107,0.0,
        -0.707107,0.707107,0.0,
        0.0,0.707107,0.707107,
        0.0,0.707107,0.707107,
        0.0,0.707107,0.707107,
        0.0,0.707107,0.707107,
        0.0,0.707107,0.707107,
        0.0,0.707107,0.707107,
        0.707107,0.707107,0.0,
        0.707107,0.707107,0.0,
        0.707107,0.707107,0.0,
        0.707107,0.707107,0.0,
        0.707107,0.707107,0.0,
        0.707107,0.707107,0.0,
        -0.707107,0.0,-0.707107,
        -0.707107,0.0,-0.707107,
        -0.707107,0.0,-0.707107,
        -0.707107,0.0,-0.707107,
        -0.707107,0.0,-0.707107,
        -0.707107,0.0,-0.707107,
        0.0,0.707107,-0.707107,
        0.0,0.707107,-0.707107,
        0.0,0.707107,-0.707107,
        0.0,0.707107,-0.707107,
        0.0,0.707107,-0.707107,
        0.0,0.707107,-0.707107,
        0.707107,0.0,-0.707107,
        0.707107,0.0,-0.707107,
        0.707107,0.0,-0.707107,
        0.707107,0.0,-0.707107,
        0.707107,0.0,-0.707107,
        0.707107,0.0,-0.707107,
        0.0,-0.707107,-0.707107,
        0.0,-0.707107,-0.707107,
        0.0,-0.707107,-0.707107,
        0.0,-0.707107,-0.707107,
        0.0,-0.707107,-0.707107,
        0.0,-0.707107,-0.707107,
        -0.57735,-0.57735,0.57735,
        -0.57735,-0.57735,0.57735,
        -0.57735,-0.57735,0.57735,
        0.57735,-0.57735,0.57735,
        0.57735,-0.57735,0.57735,
        0.57735,-0.57735,0.57735,
        -0.57735,0.57735,0.57735,
        -0.57735,0.57735,0.57735,
        -0.57735,0.57735,0.57735,
        0.57735,0.57735,0.57735,
        0.57735,0.57735,0.57735,
        0.57735,0.57735,0.57735,
        -0.57735,0.57735,-0.57735,
        -0.57735,0.57735,-0.57735,
        -0.57735,0.57735,-0.57735,
        0.57735,0.57735,-0.57735,
        0.57735,0.57735,-0.57735,
        0.57735,0.57735,-0.57735,
        -0.57735,-0.57735,-0.57735,
        -0.57735,-0.57735,-0.57735,
        -0.57735,-0.57735,-0.57735,
        0.57735,-0.57735,-0.57735,
        0.57735,-0.57735,-0.57735,
        0.57735,-0.57735,-0.57735
    };
    
    glNormalPointer(GL_FLOAT, 0, vn);
    glVertexPointer(3, GL_FLOAT, 0, vp);
    float mcolor[] = { lite[0], lite[1], lite[2], 1.0f};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, mcolor);
    glDrawArrays(GL_TRIANGLES, 0, 132);
    
}
- (void)drawView {
    [EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
    float a = 480.0/320.0;
    glFrustumf(-1.0, 1.0, -a, a, 1.0, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glScalef(2,2,.5);
    //int width = (int)angle/180 + 1;
    int height = 480*width/320;
    //height = width = 8;
    
    int small = (width<height)?width:height;
    
    glTranslatef(0, 0, -2.1*small-1);
    float b = 1+.5/small;
    glScalef(b, b, 1);
    int A,B,C;
    A = litemode==0;
    B = litemode==1;
    C = litemode==2;
    
    for (int i=0;i<width*height;i++){
        glPushMatrix();
        float x = i%width - (float)(width-1)/2;
        float y = i/width - (float)(height-1)/2;
        
        glTranslatef(x,y,0);
        //float gamma = 1.0 / (1.0 + 1.0 / angle[i] / angle[i] );
        float alpha = .5*(cos(angle[i]/360.0*3.14159)+1.0);
        float beta = 1-alpha;
        lite[0] = (0.5*(A*alpha + B*beta)+C*lite[0]);
        lite[1] = (0.5*(C*alpha + A*beta)+B*lite[1]);
        lite[2] = (0.5*(B*alpha + C*beta)+A*lite[2]);
        glRotatef(angle[i]+90, 1, 0, 0);
        
        vel[i]+=.1*acc[i]-.05*vel[i];
        angle[i]+=.1*vel[i] - 5*sin(angle[i]/180.0*3.14159);
        
        float temp = 0;
        int n=0;
        
        int index;
        
        index = i+1;
        if (i/width==index/width) {
            temp+=angle[index];
            n++;
        }
        
        index = i-1;
        if (index>=0 && i/width==index/width) {
            temp+=angle[index];
            n++;
        }
        
        index = i+width;
        if (index<width*height) {
            temp+=angle[index];
            n++;
        }
        
        index = i-width;
        if (index>=0) {
            temp+=angle[index];
            n++;
        }
        
        acc[i] = (temp - (float)n*angle[i]);
        [self drawBlock];
        
        glPopMatrix();
    }
    
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

- (void) setSpeed:(float)s atPoint:(CGPoint)pos{
    int bw = backingWidth / width;
    int index = width * ((int)(backingHeight - MAX(MIN(475,pos.y),20))/bw) + (int)MAX(MIN(310,pos.x),3)/bw;
    index = MIN(MAX(0,index),NN-1);
    //angle[index] = 90;
    vel[index] = 10*s;
}

- (void) setColor{
    
    lite[0] = arc4random()%1000 / 1000.0;
    lite[1] = arc4random()%1000 / 1000.0;
    lite[2] = arc4random()%1000 / 1000.0;
    
    litemode = arc4random()%3;
    
    float mag = sqrt(lite[0]*lite[0]+lite[1]*lite[1]+lite[2]*lite[2]);
    lite[0]/=mag*2;
    lite[1]/=mag*2;
    lite[2]/=mag*2;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{ 
    for (UITouch *touch in touches) {
        
        
        // Send to the dispatch method, which will make sure the appropriate subview is acted upon
        float dy = [touch locationInView:self].y - [touch previousLocationInView:self].y;
        float dx = [touch locationInView:self].x - [touch previousLocationInView:self].x;
        
        float px = [touch previousLocationInView:self].x;
        float py = [touch previousLocationInView:self].y;
        
        for (int i=0;i<10;i++){
            [self setSpeed:dy*5 atPoint:CGPointMake(i*.1*dx+px,i*.1*dy+py)];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        if ([touch tapCount]>0){
            [self setSpeed:500 atPoint:[touch locationInView:self]];
        }
    }
}

- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}

- (void)dealloc {
    [self stopAnimation];
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
}

@end
