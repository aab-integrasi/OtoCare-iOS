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

@class Personal;
@protocol AABProfileTableViewControllerDelegate;

@interface AABProfileTableViewController : AABTableViewController <AABVehicleViewControllerDelegate>

@property (nonatomic, strong) Personal *personal;
@property (nonatomic) BOOL allowEditing;
@property (weak, atomic) id<AABProfileTableViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end


@protocol AABProfileTableViewControllerDelegate <NSObject>

@end