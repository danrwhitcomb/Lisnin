//
//  SharedQuery.m
//  Streamr
//
//  Created by Dan Whitcomb on 5/10/14.
//  Copyright (c) 2014 Streamr. All rights reserved.
//

#import "SharedQuery.h"

@interface SharedQuery ()


@end

@implementation SharedQuery

+ (SharedQuery*)sharedQuery {
    static SharedQuery *query = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        query = [[self alloc] init];
    });
    return query;
}

- (id)init {
    if (self = [super init]) {
        self.query = [[MPMediaQuery alloc] init];
    }
    return self;
}

@end
