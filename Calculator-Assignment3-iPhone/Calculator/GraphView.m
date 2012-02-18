//
//  GraphView.m
//  Calculator
//
//  Created by Jeremy Barth on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;

@synthesize dataSource = _dataSource;

-(CGFloat)scale {
    if (!_scale) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _scale = [defaults floatForKey:@"scale"];

        if (!_scale) _scale = 10;
    }
    return _scale;
}

- (void)setScale:(CGFloat)scale {
    if (scale != _scale) {
        _scale = scale;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setFloat:scale forKey:@"scale"];
        [defaults synchronize];

        [self setNeedsDisplay];
    }
}

-(CGPoint)origin {
    if (_origin.x == 0 && _origin.y == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _origin.x = [defaults integerForKey:@"origin.x"];
        _origin.y = [defaults integerForKey:@"origin.y"];
        
        if (_origin.x == 0 && _origin.y == 0) _origin = self.center;
    }
    return _origin;
}

-(void)setOrigin:(CGPoint)origin {
    if (origin.x != _origin.x || origin.y != _origin.y) {
        _origin = origin;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:origin.x forKey:@"origin.x"];
        [defaults setInteger:origin.y forKey:@"origin.y"];
        [defaults synchronize];
        
        [self setNeedsDisplay];
    }
}

- (void)setup {
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }    
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self];
        self.origin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        [gesture setTranslation:CGPointZero inView:self];
    }
}

-(void)tripleTap:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    self.origin = tapPoint;
}

-(CGFloat)yScaled:(CGFloat)xScaled {
    // translate x into real input
    // ex x = 0 --> x = -17
    // ex x = bounds.size.width --> x = 17
    CGFloat x = -(self.origin.x - xScaled) / self.scale;
    
    // call function
    CGFloat y = [self.dataSource y:x];
    
    // translate y into graphable
    // ex y = 5 --> y = 133.5
    CGFloat yScaled = self.origin.y - y * self.scale;
        
    return yScaled;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor blueColor] setStroke];
    [[UIColor blueColor] set];
    [AxesDrawer drawAxesInRect:self.bounds 
                 originAtPoint:self.origin 
                         scale:self.scale];
    
    [[UIColor redColor] setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 7);
    for (int x = 0; x < self.bounds.size.width; x++) {
        CGContextAddLineToPoint(context, x, [self yScaled:x]);
    }
    CGContextStrokePath(context);
}    

@end
