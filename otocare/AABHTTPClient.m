//
//  AABHTTPClient.m
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABHTTPClient.h"
#import "AABConstants.h"
#import "AABAuthManager.h"

@interface AABHTTPClient () {
    dispatch_queue_t client;
    AABHTTPClient *mpClient;
}

@end

@implementation AABHTTPClient


+ (AABHTTPClient *)sharedClient
{
    //    static dispatch_once_t once;
    //    static IMHTTPClient *singleton = nil;
    //
    //    dispatch_once(&once, ^{
    //        singleton = [[IMHTTPClient alloc] init];
    //    });
    //
    //    return singleton;
    
    dispatch_queue_t clientQueue;
    static AABHTTPClient *instance;
    
    clientQueue = dispatch_queue_create("clientQueue", NULL);
    dispatch_sync(clientQueue, ^{
        if (!instance) {
            instance = [[AABHTTPClient alloc] init];
        }
        else if(![instance.baseURL isEqual:[NSURL URLWithString:AABBaseURL]])
        {
            //reinit instance
            instance = [[AABHTTPClient alloc] init];
        }
    });
    
    
    return instance;
}

- (id)init
{
    //    IMConstants* object = [[IMConstants alloc] init]; // Create an instance of SomeClass
    //TODO : test set url
    //
    // NSLog(@"Before: %@", [object getURL]);
    //[object setURL:@"http://172.25.137.125:50000/api"];
    // NSLog(@"After: %@", [object getURL]);
    //    NSString *gURL =  [object getURL];
    
    if (AABBaseURL == Nil) {
        [AABConstants initialize];
    }
    
    
    
    self = [super initWithBaseURL:[NSURL URLWithString:AABBaseURL]];
    //    self = [super initWithBaseURL:[NSURL URLWithString:gURL]];
    
    self.parameterEncoding = AFFormURLParameterEncoding;
    [self setDefaultHeader:@"User-Agent" value:@"otocare"];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [self setupAuthenticationHeader];
    [self setAllowsInvalidSSLCertificate:YES];
    
    return self;
}
+ (void)setNewURL
{
    [self clientWithBaseURL:[NSURL URLWithString:AABBaseURL]];
}

- (void)setNewBaseURL
{
    AABHTTPClient *singleton = [AABHTTPClient sharedClient];
    if (singleton) {
        //        [singleton release];
        //         [singleton setValue:IMBaseURL forKey:@"baseURL"];
        
        //        [];
        
        //        singleton = [super initWithBaseURL:[NSURL URLWithString:IMBaseURL]];
        //        singleton.parameterEncoding = AFFormURLParameterEncoding;
        //        [singleton setDefaultHeader:@"User-Agent" value:@"IMS for iPad"];
        //        [singleton setDefaultHeader:@"Accept" value:@"application/json"];
        //        [singleton setupAuthenticationHeader];
        //        [singleton setAllowsInvalidSSLCertificate:YES];
    }
}

- (void)setupAuthenticationHeader
{
    NSString *accessToken = [AABAuthManager sharedManager].activeUser.accessToken;
    
    if (AABAPIKey == Nil) {
        [AABConstants initialize];
    }
    if (accessToken) { [self setAuthorizationHeaderWithUsername:AABAPIKey password:accessToken]; }
    else { [self clearAuthorizationHeader]; NSLog(@"default headers: %@", [self defaultValueForHeader:@"Authorization"]); }
}

- (void)getJSONWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
                success:(void (^)(NSDictionary *jsonData, int statusCode))success
                failure:(void (^)(NSError *))failure
{
    self.parameterEncoding = AFFormURLParameterEncoding;
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json){
                                                                                            if (success) success(json, response.statusCode);
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                                            if ([self processResponse:response]) {
                                                                                                if (failure) failure(error);
                                                                                            }
                                                                                        }];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)postJSONWithPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSDictionary *jsonData, int statusCode))success
                 failure:(void (^)(NSDictionary *jsonData, NSError *error, int statusCode))failure
{
    self.parameterEncoding = AFJSONParameterEncoding;
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json){
                                                                                            if (success) success(json, response.statusCode);
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json){
                                                                                            if ([self processResponse:response]) {
                                                                                                if (failure) failure(json, error, response.statusCode);
                                                                                            }
                                                                                        }];
    [self enqueueHTTPRequestOperation:operation];
    self.parameterEncoding = AFFormURLParameterEncoding;
}

- (void)getPhotoWithId:(NSString *)photoId
               success:(void (^)(NSData *imageData))success
               failure:(void (^)(NSError *error))failure
{
    self.parameterEncoding = AFFormURLParameterEncoding;
    [self getPath:@"photo"
       parameters:@{@"id":photoId}
          success:^(AFHTTPRequestOperation *operation, NSData *responseObject){
              if ([responseObject isKindOfClass:[NSData class]]) {
                  if (success) success(responseObject);
              }else if (failure) {
                  failure([NSError errorWithDomain:@"Null Pointer Exception" code:0 userInfo:nil]);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              if (failure) failure(error);
          }];
}

- (BOOL)processResponse:(NSHTTPURLResponse *)httpResponse
{
    if (httpResponse.statusCode == 401 || httpResponse.statusCode == 403) {
        NSDictionary *userInfo;
        if (httpResponse.statusCode == 401) {
            userInfo = @{AABSyncKeyError: NSLocalizedString(@"Authentication Failed", @"Authentication Failed")};
            NSLog(@"userInfo :%@",[userInfo description]);
        }else if (httpResponse.statusCode == 403) {
            userInfo = @{AABSyncKeyError: NSLocalizedString(@"Forbidden Access", @"Forbidden Access")};
            NSLog(@"userInfo :%@",[userInfo description]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{ [[AABAuthManager sharedManager] logout]; });
        
        return NO;
    }
    
    return YES;
}
@end
