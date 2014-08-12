//
//  Personal+Export.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Personal+Export.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"
#import "Vehicle+Export.h"
#import "Insurance+Export.h"

@implementation Personal (Export)


- (NSDictionary *)formatted{
    //export all data
    @try {
        //format all data here
        NSMutableDictionary *formatted = [NSMutableDictionary dictionary];
        
        //Personal Data
        /*
         
         @property (nonatomic, retain) NSString * address;
         @property (nonatomic, retain) NSDate * dateOfBirth;
         @property (nonatomic, retain) NSString * email;
         @property (nonatomic, retain) NSString * name;
         @property (nonatomic, retain) NSDate * simExpiredDate;
         @property (nonatomic, retain) NSString * telephone;
         @property (nonatomic, retain) NSNumber * isCustomer;
         @property (nonatomic, retain) NSSet *insurance;
         @property (nonatomic, retain) NSSet *vehicle;
         */
        
        [formatted setObject:self.address forKey:PERSONAL_ADDRESS];
                [formatted setObject:[self.dateOfBirth toUTCString] forKey:PERSONAL_DATE_OF_BIRTH];
        [formatted setObject:self.name forKey:PERSONAL_NAME];
        [formatted setObject:self.email forKey:PERSONAL_EMAIL];
                        [formatted setObject:[self.simExpiredDate toUTCString] forKey:PERSONAL_SIM_EXPIRED_DATE];
            [formatted setObject:self.telephone forKey:PERSONAL_TELEPHONE];
                [formatted setObject:self.isCustomer?@"true":@"false" forKey:PERSONAL_IS_CUSTOMER];
        
        //vehicle
        NSMutableArray * vehicleData = [NSMutableArray array];
        for (Vehicle * vehicle in self.vehicle) {
            //fromat vehicle
            [vehicleData addObject:[vehicle formatted]];
        }
        [formatted setObject:vehicleData forKey:VEHICLE_ENTITY_NAME];
        
        //insurance
        NSMutableArray * insuranceData = [NSMutableArray array];
        for (Insurance * insurance in self.insurance) {
            //format insurance
            [insuranceData addObject:[insurance formatted]];
        }
        [formatted setObject:insuranceData forKey:INSURANCE_ENTITY_NAME];
        
        
        return formatted;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error while formatted : %@",[exception description]);
    }

    
    return nil;
}
@end
