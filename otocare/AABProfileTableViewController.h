//
//  AABProfileTableViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/8/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AABTableViewController.h"
#import "Personal.h"
#import "AABVehicleViewController.h"


@protocol AABProfileTableViewControllerDelegate;

@interface AABProfileTableViewController : AABTableViewController <AABVehicleViewControllerDelegate>

@property (nonatomic, strong) Personal *personal;
@property (weak, atomic) id<AABProfileTableViewControllerDelegate> delegate;

@end


@protocol AABProfileTableViewControllerDelegate <NSObject>

@end