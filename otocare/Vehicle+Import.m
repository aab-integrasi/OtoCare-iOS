//
//  Vehicle+Import.m
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Vehicle+Import.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"

@implementation Vehicle (Import)


+ (Vehicle *)vehicleWithDictionary:(NSDictionary *)dictionary
            inManagedObjectContext:(NSManagedObjectContext *)context{
    
    @try {
        if (dictionary) {
            //parse dictionary here
            
            //check ID on local database
            NSString *ID = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_CHASSIS_NUMBER]);
            Vehicle *data = [Vehicle vehicleWithChassisNumber:ID inManagedObjectContext:context];
            
            if (!data) {
                
                //chack with engineNumber
                ID = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_ENGINE_NUMBER]);
                data = [Vehicle vehicleWithEngineNumber:ID inManagedObjectContext:context];
                
                if (!data) {
                    data = [NSEntityDescription insertNewObjectForEntityForName:VEHICLE_ENTITY_NAME
                                                         inManagedObjectContext:context];
                }
                
                data.engineNumber = ID;
            }
            data.chassisNumber = ID;
            //parse and save all data
            /*
             @property (nonatomic, retain) NSString * brand;
             @property (nonatomic, retain) NSString * chassisNumber;
             @property (nonatomic, retain) NSString * engineNumber;
             @property (nonatomic, retain) NSString * policeNumber;
             @property (nonatomic, retain) NSDate * stnkExpiredDate;
             @property (nonatomic, retain) NSString * type;
             @property (nonatomic, retain) NSString * year;
             */
            data.brand = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_BRAND]);
            data.chassisNumber = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_CHASSIS_NUMBER]);
            data.engineNumber = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_ENGINE_NUMBER]);
            data.policeNumber = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_POLICE_NUMBER]);
            data.type = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_TYPE]);
            data.year = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_YEAR]);
            NSString *date = CORE_DATA_OBJECT([dictionary objectForKey:VEHICLE_STNK_EXPIRED_DATE]);
            data.stnkExpiredDate = [NSDate dateFromUTCString:date];
            
            return data;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error in insuranceWithDictionary : %@",[exception description]);
        return nil;
    }
    
    return Nil;
}
+ (Vehicle *)vehicleWithChassisNumber:(NSString *)chassisNumber
               inManagedObjectContext:(NSManagedObjectContext *)context{
    
    if (!chassisNumber) {
        return nil;
    }
    
    
    @try {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:VEHICLE_ENTITY_NAME];
        request.predicate = [NSPredicate predicateWithFormat:@"chassisNumber = %@", chassisNumber];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        return [results lastObject];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception while vehicleWithChassisNumber : %@", [exception description]);
    }
    
    return Nil;
}
+ (Vehicle *)vehicleWithEngineNumber:(NSString *)engineNumber
              inManagedObjectContext:(NSManagedObjectContext *)context{
    
    if (!engineNumber) {
        return nil;
    }
    
    
    @try {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:VEHICLE_ENTITY_NAME];
        request.predicate = [NSPredicate predicateWithFormat:@"engineNumber = %@", engineNumber];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        return [results lastObject];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception while vehicleWithEngineNumber : %@", [exception description]);
    }
    
    
    return Nil;
    
}

@end
