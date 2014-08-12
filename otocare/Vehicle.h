//
//  Vehicle.h
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Personal;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * chassisNumber;
@property (nonatomic, retain) NSString * engineNumber;
@property (nonatomic, retain) NSString * policeNumber;
@property (nonatomic, retain) NSDate * stnkExpiredDate;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) Personal *personal;

@end
