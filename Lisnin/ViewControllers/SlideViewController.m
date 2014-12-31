//
//  SlideViewController.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/18/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "SlideViewController.h"

#import "PlayViewController.h"
#import "MenuViewController.h"

@interface SlideViewController () <TopViewControllerDelegate, MSSlidingPanelControllerDelegate>

@property (nonatomic, strong) PlayViewController* playController;
@property (nonatomic, strong) MenuViewController* menuController;
@property (nonatomic) BOOL* isMenuOpen;

@end

@implementation SlideViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if(self){
        
    }
    
    return self;
}

-(void) viewDidLoad
{
    self.isMenuOpen = NO;
}

-(void) toggleMenu
{
    if(self.isMenuOpen){
        [self closePanel];
    }
    else{
        [self openLeftPanel];
    }
}

@end
