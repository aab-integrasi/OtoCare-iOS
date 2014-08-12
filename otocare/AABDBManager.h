//
//  AABDBManager.h
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

typedef void (^AABDBManagerOnProgressHandler)(void);


@interface AABDBManager : NSObject

@property (nonatomic, strong) UIManagedDocument *localDatabase;
@property (nonatomic, readonly) BOOL updating;

+ (AABDBManager *)sharedManager;

//Database operations
- (void)closeDatabase;
- (void)openDatabase:(void (^)(BOOL success))success;
- (void)saveDatabase:(void (^)(BOOL success))success;
- (void)removeDatabase:(void (^)(BOOL success))success;
@property (nonatomic, copy) AABDBManagerOnProgressHandler onProgress;

//Updates
- (void)checkForUpdates;

//App Preferences operations
+ (void)resetDBPreferences;


@end
