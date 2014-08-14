//
//  AABVehicleDetailVC.h
//  otocare
//
//  Created by Asuransi Astra Buana on 8/14/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABTableViewController.h"
#import "FPPopoverController.h"
#import "Vehicle.h"
#import "FPPopoverController.h"
#import "Personal.h"

@interface AABVehicleDetailVC : AABTableViewController

@property (nonatomic, strong) Vehicle *vehicle;
@property (nonatomic, strong) Personal *personal;

@end
