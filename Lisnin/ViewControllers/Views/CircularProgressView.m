//
//  CircularProgressView.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/21/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "CircularProgressView.h"
@interface CircularProgressView ()

@property UIViewController* parentController;

@end

@implementation CircularProgressView

static inline double radians (double degrees) { return degrees * M_PI/180; }



-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [super setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect
{
    float totalTime = [self.delegate getTotalTime];
    float currentTime = [self.delegate getCurrentTime];
    CGPoint center = [self.delegate getCenterPoint];
    
    float angle = radians(((currentTime/totalTime) * 360) + 90);
    float radius = [self.delegate getRadius] - 6;
    

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * arcColor = [UIColor colorWithRed:108/255.0 green:166/255.0 blue:1.0 alpha:1.0];
    
    CGRect arcRect = rect;
    arcRect.size.height = 5;
    
    CGContextSetLineWidth(context, 4);
    CGContextSetStrokeColorWithColor(context, arcColor.CGColor);
    CGContextAddArc(context, center.x, center.y, radius, radians(90), angle, NO);
    CGContextStrokePath(context);
}

@end
