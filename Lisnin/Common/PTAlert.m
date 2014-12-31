//
//  JobbieAlert.m
//  Jobbie
//
//  Created by Dan Whitcomb on 5/6/14.
//  Copyright (c) 2014 Jobbie. All rights reserved.
//

#import "PTAlert.h"
#import "PTDefines.h"

@interface PTAlert () <UIAlertViewDelegate>

@property (nonatomic, copy) PTAlertBlock block;

@end


@implementation PTAlert


+ (void) show:(NSString*)title message:(NSString*)message buttons:(NSArray *)buttons block:(PTAlertBlock)block tag:(int)tag style:(UIAlertViewStyle)style
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       PTAlert *alert = [[PTAlert alloc] initWithTitle:title
                                                                        message:message
                                                                       delegate:nil
                                                              cancelButtonTitle:[buttons objectAtIndex:0]
                                                              otherButtonTitles:nil];
                       
                       int counter = 0;
                       for( NSString * s in buttons )
                       {
                           if( 0 == counter++ )
                               continue;
                           
                           [alert addButtonWithTitle: s];
                       }
                       
                       alert.delegate = alert;
                       alert.block = block;
                       alert.tag = tag;
                       alert.alertViewStyle = style;
                       
                       [alert show];
                   });
    
}

+ (void) show:(NSString*)title message:(NSString*)message buttons:(NSArray *)buttons block:(PTAlertBlock)block tag:(int)tag
{
    [PTAlert show:title message:message buttons:buttons block:block tag:tag style:UIAlertViewStyleDefault];
    
}

+ (void) show:(NSString*)title message:(NSString*)message buttons:(NSArray *)buttons block:(PTAlertBlock)block
{
	[PTAlert show:title message:message buttons:buttons block:block tag:0];
}

+ (void) show:(NSString*)title message:(NSString*)message
{
	[PTAlert show:title message:message buttons:[NSArray arrayWithObject:kStrButtonOk] block:nil];
}

+ (void) showError:(NSString*)message
{
	[PTAlert show:kStrCommonAlertError message:message];
}



#pragma mark - UIAlertViewDelegate
//
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(self.block)
	{
		self.block(self, buttonIndex);
	}
}

@end