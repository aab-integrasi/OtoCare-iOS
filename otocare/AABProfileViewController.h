//
//  AABProfileViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Personal.h"

@interface AABProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *engineNumber;
@property (weak, nonatomic) IBOutlet UITextField *chassisNumber;
@property (weak, nonatomic) IBOutlet UISwitch *isNotCustomer;
@property (nonatomic, strong) Personal *personal;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewController;
- (void)performSendJSON;

@end
