//
//  Insurance+Import.h
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Insurance.h"

@interface Insurance (Import)

+ (Insurance *)insuranceWithDictionary:(NSDictionary *)dictionary
                      inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Insurance *)insuranceWithId:(NSString *)policyNumber
              inManagedObjectContext:(NSManagedObjectContext *)context;

@end
