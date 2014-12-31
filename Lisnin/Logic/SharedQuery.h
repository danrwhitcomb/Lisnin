//
//  SharedQuery.h
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>

@interface SharedQuery : NSObject

@property (nonatomic, strong) MPMediaQuery* query;

+(SharedQuery*)sharedQuery;

@end
