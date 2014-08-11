//
//  AABConstants.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AABUserChangedNotification       @"AABUserChangedNotification"
#define AABAccessExpiredNotification     @"AABAccessExpiredNotification"

#define AABSyncKeyError                  @"error"
#define AABSyncKeySuccess                @"success"
#define AABUpdatesAvailable              @"updates"
#define AABAuthenticationStatus          @"authenticationStatus"


#define AABGoogleAPIKey      [[NSUserDefaults standardUserDefaults] stringForKey:@"Google Places API KEY"]
#define AABBaseURL           [[NSUserDefaults standardUserDefaults] stringForKey:@"API URL"]
#define AABAPIKey            [[NSUserDefaults standardUserDefaults] stringForKey:@"API Key"]
#define AABAPISecret         [[NSUserDefaults standardUserDefaults] stringForKey:@"API Secret"]


#define AABGoogleAPIKeyConstant          @"AABGoogleAPIKey"
#define AABBaseURLKey                    @"AABBaseURL"
#define AABAPIKeyConstant                @"AABAPIKey"
#define AABAPISecretKey                  @"AABAPISecret"

// Tag value
#define AABDefaultAlertTag               666

#define CORE_DATA_OBJECT(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })


#define IMRootViewAnimationDuration 0.3
@interface AABConstants : NSObject

+ (void) initialize;
+ (NSArray *)constantsForKey:(NSString *)key;
+ (void)setConstantForKey:(NSString *)key withValue:(NSString *)value;
+ (NSString *) constantStringForKey:(NSString *)key;

@end
