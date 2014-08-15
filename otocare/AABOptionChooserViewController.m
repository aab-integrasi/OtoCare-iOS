//
//  AABOptionChooserViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/13/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABOptionChooserViewController.h"
#import "AABConstants.h"
#import "AABFormCell.h"
#import "UIFont+IMMS.h"
#import "UIColor+AAB.h"


@interface AABOptionChooserViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation AABOptionChooserViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.options[indexPath.row] description];
            cell.textLabel.textColor = [UIColor AABDeepBlue];
    cell.accessoryType = [self.selectedIndexPath isEqual:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    if (indexPath.row == 0 && self.firstRowIsSpecial) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont italicSystemFontOfSize:16];
        if (self.view.tintColor) cell.textLabel.textColor = self.view.tintColor;
    }else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont regularFontWithSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (NSIndexPath *) getSelectedIndexPath
{
    return self.selectedIndexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedIndexPath && ![self.selectedIndexPath isEqual:indexPath]) {
        [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    self.selectedIndexPath = indexPath;
    [[tableView cellForRowAtIndexPath:self.selectedIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    if (self.onOptionSelected) {
        self.onOptionSelected(self.options[indexPath.row]);
    }else if (self.delegate && [self.delegate respondsToSelector:@selector(optionChooser:didSelectOptionAtIndex:withValue:)]) {
        [self.delegate optionChooser:self didSelectOptionAtIndex:indexPath.row withValue:self.options[indexPath.row]];
    }
}


#pragma mark View Lifecycle
- (id)initWithOptions:(NSArray *)options delegate:(id<AABOptionChooserDelegate>)delegate
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.options = options;
    self.delegate = delegate;
    return self;
}

- (id)initWithOptions:(NSArray *)options onOptionSelected:(void (^)(id selectedValue))onOptionSelected
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.options = options;
    self.delegate = nil;
    self.onOptionSelected = onOptionSelected;
    return self;
}

- (id)initWithConstantsKey:(NSString *)constantsKey delegate:(id<AABOptionChooserDelegate>)delegate
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.options = [AABConstants constantsForKey:constantsKey];
    self.constantsKey = constantsKey;
    self.delegate = delegate;
    self.onOptionSelected = nil;
    return self;
}

- (void)setSelectedValue:(id)selectedValue
{
    _selectedValue = selectedValue;
    
    if (self.selectedValue && self.options) {
        NSUInteger row = [self.options indexOfObject:selectedValue];
        self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    }
}

- (CGSize)preferredContentSize
{
    CGFloat height = [self.options count] * 44;
    return CGSizeMake(300, height > 400 ? 400 : height);
}

+ (UINavigationController *)navigatedChooserWithOptions:(NSArray *)options delegate:(id<AABOptionChooserDelegate>)delegate
{
    AABOptionChooserViewController *rootVC = [[AABOptionChooserViewController alloc] initWithOptions:options delegate:delegate];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    return navigationController;
}

@end
