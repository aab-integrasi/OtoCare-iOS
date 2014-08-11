//
//  AABConstants.m
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABConstants.h"

@implementation AABConstants

NSString *const CONST_ROOT                      = @"Root";
NSString *const CONST_AABConstantKeys            = @"AABConstantKeys";


+ (NSArray *)constantsForKey:(NSString *)key
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"]];
    return [dictionary objectForKey:key];
}

+ (void)setConstantForKey:(NSString *)key withValue:(NSString *)value;
{
    dispatch_queue_t constantQueue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    constantQueue = dispatch_queue_create("constantQueue", NULL);
    dispatch_sync(constantQueue, ^{
        
        [defaults setObject:value forKey:key];
        [defaults synchronize];
    });
    
    
}

+ (void) initialize
{
    if (self == [AABConstants class]) {
        NSDictionary *dictionary = [[self constantsForKey:CONST_AABConstantKeys] mutableCopy];
        
        if (!AABAPIKey)[self setConstantForKey:@"API Key" withValue:[dictionary objectForKey:AABAPIKeyConstant]];
        
        if (!AABAPISecret)[self setConstantForKey:@"API Secret" withValue:[dictionary objectForKey:AABAPISecretKey]];
        
        
        if (!AABBaseURL)[self setConstantForKey:@"API URL" withValue:[dictionary objectForKey:AABBaseURLKey]];
        
        if (!AABGoogleAPIKey)[self setConstantForKey:@"Google Places API KEY" withValue:[dictionary objectForKey:AABGoogleAPIKeyConstant]];
	}
}


+ (NSString *) constantStringForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


@end
