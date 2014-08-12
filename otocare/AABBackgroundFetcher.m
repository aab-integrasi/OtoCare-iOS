//
//  AABBackgroundFetcher.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABBackgroundFetcher.h"
#import "AABDataFetcher.h"


@interface AABBackgroundFetcher()

@property (nonatomic, copy) void (^completionHandler)(BOOL success);

@end

@implementation AABBackgroundFetcher

- (void)startBackgroundUpdatesWithCompletionHandler:(void (^)(BOOL success))completionHandler{
    NSLog(@"Starting background updates... ");
    self.completionHandler = completionHandler;
    [self fetchReferences];
}

- (void)execute:(AABDataFetcher *)fetcher
{
    fetcher.onFailure = ^(NSError *error){ [self finishedWithError:error]; };
    [fetcher fetchUpdates];
}

- (void)finished
{
    if (self.completionHandler) self.completionHandler(YES);
    NSLog(@"Background Updates Finished");
}

- (void)finishedWithError:(NSError *)error
{
    if (self.completionHandler) self.completionHandler(NO);
    NSLog(@"Background updates error: %@", [error description]);
}


#pragma mark Fetcher Management
- (void)fetchReferences
{
    //start fetching data
    
    NSLog(@"Updating References");
//    AABDataFetcher *fetcher = [[IMReferencesFetcher alloc] init];
//    fetcher.onFinished = ^{ [self fetchAccommodations]; };
//    [self execute:fetcher];
}




@end
