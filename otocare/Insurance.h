//
//  Insurance.h
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Personal;

@interface Insurance : NSManagedObject

@property (nonatomic, retain) NSString * coverage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * policyNumber;
@property (nonatomic, retain) NSDate * policyPeriodFrom;
@property (nonatomic, retain) NSDate * policyPeriodTo;
@property (nonatomic, retain) Personal *personal;

@end
