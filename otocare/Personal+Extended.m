//
//  Personal+Extended.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Personal+Extended.h"
#import "Personal.h"
#import "Vehicle.h"
#import "Insurance.h"

@implementation Personal (Extended)

+ (Personal *)newPersonalInContext:(NSManagedObjectContext *)context{
    Personal *personal = [NSEntityDescription insertNewObjectForEntityForName:@"Personal" inManagedObjectContext:context];
 
    return personal;
}

@end
