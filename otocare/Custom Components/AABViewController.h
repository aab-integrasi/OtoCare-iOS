//
//  AABViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AABConstants.h"
#import "UIColor+IMMS.h"
//#import "UIButton+IMMS.h"
#import "UIFont+IMMS.h"

@interface AABViewController : UIViewController


@property (nonatomic, strong) UILabel *labelLoading;

- (void)showLoadingView;
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
