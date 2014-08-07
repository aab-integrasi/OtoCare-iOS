//
//  AABConstants.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AABBaseURL "127.0.0.0"
#define AABUserChangedNotification       @"AABUserChangedNotification"
#define AABAccessExpiredNotification     @"AABAccessExpiredNotification"
#define AABAPIKey                         @"AABAPIKey"

#define AABSyncKeyError                  @"error"
#define AABSyncKeySuccess                @"success"
#define AABUpdatesAvailable              @"updates"
#define AABAuthenticationStatus          @"authenticationStatus"

#define AABGoogleAPIKey                    @"AABGoogleAPIKey"

#define CORE_DATA_OBJECT(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })



@interface AABConstants : NSObject

@end
