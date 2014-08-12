//
//  Insurance+Extended.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Insurance+Extended.h"

@implementation Insurance (Extended)


+ (Insurance *)newInsuranceInContext:(NSManagedObjectContext *)context{
    Insurance *insurance = [NSEntityDescription insertNewObjectForEntityForName:@"Insurance" inManagedObjectContext:context];
    
    return insurance;
}
@end
