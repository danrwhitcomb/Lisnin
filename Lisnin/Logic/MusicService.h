//
//  MusicService.h
//  Pathos
//
//  Created by Dan Whitcomb on 5/23/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicService : NSObject

@property (nonatomic, strong) MPMusicPlayerController* player;

+ (id)sharedManager;
-(NSData*) compressNowPlayingItemToData;
-(NSData*) compressAlbumArtworkToData:(MPMediaItem*) item withSize:(CGSize)size;

@end
