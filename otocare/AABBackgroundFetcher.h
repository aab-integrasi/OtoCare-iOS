//
//  AABBackgroundFetcher.h
//  otocare
//
//  Created by Benny Susilo on 8/11/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AABBackgroundFetcher : NSObject

- (void)startBackgroundUpdatesWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
