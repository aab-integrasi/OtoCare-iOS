//
//  AABTableViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AABTableViewController : UITableViewController

@property (nonatomic, strong) UILabel *labelLoading;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showLoadingView;
- (void)showLoadingViewWithTitle:(NSString *)title;
- (void)hideLoadingView;

@end
