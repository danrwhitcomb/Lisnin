//
//  JobbieAlert.h
//  Jobbie
//
//  Created by Dan Whitcomb on 5/6/14.
//  Copyright (c) 2014 Jobbie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTAlert;

typedef void (^PTAlertBlock)(PTAlert *alertView, NSInteger buttonIndex);

@interface PTAlert : UIAlertView

+ (void) show:(NSString*)title message:(NSString*)message buttons:(NSArray *)buttons block:(PTAlertBlock)block tag:(int)tag style:(UIAlertViewStyle)style;

+ (void) show:(NSString*)title message:(NSString*)message buttons:(NSArray *)buttons block:(PTAlertBlock)block tag:(int)tag;

+ (void) show:(NSString*)title message:(NSString*)message buttons:(NSArray *)buttons block:(PTAlertBlock)block;

+ (void) show:(NSString*)title message:(NSString*)message;
+ (void) showError:(NSString*)message;

@end
