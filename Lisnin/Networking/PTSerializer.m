//
//  PTSerializer.m
//  Pathos
//
//  Created by Dan Whitcomb on 5/24/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PTSerializer.h"
#import "PTContext.h"
#import "PTDefines.h"

@implementation PTSerializer

+(PTSerializer*)serializer {
    static PTSerializer *serializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serializer = [[self alloc] init];
    });
    return serializer;
}

-(id) init
{
    self = [super init];
    if(self) {
    }
    
    return self;
}

-(void) deSerializeInfoWithData:(NSData*) data
{
    uint8_t* infoDataBuffer;
    [data getBytes:&infoDataBuffer range:NSMakeRange(1, sizeof(data) - 2)];
    NSData* infoData = [NSData dataWithBytes:infoDataBuffer length:sizeof(infoDataBuffer)];
    
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:infoData options:kNilOptions error:nil];
    PTContext* context = [PTContext context];
    [context setRemoteSongTitle:[jsonDict objectForKey:dataKeySongTitle]];
    [context setRemoteArtistTitle:[jsonDict objectForKey:dataKeyArtistName]];
    [context setRemoteAlbumTitle:[jsonDict objectForKey:dataKeyAlbumTitle]];
    [context setRemoteCurrentTime:[[jsonDict objectForKey:dataKeyPlaybackTime] floatValue]];
}

-(void) deSerializeImageWithData:(NSData*) data
{
    uint8_t* imageDataBuffer;
    [data getBytes:&imageDataBuffer range:NSMakeRange(1, sizeof(data) - 20)];
    NSData* imageData = [NSData dataWithBytes:imageDataBuffer length:sizeof(imageDataBuffer)];
    
    UIImage* image = [UIImage imageWithData:imageData];
    [[PTContext context] setRemoteAlbumArtwork:image];
}

@end
