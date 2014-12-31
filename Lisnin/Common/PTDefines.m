//
//  PTDefines.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/18/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PTDefines.h"

@implementation PTDefines

+(UIColor*) activeColor
{
    return [UIColor colorWithRed:108/255.0 green:188/255.0 blue:1 alpha:1];
}

+(UIColor*) passiveColor
{
    return [UIColor colorWithRed:196/255.0 green:221/255.0 blue:1 alpha:1];
}

+(CGSize) artworkViewSize
{
    return CGSizeMake(240, 240);
}

//Storyboard Ids
NSString* const slideViewControllerId = @"SlideViewController";
NSString* const playViewControllerId = @"PlayViewController";
NSString* const streamViewControllerId = @"StreamViewController";
NSString* const settingsViewControllerId = @"SettingsViewController";

//Interface Strings
NSString* const kStrButtonOk = @"Ok";
NSString* const kStrCommonAlertError = @"An error has occured";
NSString* const kStrDisconnectHeader = @"Uh oh!";
NSString* const kStrDisonnectMessage = @"The connection was ended";
NSString* const kStrConnectionErrorHeader = @"Connection Error";
NSString* const kStrConnectionErrorMessage = @"Something is wrong with the connection";

//User Setting Keys
NSString* const keyIsFirstLaunch = @"isFirstLaunch";
NSString* const keyIsStreaming = @"isStreaming";
NSString* const keyUserId = @"userId";
NSString* const keyIsPlayMode = @"isPlayMode";

//NSData keys
NSString* const dataKeySongTitle = @"SongTitle";
NSString* const dataKeyAlbumTitle = @"AlbumTitle";
NSString* const dataKeyArtistName = @"ArtistName";
NSString* const dataKeyPlaybackTime = @"PlaybackTime";

NSString* const animKeySlideOutgoing = @"outgoingSlide";
NSString* const animKeySlideIncoming = @"incomingSlide";


uint8_t const dataHeaderInfo = 0;
uint8_t const dataHeaderImage = 1;

@end
