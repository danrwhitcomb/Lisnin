//
//  MusicService.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/23/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "MusicService.h"
#import "PTDefines.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MusicService ()


@end

@implementation MusicService

+ (id)sharedManager {
    static MusicService *musicService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicService = [[self alloc] init];
    });
    return musicService;
}

- (id)init {
    if (self = [super init]) {
        self.player = [MPMusicPlayerController iPodMusicPlayer];
    }
    return self;
}

#pragma mark Data Compression

-(NSData*) compressNowPlayingItemToData
{
    MPMediaItem* item = [self.player nowPlayingItem];
    return [self compressMediaItemInfoToData:item];
}

-(NSData*) compressMediaItemInfoToData:(MPMediaItem*) item
{
    NSDictionary* jsonDict = @{dataKeySongTitle  : [item valueForProperty:MPMediaItemPropertyTitle],
                               dataKeyArtistName : [item valueForProperty:MPMediaItemPropertyArtist],
                               dataKeyAlbumTitle : [item valueForProperty:MPMediaItemPropertyAlbumTitle],
                               dataKeyPlaybackTime : [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] description]};
    NSData* infoData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData * headerData = [NSMutableData dataWithBytes:&dataHeaderInfo length:sizeof(dataHeaderInfo)];
    [headerData appendData:infoData];
    
    return headerData;
}

-(NSData*) compressAlbumArtworkToData:(MPMediaItem*) item withSize:(CGSize)size
{
    UIImage* artwork = [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:size];
    NSMutableData* headerData = [NSMutableData dataWithBytes:&dataHeaderImage length:sizeof(dataHeaderImage)];
    [headerData appendData:UIImagePNGRepresentation(artwork)];
    return headerData;
}


@end
