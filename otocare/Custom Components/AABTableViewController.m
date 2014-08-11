//
//  AABTableViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"
#import "UIImage+ImageUtils.h"
#import "UIColor+IMMS.h"


@interface AABTableViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic) BOOL loading;

@end

@implementation AABTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor IMBorderColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Specific Custom Implementation
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


#pragma mark Loading View
- (void)showLoadingView
{
    [self showLoadingViewWithTitle:nil];
}

- (void)showLoadingViewWithTitle:(NSString *)title
{
    if (self.loading) return;
    
    self.loadingView.alpha = 0;
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.labelLoading.text = title;
    self.labelLoading.textColor = self.view.tintColor;
    self.loadingIndicator.color = self.view.tintColor;
    
    [self.view addSubview:self.loadingView];
    self.loadingView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:.25 animations:^{
        self.loadingView.transform = CGAffineTransformMakeScale(1, 1);
        self.loadingView.alpha = 1;
    } completion:^(BOOL finished){
        [self.loadingIndicator startAnimating];
        self.view.userInteractionEnabled = NO;
        self.loading = YES;
    }];
}

- (void)hideLoadingView
{
    if (!self.loading) return;
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.loadingView.alpha = 0;
                         self.loadingView.transform = CGAffineTransformMakeScale(0, 0);
                     }
                     completion:^(BOOL finished){
                         [self.loadingIndicator stopAnimating];
                         [self.loadingView removeFromSuperview];
                         self.view.userInteractionEnabled = YES;
                         
                         self.labelLoading = nil;
                         self.loadingIndicator = nil;
                         self.loadingView = nil;
                         self.loading = NO;
                     }];
}

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _loadingView.backgroundColor = [UIColor clearColor];
        _loadingView.center = self.view.center;
        
        UIImage *background = [[UIImage screenshotForView:self.view] applyExtraLightEffect];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.translatesAutoresizingMaskIntoConstraints = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.loadingView addSubview:imageView];
        
        self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        self.loadingIndicator.color = [UIColor blackColor];
        [_loadingView addSubview:self.loadingIndicator];
        
        self.labelLoading = [[UILabel alloc] initWithFrame:CGRectZero];
        self.labelLoading.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        self.labelLoading.translatesAutoresizingMaskIntoConstraints = NO;
        self.labelLoading.textColor = [UIColor blackColor];
        self.labelLoading.textAlignment = NSTextAlignmentCenter;
        [_loadingView addSubview:self.labelLoading];
        
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_loadingView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_loadingView attribute:NSLayoutAttributeCenterY multiplier:0.95 constant:0]];
        
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelLoading attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.loadingIndicator attribute:NSLayoutAttributeBottom multiplier:1 constant:30]];
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:self.labelLoading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.loadingIndicator attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }
    
    return _loadingView;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
