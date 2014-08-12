//
//  Vehicle+Import.h
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Vehicle.h"

@interface Vehicle (Import)


/*
 @property (nonatomic, retain) NSString * chassisNumber;
 @property (nonatomic, retain) NSString * engineNumber;
 */

+ (Vehicle *)vehicleWithDictionary:(NSDictionary *)dictionary
                inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Vehicle *)vehicleWithChassisNumber:(NSString *)chassisNumber
        inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Vehicle *)vehicleWithEngineNumber:(NSString *)engineNumber
               inManagedObjectContext:(NSManagedObjectContext *)context;

@end
