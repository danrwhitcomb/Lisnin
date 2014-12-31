//
//  SettingsViewController.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/19/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "SettingsViewController.h"
#import "PTContext.h"
#import "PTSessionHandler.h"

@interface SettingsViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtUserId;
@property (strong, nonatomic) IBOutlet UISwitch *switchStreaming;

@end

@implementation SettingsViewController

-(void)viewDidLoad
{
    PTContext* context = [PTContext context];
    self.txtUserId.text = context.userId;
    self.txtUserId.delegate = self;
    [self.switchStreaming setOn:context.isStreaming animated:NO];
}

#pragma mark Slide Controller
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

-(IBAction)onSwitchStreaming:(id)sender
{
    BOOL isOn = self.switchStreaming.isOn;
    
    if(isOn){
        [[PTContext context] setIsStreaming:YES];
    }
    else{
        [[PTContext context] setIsStreaming:NO];
    }
    
    [[PTSessionHandler handler] advertiseSelf:isOn];
    [[PTContext context] saveContext];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.txtUserId resignFirstResponder];
    [[PTContext context] setUserId:textField.text];
    [[PTContext context] saveContext];
    return YES;
}

@end
