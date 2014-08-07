//
//  AABAuthManager.m
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABAuthManager.h"
#import "AABHTTPClient.h"
#import "NSDate+Relativity.h"
#import "AABConstants.h"
#import "PDKeychainBindings.h"

@implementation AABAuthManager


#define kUserKey    @"user"

+ (AABAuthManager *)sharedManager
{
    static dispatch_once_t once;
    static AABAuthManager *singleton = nil;
    
    dispatch_once(&once, ^{
        singleton = [[AABAuthManager alloc] init];
    });
    
    return singleton;
}

- (void)reInit {
    
    if ([AABAuthManager sharedManager]) {
        //        [self.sharedManager ]
    }
}
- (void)sendLoginCredentialWithParams:(NSDictionary *)params completion:(void (^)(BOOL success, NSString *message))completion
{
    NSMutableURLRequest *request = [[AABHTTPClient sharedClient] requestWithMethod:@"POST" path:@"login" parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json){
                                                                                            BOOL status = [self validateLoginResponse:json];
                                                                                            if (status) {
                                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:AABUserChangedNotification object:nil userInfo:nil];
                                                                                                [[AABHTTPClient sharedClient] setupAuthenticationHeader];
                                                                                                completion(status, nil);
                                                                                            }else {
                                                                                                completion(status, NSLocalizedString(@"Authentication Failed", @"Authentication Failed"));
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                                            NSLog(@"%@", [error description]);
                                                                                            NSString *message;
                                                                                            
                                                                                            if (response.statusCode == 401) {
                                                                                                message = NSLocalizedString(@"Authentication Failed", @"Authentication Failed");
                                                                                            }else if (response.statusCode == 403) {
                                                                                                message = NSLocalizedString(@"Forbidden Access", @"Forbidden Access");
                                                                                            }else {
                                                                                                message = @"Connection Error";
                                                                                            }
                                                                                            
                                                                                            completion(NO, message);
                                                                                        }];
    [operation setAllowsInvalidSSLCertificate:YES];
    [[AABHTTPClient sharedClient] enqueueHTTPRequestOperation:operation];
}

- (AABUser *)activeUser
{
    if (!_activeUser) _activeUser = [[AABUser alloc] initFromKeychain];
    return _activeUser;
}

- (BOOL)validateLoginResponse:(id)jsonData
{
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        self.activeUser = [[AABUser alloc] initWithDictionary:jsonData];
        
        if (self.activeUser) {
            [self.activeUser saveToKeychain];
            self.activeUser = [[AABUser alloc] initFromKeychain];
            return self.activeUser != nil;
        }
    }
    
    return NO;
}

- (BOOL)isLoggedOn
{
    return self.activeUser != nil;
}

- (BOOL)isTokenExpired
{
    NSDate *expired = self.activeUser.accessExpiryDate;
    if (!expired) return YES;
    return [expired compare:[NSDate date]] == NSOrderedAscending;
}

- (void)logout
{
    [self.activeUser deleteFromKeychain];
    [[AABHTTPClient sharedClient] clearAuthorizationHeader];
    [[NSNotificationCenter defaultCenter] postNotificationName:AABAccessExpiredNotification object:nil userInfo:nil];
}


@end
