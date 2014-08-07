//
//  AABHTTPClient.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"


@interface AABHTTPClient : AFHTTPClient

+ (AABHTTPClient *)sharedClient;
- (void)setNewBaseURL;

+ (void)setNewURL;
- (void)getJSONWithPath:(NSString *)path
             parameters:(NSDictionary *)parameters
                success:(void (^)(NSDictionary *jsonData, int statusCode))success
                failure:(void (^)(NSError *))failure;

- (void)postJSONWithPath:(NSString *)path
              parameters:(NSDictionary *)parameters
                 success:(void (^)(NSDictionary *jsonData, int statusCode))success
                 failure:(void (^)(NSDictionary *jsonData, NSError *error, int statusCode))failure;

- (void)getPhotoWithId:(NSString *)photoId
               success:(void (^)(NSData *imageData))success
               failure:(void (^)(NSError *error))failure;

- (void)setupAuthenticationHeader;

@end
