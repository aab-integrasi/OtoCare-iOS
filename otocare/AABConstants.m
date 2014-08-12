//
//  AABConstants.m
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABConstants.h"

@implementation AABConstants

NSString *const CONST_ROOT                      = @"Root";
NSString *const CONST_AABConstantKeys            = @"AABConstantKeys";

//constant value for CoreData

//Personal
/*
 @property (nonatomic, retain) NSString * address;
 @property (nonatomic, retain) NSDate * dateOfBirth;
 @property (nonatomic, retain) NSString * email;
 @property (nonatomic, retain) NSString * name;
 @property (nonatomic, retain) NSDate * simExpiredDate;
 @property (nonatomic, retain) NSString * telephone;
 @property (nonatomic, retain) NSNumber * isCustomer;
 */
NSString *const PERSONAL_ENTITY_NAME                 = @"Personal";
NSString *const PERSONAL_ADDRESS                     = @"address";
NSString *const PERSONAL_DATE_OF_BIRTH               = @"dateOfBirth";
NSString *const PERSONAL_EMAIL                       = @"email";
NSString *const PERSONAL_NAME                       = @"name";
NSString *const PERSONAL_SIM_EXPIRED_DATE               = @"simExpiredDate";
NSString *const PERSONAL_TELEPHONE                       = @"telephone";
NSString *const PERSONAL_IS_CUSTOMER                       = @"isCustomer";

//Insurance
/*
 @property (nonatomic, retain) NSString * coverage;
 @property (nonatomic, retain) NSString * name;
 @property (nonatomic, retain) NSString * policyNumber;
 @property (nonatomic, retain) NSDate * policyPeriodFrom;
 @property (nonatomic, retain) NSDate * policyPeriodTo;
 */
NSString *const INSURANCE_ENTITY_NAME                 = @"Insurance";
NSString *const INSURANCE_NAME                 = @"name";
NSString *const INSURANCE_POLICY_NUMBER                 = @"policyNumber";
NSString *const INSURANCE_POLICY_PERIOD_FROM                 = @"policyPeriodFrom";
NSString *const INSURANCE_POLICY_PERIOD_TO                 = @"policyPeriodTo";
NSString *const INSURANCE_COVERAGE                 = @"coverage";

//Vehicle
/*
 @property (nonatomic, retain) NSString * brand;
 @property (nonatomic, retain) NSString * chassisNumber;
 @property (nonatomic, retain) NSString * engineNumber;
 @property (nonatomic, retain) NSString * policeNumber;
 @property (nonatomic, retain) NSDate * stnkExpiredDate;
 @property (nonatomic, retain) NSString * type;
 @property (nonatomic, retain) NSString * year;
 */
NSString *const VEHICLE_ENTITY_NAME                 = @"Vehicle";
NSString *const VEHICLE_CHASSIS_NUMBER                 = @"chassisNumber";
NSString *const VEHICLE_ENGINE_NUMBER                 = @"engineNumber";
NSString *const VEHICLE_POLICE_NUMBER                 = @"policeNumber";
NSString *const VEHICLE_STNK_EXPIRED_DATE               = @"stnkExpiredDate";
NSString *const VEHICLE_TYPE                        = @"type";
NSString *const VEHICLE_YEAR                        = @"year";
NSString *const VEHICLE_BRAND                        = @"brand";



+ (NSArray *)constantsForKey:(NSString *)key
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"]];
    return [dictionary objectForKey:key];
}

+ (void)setConstantForKey:(NSString *)key withValue:(NSString *)value;
{
    dispatch_queue_t constantQueue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    constantQueue = dispatch_queue_create("constantQueue", NULL);
    dispatch_sync(constantQueue, ^{
        
        [defaults setObject:value forKey:key];
        [defaults synchronize];
    });
    
    
}

+ (void) initialize
{
    if (self == [AABConstants class]) {
        NSDictionary *dictionary = [[self constantsForKey:CONST_AABConstantKeys] mutableCopy];
        
        if (!AABAPIKey)[self setConstantForKey:@"API Key" withValue:[dictionary objectForKey:AABAPIKeyConstant]];
        
        if (!AABAPISecret)[self setConstantForKey:@"API Secret" withValue:[dictionary objectForKey:AABAPISecretKey]];
        
        
        if (!AABBaseURL)[self setConstantForKey:@"API URL" withValue:[dictionary objectForKey:AABBaseURLKey]];
        
        if (!AABGoogleAPIKey)[self setConstantForKey:@"Google Places API KEY" withValue:[dictionary objectForKey:AABGoogleAPIKeyConstant]];
	}
}


+ (NSString *) constantStringForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@end
