//
//  Personal.h
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Insurance, Vehicle;

@interface Personal : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * dateOfBirth;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * simExpiredDate;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSNumber * isCustomer;
@property (nonatomic, retain) NSSet *insurance;
@property (nonatomic, retain) NSSet *vehicle;
@end

@interface Personal (CoreDataGeneratedAccessors)

- (void)addInsuranceObject:(Insurance *)value;
- (void)removeInsuranceObject:(Insurance *)value;
- (void)addInsurance:(NSSet *)values;
- (void)removeInsurance:(NSSet *)values;

- (void)addVehicleObject:(Vehicle *)value;
- (void)removeVehicleObject:(Vehicle *)value;
- (void)addVehicle:(NSSet *)values;
- (void)removeVehicle:(NSSet *)values;

@end
