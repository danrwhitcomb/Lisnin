//
//  PlayViewController.h
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayViewController : UIViewController

+(MPMusicPlayerController*) sharedMusicPlayer;

@end
