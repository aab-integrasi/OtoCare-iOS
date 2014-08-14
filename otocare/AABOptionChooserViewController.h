//
//  AABOptionChooserViewController.h
//  otocare
//
//  Created by Benny Susilo on 8/13/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABTableViewController.h"


@class AABOptionChooserViewController;
@protocol AABOptionChooserDelegate <NSObject>
- (void)optionChooser:(AABOptionChooserViewController *)optionChooser didSelectOptionAtIndex:(NSUInteger)selectedIndex withValue:(id)value;
@end


@interface AABOptionChooserViewController : AABTableViewController

@property (nonatomic, assign) id<AABOptionChooserDelegate> delegate;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, copy) void (^onOptionSelected)(id selectedValue);
@property (nonatomic, strong) NSString *constantsKey;
@property (nonatomic) BOOL firstRowIsSpecial;
@property (nonatomic, strong) id selectedValue;


+ (UINavigationController *)navigatedChooserWithOptions:(NSArray *)options delegate:(id<AABOptionChooserDelegate>)delegate;
- (id)initWithOptions:(NSArray *)options delegate:(id<AABOptionChooserDelegate>)delegate;
- (id)initWithOptions:(NSArray *)options onOptionSelected:(void (^)(id selectedValue))onOptionSelected;
- (id)initWithConstantsKey:(NSString *)constantsKey delegate:(id<AABOptionChooserDelegate>)delegate;
- (NSIndexPath *) getSelectedIndexPath;


@end
