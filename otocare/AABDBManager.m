//
//  AABDBManager.m
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABDBManager.h"
#import "AABConstants.h"
#import "NSDate+Relativity.h"
#import "AABHTTPClient.h"
#import "AABBackgroundFetcher.h"

@implementation AABDBManager

#pragma mark Initializer
+ (AABDBManager *)sharedManager
{
    static dispatch_once_t once;
    static AABDBManager *singleton = nil;
    
    dispatch_once(&once, ^{
        singleton = [[AABDBManager alloc] init];
    });
    
    return singleton;
}

- (UIManagedDocument *)localDatabase
{
    if (!_localDatabase) {
        NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        url = [url URLByAppendingPathComponent:AABLocaDBName];
        _localDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                  NSInferMappingModelAutomaticallyOption: @(YES),
                                  NSFileProtectionKey: NSFileProtectionCompleteUnlessOpen};
        _localDatabase.persistentStoreOptions = options;
    }
    
    return _localDatabase;
}

- (void)openDatabase:(void (^)(BOOL success))successBlock
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.localDatabase.fileURL path]]) {
        [self.localDatabase saveToURL:self.localDatabase.fileURL
                     forSaveOperation:UIDocumentSaveForCreating
                    completionHandler:^(BOOL success){
                        [self.localDatabase openWithCompletionHandler:successBlock];
                    }];
    }else if (self.localDatabase.documentState == UIDocumentStateClosed){
        [self.localDatabase openWithCompletionHandler:^(BOOL success){
            if (!success) {
                [[NSFileManager defaultManager] removeItemAtURL:self.localDatabase.fileURL error:nil];
                [AABDBManager resetDBPreferences];
                [self openDatabase:successBlock];
            }
        }];
    }
}

- (void)closeDatabase
{
    [self.localDatabase closeWithCompletionHandler:^(BOOL success){
        self.localDatabase = nil;
    }];
}

- (void)saveDatabase:(void (^)(BOOL success))successBlock
{
    [self.localDatabase saveToURL:self.localDatabase.fileURL
                 forSaveOperation:UIDocumentSaveForOverwriting
                completionHandler:^(BOOL success){
                    if (success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:AABDatabaseChangedNotification object:nil userInfo:nil];
                    }
                    if (successBlock) successBlock(success);
                }];
}

- (void)removeDatabase:(void (^)(BOOL success))successHandler
{
    @try {
        if (self.onProgress) {
            self.onProgress();
        }
        NSManagedObjectContext *managedObjectContext = self.localDatabase.managedObjectContext;
        NSError * error;
        // retrieve the store URL
        NSURL * storeURL = [[managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
        // lock the current context
        [managedObjectContext lock];
        [managedObjectContext reset];//to drop pending changes
        //delete the store from the current managedObjectContext
        if ([[managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
        {
            // remove the file containing the data
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
            //recreate the store like in the  appDelegate method
            [[managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
        }
        [managedObjectContext unlock];
        [AABDBManager resetDBPreferences];
        
        //recreate database
        [self openDatabase:^(BOOL databaseOpened){
            if (successHandler) successHandler(databaseOpened);
        }];
        if (successHandler) successHandler(YES);
    }
    @catch (NSException *exception) {
        NSLog(@"Exception while removing database: %@", [exception description]);
        if (successHandler) successHandler(NO);
    }
}

- (void)checkForUpdates
{
    NSDate *lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:AABLastSyncDate];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (lastSyncDate) [params setObject:[lastSyncDate toUTCString] forKey:@"since"];
    
    [[AABHTTPClient sharedClient] getJSONWithPath:@"update/data"
                                      parameters:params
                                         success:^(NSDictionary *jsonData, int statusCode){
                                             int interception = [jsonData[@"interception"] intValue];
                                             int accommodation = [jsonData[@"accommodation"] intValue];
                                             int total = interception + accommodation;
                                             BOOL backgroundUpdates = [[[NSUserDefaults standardUserDefaults] objectForKey:AABBackgroundUpdates] boolValue];
                                             
                                             if (total && backgroundUpdates) {
                                                 [self startBackgroundUpdates];
                                             }else if (total && !backgroundUpdates) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:AABSyncShouldStartedNotification object:nil userInfo:@{AABUpdatesAvailable: @(total)}];
                                             }
                                         }
                                         failure:nil];
}

- (void)startBackgroundUpdates
{
    _updating = YES;
    AABBackgroundFetcher *updater = [[AABBackgroundFetcher alloc] init];
    [updater startBackgroundUpdatesWithCompletionHandler:^(BOOL success){
        _updating = NO;
        if (success) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSDate date] forKey:AABLastSyncDate];
            [defaults synchronize];
            
            [self saveDatabase:nil];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updates Failed"
                                                            message:@"Failed updating application data. Go to Settings > Check Data Updates to restart.\nIf problem persist, please contact administrator."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


#pragma mark Preferences Methods
+ (void)resetDBPreferences
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:AABLastSyncDate];
//    [def removeObjectForKey:IMInterceptionFetcherUpdate];
    [def synchronize];
}


@end
