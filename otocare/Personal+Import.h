//
//  Personal+Import.h
//  otocare
//
//  Created by Benny Susilo on 8/12/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "Personal.h"

@interface Personal (Import)

- (void)parseJSON:(NSDictionary *)json inManagedObjectContext:(NSManagedObjectContext *)context;;

@end
