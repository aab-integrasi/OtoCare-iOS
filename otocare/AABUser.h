//
//  AABUser.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AABUser : NSObject


@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *officeName;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *accessExpiryDate;

@property (nonatomic, readonly) BOOL roleInterception;
@property (nonatomic, readonly) BOOL roleICC;
@property (nonatomic, readonly) BOOL roleOperation;

- (AABUser *)initWithDictionary:(NSDictionary *)dictionary;
- (AABUser *)initFromKeychain;

- (void)saveToKeychain;
- (void)deleteFromKeychain;


@end
