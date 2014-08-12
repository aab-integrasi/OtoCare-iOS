//
//  AABDataFetcher.h
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AABDataFetcherFinishedHandler)(void);
typedef void(^AABDataFetcherFailureHandler)(NSError *error);
typedef void(^AABDataFetcherProgressHandler)(float progress, float total);
typedef void(^AABDataFetcherSuccessHandler)(BOOL success);

@interface AABDataFetcher : NSObject

@property (nonatomic, copy) AABDataFetcherFinishedHandler onFinished;
@property (nonatomic, copy) AABDataFetcherFailureHandler onFailure;
@property (nonatomic, copy) AABDataFetcherProgressHandler onProgress;

@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger progress;

- (id)initWithFinished:(AABDataFetcherFinishedHandler)onFinished
             onFailure:(AABDataFetcherFailureHandler)onFailure
            onProgress:(AABDataFetcherProgressHandler)onProgress;

- (void)postFailureWithError:(NSError *)error;
- (void)postFinished;
- (void)fetchUpdates;
- (void)fetchUpdatesWithValue:(float)progress andTotal:(int)total;

@end
