//
//  Personal+Extended.h
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Personal.h"

@interface Personal (Extended)
+ (Personal *)newPersonalInContext:(NSManagedObjectContext *)context;

@end
