//
//  PTDefines.h
//  Pathos
//
//  Created by Dan Whitcomb on 5/18/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Delegates

@protocol ModalControllerDelegate

-(void) returnToControlView:(UIView*) outgoingView;

@end


@interface PTDefines : NSObject

+(UIColor*)activeColor;
+(UIColor*)passiveColor;
+(CGSize) artworkViewSize;

extern NSString* const slideViewControllerId;
extern NSString* const playViewControllerId;
extern NSString* const streamViewControllerId;
extern NSString* const settingsViewControllerId;

extern NSString* const kStrButtonOk;
extern NSString* const kStrCommonAlertError;
extern NSString* const kStrDisconnectHeader;
extern NSString* const kStrDisonnectMessage;
extern NSString* const kStrConnectionErrorHeader;
extern NSString* const kStrConnectionErrorMessage;

extern NSString* const keyIsFirstLaunch;
extern NSString* const keyIsStreaming;
extern NSString* const keyUserId;
extern NSString* const keyIsPlayMode;

extern NSString* const dataKeySongTitle;
extern NSString* const dataKeyAlbumTitle;
extern NSString* const dataKeyArtistName;
extern NSString* const dataKeyPlaybackTime;

extern NSString* const animKeySlideOutgoing;
extern NSString* const animKeySlideIncoming;

extern uint8_t const dataHeaderInfo;
extern uint8_t const dataHeaderImage;

@end
