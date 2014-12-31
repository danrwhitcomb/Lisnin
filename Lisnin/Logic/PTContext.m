//
//  PTContext.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/19/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PTContext.h"
#import "PTDefines.h"

@interface PTContext ()

@property (nonatomic, strong) NSUserDefaults* userPreferences;

@end

@implementation PTContext

+ (PTContext*)context {
    static PTContext *sharedContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContext = [[self alloc] init];
    });
    return sharedContext;
}

- (id)init {
    if (self = [super init]) {
        self.userPreferences = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)startContext
{
    BOOL isNotFirstLaunch = [self.userPreferences boolForKey:keyIsFirstLaunch];
    
    if(!isNotFirstLaunch){
        UIDevice* device = [UIDevice currentDevice];
        self.userId = device.name;
        self.isStreaming = YES;
        self.isPlayMode = YES;
        
        [self.userPreferences setBool:YES forKey:keyIsStreaming];
        [self.userPreferences setObject:self.userId forKey:keyUserId];
        [self.userPreferences setBool:YES forKey:keyIsFirstLaunch];
        [self.userPreferences setBool:YES forKey:keyIsPlayMode];
    } else {
        self.userId = [self.userPreferences objectForKey:keyUserId];
        self.isStreaming = [self.userPreferences boolForKey:keyIsStreaming];
        self.isPlayMode = [self.userPreferences boolForKey:keyIsPlayMode];
    }
    
    [self.userPreferences synchronize];
}

-(void) saveContext
{
    [self.userPreferences setObject:self.userId forKey:keyUserId];
    [self.userPreferences setBool:self.isStreaming forKey:keyIsStreaming];
    [self.userPreferences synchronize];
}



@end
