//
//  AABVehicleViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/10/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABTableViewController.h"
#import "Vehicle.h"
#import "Personal.h"
#import "AABInsuranceViewController.h"

@protocol AABVehicleViewControllerDelegate;


@interface AABVehicleViewController : AABTableViewController<AABInsuranceViewControllerDelegate>

@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic, strong) Personal *personal;
@property (weak, atomic) id<AABVehicleViewControllerDelegate> delegate;
@end


@protocol AABVehicleViewControllerDelegate <NSObject>

@end
