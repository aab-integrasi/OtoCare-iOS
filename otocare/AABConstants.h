//
//  AABConstants.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AABUserChangedNotification       @"AABUserChangedNotification"
#define AABAccessExpiredNotification     @"AABAccessExpiredNotification"

#define AABSyncKeyError                  @"error"
#define AABSyncKeySuccess                @"success"
#define AABUpdatesAvailable              @"updates"
#define AABAuthenticationStatus          @"authenticationStatus"

#define AABLocaDBName                    @"OTOCARE"

#define AABDatabaseChangedNotification   @"AABDatabaseChangedNotification"
#define AABAccessExpiredNotification     @"AABAccessExpiredNotification"
#define AABSyncShouldStartedNotification @"AABSyncShouldStartedNotification"
#define AABUserChangedNotification       @"AABUserChangedNotification"
#define AABLastSyncDate                  @"AABLastSyncDate"
#define AABBackgroundUpdates             @"AABBackgroundUpdates"

#define AABGoogleAPIKey      [[NSUserDefaults standardUserDefaults] stringForKey:@"Google Places API KEY"]
#define AABBaseURL           [[NSUserDefaults standardUserDefaults] stringForKey:@"API URL"]
#define AABAPIKey            [[NSUserDefaults standardUserDefaults] stringForKey:@"API Key"]
#define AABAPISecret         [[NSUserDefaults standardUserDefaults] stringForKey:@"API Secret"]


#define AABGoogleAPIKeyConstant          @"AABGoogleAPIKey"
#define AABBaseURLKey                    @"AABBaseURL"
#define AABAPIKeyConstant                @"AABAPIKey"
#define AABAPISecretKey                  @"AABAPISecret"

// Tag value
#define AABDefaultAlertTag               666
#define AABAlertUpload_Tag                   1
#define AABAlertUpdate_Tag                   2
#define AABAlertRelogin_Tag                  3
#define AABAlertNeedSynch_Tag                4
#define AABAlertNOUNHCR_Tag                  5
#define AABAlertLocationConfirmation_Tag     6
#define AABAlertLocationExists_Tag           7
#define AABAlertContinueToPopNavigation_Tag  8
#define AABAlertStartWithoutSynch_Tag        9

#define CORE_DATA_OBJECT(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

extern NSString *const CONST_ROOT;

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
extern NSString *const PERSONAL_ENTITY_NAME;
extern NSString *const PERSONAL_ADDRESS;
extern NSString *const PERSONAL_DATE_OF_BIRTH;
extern NSString *const PERSONAL_EMAIL;
extern NSString *const PERSONAL_NAME;
extern NSString *const PERSONAL_SIM_EXPIRED_DATE;
extern NSString *const PERSONAL_TELEPHONE;
extern NSString *const PERSONAL_IS_CUSTOMER;

//Insurance
/*
 @property (nonatomic, retain) NSString * coverage;
 @property (nonatomic, retain) NSString * name;
 @property (nonatomic, retain) NSString * policyNumber;
 @property (nonatomic, retain) NSDate * policyPeriodFrom;
 @property (nonatomic, retain) NSDate * policyPeriodTo;
 */
extern NSString *const INSURANCE_ENTITY_NAME;
extern NSString *const INSURANCE_NAME;
extern NSString *const INSURANCE_POLICY_NUMBER;
extern NSString *const INSURANCE_POLICY_PERIOD_FROM;
extern NSString *const INSURANCE_POLICY_PERIOD_TO;
extern NSString *const INSURANCE_COVERAGE;

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
extern NSString *const VEHICLE_ENTITY_NAME;
extern NSString *const VEHICLE_CHASSIS_NUMBER;
extern NSString *const VEHICLE_ENGINE_NUMBER;
extern NSString *const VEHICLE_POLICE_NUMBER;
extern NSString *const VEHICLE_STNK_EXPIRED_DATE;
extern NSString *const VEHICLE_TYPE;
extern NSString *const VEHICLE_YEAR;
extern NSString *const VEHICLE_BRAND;






#define IMRootViewAnimationDuration 0.3
@interface AABConstants : NSObject

+ (void) initialize;
+ (NSArray *)constantsForKey:(NSString *)key;
+ (void)setConstantForKey:(NSString *)key withValue:(NSString *)value;
+ (NSString *) constantStringForKey:(NSString *)key;

@end
