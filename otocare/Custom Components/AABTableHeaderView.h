//
//  AABTableHeaderView.h
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIFont+IMMS.h"

@interface AABTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *buttonAction;
@property (nonatomic, strong) UIButton *buttonAdd;

- (id)initWithTitle:(NSString *)title actionTitle:(NSString *)actionTitle reuseIdentifier:(NSString *)identifier;
- (id)initWithTitle:(NSString *)title actionTitle:(NSString *)actionTitle alignCenterY:(BOOL)alignCenterY reuseIdentifier:(NSString *)identifier;
- (id)initWithTitle:(NSString *)title reuseIdentifier:(NSString *)identifier;
- (id)initWithInfoButtonAndTitle:(NSString *)title reuseIdentifier:(NSString *)identifier;

@end
