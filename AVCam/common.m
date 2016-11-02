//
//  common.c
//  AVCam Objective-C
//
//  Created by Auro Tripathy on 11/1/16.
//  Copyright © 2016 ShatterlIne Labs. All rights reserved.
//

#import "common.h"

@implementation GlobalVars


@synthesize serverName = _serverName;

+ (GlobalVars *)sharedInstance {
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {

        _serverName = nil;
    }
    return self;
}
@end
