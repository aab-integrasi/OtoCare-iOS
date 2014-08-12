//
//  Vehicle+Extended.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Vehicle+Extended.h"

@implementation Vehicle (Extended)


+ (Vehicle *)newVehicleInContext:(NSManagedObjectContext *)context{
    Vehicle *vehicle = [NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:context];
    
    return vehicle;
}

@end
