//
//  IMFormCell.h
//  otocare
//
//Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    IMFormCellTypeDetail,
    IMFormCellTypeTextInput,
    IMFormCellTypeStepper,
    IMFormCellTypeCheckmark,
    IMFormCellTypeSubtitle,
    IMFormCellTypeTitle,
    IMFormCellTypeDetailCenter,
    IMFormCellTypeSwitch,
    IMFormCellTypeButton
}IMFormCellType;

@interface IMFormCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelValue;
@property (nonatomic, strong) UITextField *textValue;
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, readonly) IMFormCellType type;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UISwitch *switcher;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic) int maxCharCount;
@property (nonatomic, strong) NSArray *characterSets;
@property (nonatomic, copy) void (^onTextValueReturn)(NSString *value);
@property (nonatomic, copy) void (^onStepperValueChanged)(int newValue);
@property (nonatomic, copy) void (^onSwitcherValueChanged)(BOOL value);
@property (nonatomic, copy) void (^onButtonPush)(void);

@property (nonatomic) BOOL editingEnabled;

- (IMFormCell *)initWithFormType:(IMFormCellType)type reuseIdentifier:(NSString *)identifier;

@end