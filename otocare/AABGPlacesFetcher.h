//
//  AABGPlacesFetcher.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AABGPlace.h"

typedef void(^AABGPlacesHandler)(NSArray *places, BOOL hasNext);
typedef void(^AABGPlaceDetailsHandler)(NSDictionary *details);


@interface AABGPlacesFetcher : NSObject



@property (nonatomic, copy) AABGPlacesHandler completionHandler;

+ (void)fetchDetailsForPlace:(AABGPlace *)place completionHandler:(AABGPlaceDetailsHandler)handler;

- (id)initWithCompletionHandler:(AABGPlacesHandler)completionHandler;

- (void)fetchNearbyLocations:(CLLocationCoordinate2D)coordinate;
- (void)searchPlacesWithKeyword:(NSString *)keyword;
- (void)resetRequest;


@end
