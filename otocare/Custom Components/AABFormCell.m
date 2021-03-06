//
//  AABFormCell.m
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABFormCell.h"
#import "UIFont+IMMS.h"
#import "UIColor+IMMS.h"
#import "UIColor+AAB.h"

@interface AABFormCell()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imageAccessory;

@end

@implementation AABFormCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (AABFormCell *)initWithFormType:(AABFormCellType)type reuseIdentifier:(NSString *)identifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    _type = type;
    self.selectionStyle = UITableViewCellEditingStyleNone;
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.labelTitle = [[UILabel alloc] init];
    self.labelTitle.textAlignment = NSTextAlignmentLeft;
    self.labelTitle.font = font;
    self.labelTitle.textColor = [UIColor AABDeepBlue];
    [self.labelTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:self.labelTitle];
    
    switch (type) {
        case AABFormCellTypeDetail:
            self.labelValue = [[UILabel alloc] init];
            self.labelValue.backgroundColor = [UIColor clearColor];
            self.labelValue.textAlignment = NSTextAlignmentRight;
            self.labelValue.font = font;
            self.labelValue.textColor = [UIColor darkGrayColor];
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //            self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [self.labelValue setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.labelValue];
            break;
        case AABFormCellTypeDetailCenter:
            self.labelTitle.textAlignment = NSTextAlignmentRight;
            self.labelValue = [[UILabel alloc] init];
            self.labelValue.backgroundColor = [UIColor clearColor];
            self.labelValue.textAlignment = NSTextAlignmentLeft;
            self.labelValue.font = font;
            self.labelValue.textColor = [UIColor darkGrayColor];
            self.accessoryType = UITableViewCellAccessoryNone;
            [self.labelValue setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.labelValue];
            break;
        case AABFormCellTypeTitle:
            self.accessoryType = UITableViewCellAccessoryNone;
            self.labelTitle.font = font;
            break;
        case AABFormCellTypeCheckmark:
            self.imageAccessory = [[UIImageView alloc] initWithImage:nil
                                                    highlightedImage:[UIImage imageNamed:@"icon-checkbox-checked"]];
            self.imageAccessory.contentMode = UIViewContentModeRight;
            [self.imageAccessory setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.imageAccessory];
            break;
        case AABFormCellTypeStepper:
            self.labelValue = [[UILabel alloc] init];
            self.labelValue.backgroundColor = [UIColor clearColor];
            self.labelValue.textAlignment = NSTextAlignmentRight;
            self.labelValue.text = @"0";
            [self.labelValue setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.labelValue];
            
            self.stepper = [[UIStepper alloc] init];
            self.stepper.minimumValue = 0;
            self.stepper.maximumValue = 100;
            self.stepper.stepValue = 1;
            [self.stepper addTarget:self action:@selector(updateValueFromStepper:) forControlEvents:UIControlEventValueChanged];
            [self.stepper setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.stepper];
            break;
        case AABFormCellTypeTextInput:
            self.textValue = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            self.textValue.font = font;
            self.textValue.textColor = [UIColor darkGrayColor];
            self.textValue.textAlignment = NSTextAlignmentRight;
            self.textValue.delegate = self;
            self.textValue.autocapitalizationType = UITextAutocapitalizationTypeWords;
            self.textValue.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.textValue.returnKeyType = UIReturnKeyDone;
            [self.textValue setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.textValue];
            break;
        case AABFormCellTypeSubtitle:
            self.labelValue = [[UILabel alloc] init];
            self.labelValue.backgroundColor = [UIColor clearColor];
            self.labelValue.textAlignment = NSTextAlignmentLeft;
            self.labelValue.font = font;
            self.labelValue.textColor = [UIColor grayColor];
            self.labelValue.numberOfLines = 0;
            self.labelValue.lineBreakMode = NSLineBreakByWordWrapping;
            self.accessoryType = UITableViewCellAccessoryNone;
            [self.labelValue setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.contentView addSubview:self.labelValue];
            break;
        case AABFormCellTypeSwitch:
            self.switcher = [[UISwitch alloc] init];
            self.switcher.translatesAutoresizingMaskIntoConstraints = NO;
            [self.switcher addTarget:self action:@selector(switcherValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:self.switcher];
            break;
        case AABFormCellTypeButton:
            self.button = [[UIButton alloc] init];
            self.button.hidden = NO;
            self.button.tintColor = [UIColor IMRed];
            [self.button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
            break;
    }
    self.labelValue.textColor = self.textValue.textColor = [UIColor AABThinBlue];
    
    [self setupUI];
    
    return self;
}

- (void)push
{
    if (self.onButtonPush) {
        self.onButtonPush();
    }
}
- (void)setupUI
{
    NSDictionary *views;
    
    switch (self.type) {
        case AABFormCellTypeDetail:
            views = NSDictionaryOfVariableBindings(_labelTitle, _labelValue);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_labelTitle]-20-[_labelValue]-|"
                                                                                     options:NSLayoutFormatDirectionLeftToRight
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_labelValue
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
            break;
        case AABFormCellTypeDetailCenter:
            views = NSDictionaryOfVariableBindings(_labelTitle, _labelValue);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(20,==20@900)-[_labelTitle]-20-[_labelValue]-(20,==20@900)-|"
                                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|"
                                                                                     options:NSLayoutFormatAlignAllCenterX
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.labelValue attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            break;
        case AABFormCellTypeCheckmark:
            views = NSDictionaryOfVariableBindings(_labelTitle, _imageAccessory);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_imageAccessory]-20-[_labelTitle]-|"
                                                                                     options:NSLayoutFormatDirectionRightToLeft
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_imageAccessory
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
            break;
        case AABFormCellTypeStepper:
            views = NSDictionaryOfVariableBindings(_labelTitle, _labelValue, _stepper);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_stepper]-20-[_labelValue]-20-[_labelTitle]-|"
                                                                                     options:NSLayoutFormatDirectionRightToLeft
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_labelValue
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_stepper
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
            break;
        case AABFormCellTypeTextInput:
            views = NSDictionaryOfVariableBindings(_labelTitle, _textValue);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_labelTitle]-20-[_textValue(>=100)]-|"
                                                                                     options:NSLayoutFormatDirectionLeftToRight
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_textValue
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
            
            break;
        case AABFormCellTypeSubtitle:
            views = NSDictionaryOfVariableBindings(_labelTitle, _labelValue);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_labelTitle]-|"
                                                                                     options:NSLayoutFormatDirectionLeftToRight
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[_labelTitle]-(5)-[_labelValue]-(5)-|" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_labelValue
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1
                                                                          constant:0]];
            break;
        case AABFormCellTypeTitle:
        case AABFormCellTypeButton:
            views = NSDictionaryOfVariableBindings(_labelTitle);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_labelTitle]-|"
                                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|" options:0 metrics:nil views:views]];
            break;
        case AABFormCellTypeSwitch:
            views = NSDictionaryOfVariableBindings(_labelTitle, _switcher);
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_switcher]-20-[_labelTitle]-|"
                                                                                     options:NSLayoutFormatDirectionRightToLeft
                                                                                     metrics:nil
                                                                                       views:views]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelTitle]|" options:0 metrics:nil views:views]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelTitle
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_switcher
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:0]];
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.type == AABFormCellTypeTitle) return;
    self.labelTitle.font = selected ? [UIFont boldSystemFontOfSize:self.labelTitle.font.pointSize] : [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    if (self.type == AABFormCellTypeCheckmark) {
        self.imageAccessory.highlighted = selected;
    }else if (self.type == AABFormCellTypeDetail || self.type == AABFormCellTypeStepper) {
        self.labelValue.font = selected ? [UIFont boldSystemFontOfSize:self.labelValue.font.pointSize] : [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }else if (self.type == AABFormCellTypeTextInput) {
        if (selected && self.textValue.enabled) [self.textValue becomeFirstResponder];
        if (!selected && self.textValue.enabled) [self.textValue resignFirstResponder];
    }
}

- (void)updateValueFromStepper:(UIStepper *)stepper
{
    int value = stepper.value;
    self.labelValue.text = [NSString stringWithFormat:@"%i", value];
    if (self.onStepperValueChanged) self.onStepperValueChanged(value);
}

- (void)setEditingEnabled:(BOOL)editingEnabled
{
    _editingEnabled = editingEnabled;
    self.textValue.enabled = editingEnabled;
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.characterSets count]) {
        string = [string lowercaseString];
        
        for (NSCharacterSet *characterSet in self.characterSets) {
            string = [string stringByTrimmingCharactersInSet:characterSet];
        }
        
        if (string.length) return NO;
    }
    
    BOOL stat = self.maxCharCount == 0 ? YES : textField.text.length + string.length <= self.maxCharCount;
    
    if (stat && self.onTextValueReturn) {
        self.onTextValueReturn([NSString stringWithFormat:@"%@%@", textField.text, string]);
    }
    
    return stat;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setSelected:YES animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.onTextValueReturn) self.onTextValueReturn(textField.text);
    [self setSelected:NO animated:YES];
}

- (void)switcherValueChanged:(UISwitch *)sender
{
    if (self.onSwitcherValueChanged) self.onSwitcherValueChanged(sender.on);
}

@end
