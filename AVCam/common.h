//
//  common.h
//  AVCam Objective-C
//
//  Created by Auro Tripathy on 10/25/16.
//  Copyright © 2016 ShatterlIne Labs. All rights reserved.
//

#ifndef common_h
#define common_h

#define URL                   @"https://7bf37275.ngrok.io/"
#define UPLOAD_URL            (URL @"curl/")
#define RECEIVER_PHONE_URL     (URL @"phone/")
#define VIDEO_UPLOAD_URL     (URL @"vidcurl/")


#endif /* common_h *///DataClass.h

#import <Foundation/Foundation.h>

@interface GlobalVars : NSObject
{

    NSString *_serverName;
}

+ (GlobalVars *)sharedInstance;
@property(strong, nonatomic, readwrite) NSString *serverName;

@end
