//
//  AABGPlace.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AABGPlace : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *province;

@property (nonatomic, readonly) NSURL *icon;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *reference;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly) BOOL googlePlaces;

/** @name Designated Initializer */
- (id)initWithDictionary:(NSDictionary *)dictionary fromGooglePlaces:(BOOL)googlePlaces;
- (void)setPlaceDetail:(NSDictionary *)dictionary;


@end
