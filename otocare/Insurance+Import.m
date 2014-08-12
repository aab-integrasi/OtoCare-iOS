//
//  Insurance+Import.m
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Insurance+Import.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"

@implementation Insurance (Import)


+ (Insurance *)insuranceWithDictionary:(NSDictionary *)dictionary
                inManagedObjectContext:(NSManagedObjectContext *)context{
    
    @try {
        
        if (dictionary) {
            //parse dictionary here
            
                         //check ID on local database
            NSString *policyNumber = CORE_DATA_OBJECT([dictionary objectForKey:INSURANCE_POLICY_NUMBER]);
            Insurance *data = [Insurance insuranceWithId:policyNumber inManagedObjectContext:context];
            
            if (!data) {
                data = [NSEntityDescription insertNewObjectForEntityForName:INSURANCE_ENTITY_NAME
                                                   inManagedObjectContext:context];
                data.policyNumber = policyNumber;
            }
            
            //parse and save all data
            /*
             @property (nonatomic, retain) NSString * coverage;
             @property (nonatomic, retain) NSString * name;
             @property (nonatomic, retain) NSString * policyNumber;
             @property (nonatomic, retain) NSDate * policyPeriodFrom;
             @property (nonatomic, retain) NSDate * policyPeriodTo;
             */
            data.coverage = CORE_DATA_OBJECT([dictionary objectForKey:INSURANCE_COVERAGE]);
                        data.name = CORE_DATA_OBJECT([dictionary objectForKey:INSURANCE_NAME]);
                                    data.name = CORE_DATA_OBJECT([dictionary objectForKey:INSURANCE_NAME]);
            NSString *date = CORE_DATA_OBJECT([dictionary objectForKey:INSURANCE_POLICY_PERIOD_FROM]);
            data.policyPeriodFrom = [NSDate dateFromUTCString:date];
            date = CORE_DATA_OBJECT([dictionary objectForKey:INSURANCE_POLICY_PERIOD_TO]);
            data.policyPeriodTo = [NSDate dateFromUTCString:date];
            
            return data;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error in insuranceWithDictionary : %@",[exception description]);
        return nil;
    }
    return Nil;
   
}

+ (Insurance *)insuranceWithId:(NSString *)policyNumber
        inManagedObjectContext:(NSManagedObjectContext *)context{
    if (!policyNumber) {
        return nil;
    }
    
    
    @try {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:INSURANCE_ENTITY_NAME];
        request.predicate = [NSPredicate predicateWithFormat:@"policyNumber = %@", policyNumber];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        return [results lastObject];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception while insuranceWithId : %@", [exception description]);
    }
    
    return nil;
}


@end
