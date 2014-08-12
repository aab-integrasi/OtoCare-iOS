//
//  Vehicle+Export.m
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Vehicle+Export.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"

@implementation Vehicle (Export)


- (NSDictionary *)formatted
{
    @try {
        //format all data here
        NSMutableDictionary *formatted = [NSMutableDictionary dictionary];
        
        //Vehicle Data
        /*
         @property (nonatomic, retain) NSString * brand;
         @property (nonatomic, retain) NSString * chassisNumber;
         @property (nonatomic, retain) NSString * engineNumber;
         @property (nonatomic, retain) NSString * policeNumber;
         @property (nonatomic, retain) NSDate * stnkExpiredDate;
         @property (nonatomic, retain) NSString * type;
         @property (nonatomic, retain) NSString * year;
         */
        
        [formatted setObject:self.brand forKey:VEHICLE_BRAND];
[formatted setObject:self.chassisNumber forKey:VEHICLE_CHASSIS_NUMBER];
        [formatted setObject:self.engineNumber forKey:VEHICLE_ENGINE_NUMBER];
        [formatted setObject:self.policeNumber forKey:VEHICLE_POLICE_NUMBER];
                [formatted setObject:self.type forKey:VEHICLE_TYPE];
                        [formatted setObject:self.year forKey:VEHICLE_YEAR];
         [formatted setObject:[self.stnkExpiredDate toUTCString] forKey:VEHICLE_STNK_EXPIRED_DATE];
        return formatted;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error while formatted : %@",[exception description]);
    }
    
    return Nil;
}
@end
