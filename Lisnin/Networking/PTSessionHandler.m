//
//  SPSessionHandler.m
//  Spout
//
//  Created by Dan Whitcomb on 5/14/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "PTSessionHandler.h"
#import "PTAlert.h"
#import "PTContext.h"
#import "PTDefines.h"
#import "MusicService.H"

#import <SVProgressHUD/SVProgressHUD.h>

@interface PTSessionHandler () <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

@end

@implementation PTSessionHandler

+(PTSessionHandler*)handler {
    static PTSessionHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

-(id) init
{
    self = [super init];
    if(self) {
    }
    
    return self;
}


#pragma mark Setups

- (void) setupSessonHandler
{
    [self setupPeerWithDisplayName:[[PTContext context] userId]];
    [self setupSession];
    [self setupBrowser];
}

- (void)setupPeerWithDisplayName:(NSString *)displayName {
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)setupSession {
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)setupBrowser {
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"spout" session:_session];
}

-(void) setBrowserDelegate:(id<MCNearbyServiceBrowserDelegate>) delegate
{
    self.browser.browser.delegate = delegate;
}

#pragma mark State toggles

- (void)advertiseSelf:(BOOL)advertise {
    if (advertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"spout" discoveryInfo:nil session:self.session];
        [self.advertiser start];
        
    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

- (void) startBrowsing
{
    [[self.browser browser] startBrowsingForPeers];
}

-(void) stopBrowsing
{
    [[self.browser browser] stopBrowsingForPeers];
}

#pragma mark Data senders
-(BOOL) sendData:(NSData*)data toPeer:(NSString*)peer error:(NSError **)error
{
    MCPeerID* peerId = [[MCPeerID alloc] initWithDisplayName:peer];
    return [self.session sendData:data toPeers:[NSArray arrayWithObject:peerId] withMode:MCSessionSendDataReliable error:error];
}

#pragma mark Peer connections

-(void) connectToPeer:(NSString*)peer
{
    MCPeerID* peerId = [[MCPeerID alloc] initWithDisplayName:peer];
    
    [[self.browser browser] invitePeer:peerId toSession:self.session withContext:nil timeout:-1];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    [PTAlert show:@"New Peer" message:[NSString stringWithFormat:@"%@ wants to listen. Can they connect?", peerID.displayName] buttons:[NSArray arrayWithObjects:@"No", @"Yes", nil] block:^(PTAlert *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0){
            [self.session cancelConnectPeer:peerID];
        }
        else
        {
            [self.session connectPeer:peerID withNearbyConnectionData:context];
            
        }
    }];
}


#pragma mark Session receivers

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if(state == MCSessionStateConnected){
        
        MusicService* service = [MusicService sharedManager];
        
        [self sendData:[service compressNowPlayingItemToData] toPeer:peerID.displayName error:nil];
        
        [self sendData:[service compressAlbumArtworkToData:[[service player] nowPlayingItem] withSize:[PTDefines artworkViewSize]] toPeer:peerID.displayName error:nil];
        
        if(![[PTContext context] isPlayMode]){
            [SVProgressHUD dismiss];
            [[PTContext context] setListeningPeerId:peerID];
            [[PTContext context] setIsListening:YES];
        }
    }
    else
    {
        if([[PTContext context] isListening])
        {
            [PTAlert show:kStrDisconnectHeader message:kStrDisonnectMessage];
            [[PTContext context] setIsListening:NO];
        }
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    uint8_t header;
    [data getBytes:&header range:NSMakeRange(0, 1)];
    
    if (header == dataHeaderImage)
    {
        
    }
    else if (header == dataHeaderInfo)
    {
        
    }
    else
    {
        [PTAlert show:kStrConnectionErrorHeader message:kStrConnectionErrorMessage];
    }
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

@end
