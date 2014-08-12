//
//  Insurance+Export.m
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Insurance+Export.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"

@implementation Insurance (Export)


- (NSDictionary *)formatted
{
    
    @try {
        //format all data here
        NSMutableDictionary *formatted = [NSMutableDictionary dictionary];
        
        //Insurance Data
        /*
         @property (nonatomic, retain) NSString * coverage;
         @property (nonatomic, retain) NSString * name;
         @property (nonatomic, retain) NSString * policyNumber;
         @property (nonatomic, retain) NSDate * policyPeriodFrom;
         @property (nonatomic, retain) NSDate * policyPeriodTo;
         */
        
        [formatted setObject:self.coverage forKey:INSURANCE_COVERAGE];
        [formatted setObject:self.name forKey:INSURANCE_NAME];
        [formatted setObject:self.policyNumber forKey:INSURANCE_POLICY_NUMBER];
        [formatted setObject:[self.policyPeriodFrom toUTCString] forKey:INSURANCE_POLICY_PERIOD_FROM];
        [formatted setObject:[self.policyPeriodTo toUTCString] forKey:INSURANCE_POLICY_PERIOD_TO];
        return formatted;
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error while formatted : %@",[exception description]);
    }
    
    return Nil;
}

@end
