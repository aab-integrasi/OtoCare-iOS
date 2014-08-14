//
//  Personal+Import.m
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Personal+Import.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"
#import "Insurance+Import.h"
#import "Vehicle+Import.h"


@implementation Personal (Import)

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

- (void)parseJSON:(NSDictionary *)json inManagedObjectContext:(NSManagedObjectContext *)context;{
    
    @try {
        if (json) {
            //todo : parse json format here
            NSLog(@"address : %@",[json objectForKey:PERSONAL_ADDRESS]);
            self.address = CORE_DATA_OBJECT([json objectForKey:PERSONAL_ADDRESS]);
             self.email = CORE_DATA_OBJECT([json objectForKey:PERSONAL_EMAIL]);
            self.name = CORE_DATA_OBJECT([json objectForKey:PERSONAL_NAME]);
                         self.telephone = CORE_DATA_OBJECT([json objectForKey:PERSONAL_TELEPHONE]);
//            self.dateOfBirth
             NSString *date = CORE_DATA_OBJECT([json objectForKey:PERSONAL_DATE_OF_BIRTH]);
             self.dateOfBirth = [NSDate dateFromUTCString:date];
//            self.simExpiredDate
            date = CORE_DATA_OBJECT([json objectForKey:PERSONAL_SIM_EXPIRED_DATE]);
            self.simExpiredDate = [NSDate dateFromUTCString:date];
//            self.isCustomer
            if ([json objectForKey:PERSONAL_IS_CUSTOMER]) {
                self.isCustomer =[[json objectForKey:PERSONAL_IS_CUSTOMER] isEqualToString:@"true"]? @(1):@(0);
            }
            //insurance
            if (json [INSURANCE_ENTITY_NAME]) {
                //add insurance
                NSArray *insurances = CORE_DATA_OBJECT(json [INSURANCE_ENTITY_NAME]);
                for (NSDictionary *insurance in insurances) {
                    Insurance *data = [Insurance insuranceWithDictionary:insurance inManagedObjectContext:context];
                    if (data) {
                        [self addInsuranceObject:data];
                    }
                }
            }
            
            
            //vehicle
            if (json [VEHICLE_ENTITY_NAME]) {
                //add insurance
                NSArray *vehicles = CORE_DATA_OBJECT(json [VEHICLE_ENTITY_NAME]);
                for (NSDictionary *vehicle in vehicles) {
                    Vehicle *data = [Vehicle vehicleWithDictionary:vehicle inManagedObjectContext:context];
                    if (data) {
                        [self addVehicleObject:data];
                    }
                }
            }
            
            //save database
            NSError * err;
            [self.managedObjectContext save:&err];
            if(err){
                 NSLog(@"error save database : %@",[err description]);
            }
            
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"fail parseJSON : %@",[exception description]);
    }
    
}



@end
