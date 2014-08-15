//
//  AABAppDelegate.m
//  otocare
//
//  Created by Benny Susilo on 8/4/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AABConstants.h"
#import "AABDBManager.h"
#import "AABAuthManager.h"
#import "AABHTTPClient.h"
#import "UIColor+AAB.h"

@implementation AABAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
             [[UINavigationBar appearance] setBarTintColor:[UIColor AABBlue]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                            nil]];

    
//    if (AABGoogleAPIKey == Nil) {
//        [AABConstants initialize];
//    }
//    
//    [GMSServices provideAPIKey:AABGoogleAPIKey];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        if ([AABAuthManager sharedManager].activeUser) {
            [[AABAuthManager sharedManager].activeUser deleteFromKeychain];
            [AABAuthManager sharedManager].activeUser = nil;
        }

        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setBool:NO forKey:@"FirstRun"];
        [def setBool:YES forKey:AABBackgroundUpdates];
        [def synchronize];
    }

    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        [[AABDBManager sharedManager] saveDatabase:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([[AABAuthManager sharedManager] isTokenExpired]) [[AABAuthManager sharedManager] logout];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([[AABAuthManager sharedManager] isLoggedOn]) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:AABLastSyncDate]) {
            //TODO : comment for testing
            [[AABDBManager sharedManager] checkForUpdates];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:AABSyncShouldStartedNotification object:nil userInfo:nil];
        }
        //TODO : comment for testing
        [self checkAppUpdates];
    }
    
    [[AABDBManager sharedManager] openDatabase:^(BOOL success){
        if (!success) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed Opening Database" message:@"Local database may corrupt, please relaunch the application or reset local database from Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
     [[AABDBManager sharedManager] closeDatabase];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}


- (void)checkAppUpdates
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSNumber *version    = infoDictionary[@"CFBundleShortVersionString"];
    NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
    
    AABHTTPClient *client = [AABHTTPClient sharedClient];
    [client getJSONWithPath:@"update/app"
                 parameters:@{@"appVersion": version, @"appName": bundleName}
                    success:^(NSDictionary *jsonData, int statusCode){
                        NSString *stringUrl = jsonData[@"payloadUrl"];
                        if (stringUrl) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringUrl]];
                        }
                    }
                    failure:nil];
}

@end
