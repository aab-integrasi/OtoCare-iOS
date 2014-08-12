//
//  AABDataFetcher.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABDataFetcher.h"
#import "AABDBManager.h"

@implementation AABDataFetcher

- (id)initWithFinished:(AABDataFetcherFinishedHandler)onFinished
             onFailure:(AABDataFetcherFailureHandler)onFailure
            onProgress:(AABDataFetcherProgressHandler)onProgress
{
    self = [super init];
    self.onFinished = onFinished;
    self.onFailure = onFailure;
    self.onProgress = onProgress;
    self.total = 0;
    self.progress = 0;
    return self;
}

- (void)fetchUpdates
{
    
}

- (void)fetchUpdatesWithValue:(float)progress andTotal:(int)total
{
    
}

- (void)postFailureWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.onFailure) self.onFailure(error);
    });
}

- (void)setProgress:(NSInteger)progress
{
    _progress = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.onProgress) self.onProgress(self.progress, self.total);
    });
}

- (void)postFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AABDBManager sharedManager] saveDatabase:^(BOOL success){
            if (!success) NSLog(@"Failed saving database");
            if (self.onFinished) self.onFinished();
        }];
    });
}


@end
