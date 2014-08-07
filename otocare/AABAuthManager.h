//
//  AABAuthManager.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AABUser.h"

@interface AABAuthManager : NSObject


@property (nonatomic, strong) AABUser *activeUser;

+ (AABAuthManager *)sharedManager;

- (void)sendLoginCredentialWithParams:(NSDictionary *)params completion:(void (^)(BOOL success, NSString *message))completion;
- (BOOL)isLoggedOn;
- (BOOL)isTokenExpired;
- (void)logout;
- (void)reInit;

@end
