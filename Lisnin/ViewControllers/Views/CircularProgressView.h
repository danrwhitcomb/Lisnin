//
//  CircularProgressView.h
//  Pathos
//
//  Created by Dan Whitcomb on 5/21/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircularProgressViewDelegate

-(float) getTotalTime;
-(float) getCurrentTime;
-(CGPoint) getCenterPoint;
-(float) getRadius;
-(CGPoint) getStartPoint;

@end

@interface CircularProgressView : UIView

@property id<CircularProgressViewDelegate> delegate;

@end
