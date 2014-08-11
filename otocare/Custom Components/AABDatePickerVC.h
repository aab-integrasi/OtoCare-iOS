//
//  AABDatePickerVC.h
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AABViewController.h"

@interface AABDatePickerVC : AABViewController

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, copy) void (^onDateChanged)(NSDate *selectedDate);
@property (nonatomic, copy) void (^onDone)(NSDate *selectedDate);
@property (nonatomic, copy) void (^onCancel)(void);

- (id)initWithAction:(void (^)(NSDate *selectedDate))action;
- (id)initWithDoneHandler:(void (^)(NSDate *selectedDate))doneHandler onCancel:(void(^)(void))onCancel;


@end
