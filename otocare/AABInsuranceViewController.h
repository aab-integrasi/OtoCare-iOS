//
//  AABInsuranceViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/10/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABTableViewController.h"
#import "Insurance.h"
#import "Personal.h"

@protocol AABInsuranceViewControllerDelegate;

@interface AABInsuranceViewController : AABTableViewController

@property (nonatomic, strong) Insurance *insurance;
@property (nonatomic, strong) Personal *personal;
@property (weak, atomic) id<AABInsuranceViewControllerDelegate> delegate;

@end


@protocol AABInsuranceViewControllerDelegate <NSObject>

@end

