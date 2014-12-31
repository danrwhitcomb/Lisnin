//
//  SPSessionHandler.h
//  Spout
//
//  Created by Dan Whitcomb on 5/14/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface PTSessionHandler : NSObject

+ (PTSessionHandler*) handler;

- (void) setupSessonHandler;
- (void) setupPeerWithDisplayName:(NSString *)displayName;
- (void) setupSession;
- (void) setupBrowser;
-(void) setBrowserDelegate:(id<MCNearbyServiceBrowserDelegate>) delegate;


- (void) advertiseSelf:(BOOL)advertise;
- (void) startBrowsing;
- (void) stopBrowsing;
-(void) connectToPeer:(NSString*)peer;


@property (nonatomic, strong) MCSession *session;

@end
