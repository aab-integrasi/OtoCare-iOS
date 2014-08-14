//
//  AABHomeViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Personal.h"

@interface AABHomeViewController : UIViewController

@property (nonatomic, strong) Personal *personal;
@property (weak, nonatomic) IBOutlet UILabel *InsuranceDate;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *simLabel;
@property (weak, nonatomic) IBOutlet UILabel *stnkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceNotification;
@property (weak, nonatomic) IBOutlet UIImageView *serviceNotification;
@property (weak, nonatomic) IBOutlet UIImageView *simNotification;
@property (weak, nonatomic) IBOutlet UIImageView *stnkNotification;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceImage;
@property (weak, nonatomic) IBOutlet UIImageView *simImage;
@property (weak, nonatomic) IBOutlet UIImageView *serviceImage;
@property (weak, nonatomic) IBOutlet UIImageView *stnkImage;
@property (weak, nonatomic) IBOutlet UIImageView *fuelImage;
@property (weak, nonatomic) IBOutlet UIImageView *reportImage;
@property (weak, nonatomic) IBOutlet UIImageView *reportClaimImage;
@property (weak, nonatomic) IBOutlet UIImageView *serviceBigImage;

@property (weak, nonatomic) IBOutlet UIImageView *callImage;
@end
