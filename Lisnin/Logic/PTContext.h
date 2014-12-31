//
//  PTContext.h
//  Pathos
//
//  Created by Dan Whitcomb on 5/19/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PTContext : NSObject

+(PTContext*)context;

-(void)startContext;
-(void)saveContext;

@property (nonatomic, strong) NSString* userId;
@property (nonatomic) BOOL isStreaming; //Does user allow streaming to others?
@property (nonatomic) BOOL isPlayMode; //Is UI on play tab?
@property (nonatomic) BOOL isListening; //Is listening from someone else?
@property (nonatomic) BOOL isPlaying; //Is playing music?

//Sent music properties
@property (nonatomic, strong) NSString* remoteSongTitle;
@property (nonatomic, strong) NSString* remoteAlbumTitle;
@property (nonatomic, strong) NSString* remoteArtistTitle;
@property (nonatomic) float remoteCurrentTime;
@property (nonatomic, strong) UIImage* remoteAlbumArtwork;

@property (nonatomic) MCPeerID* listeningPeerId;

@end
