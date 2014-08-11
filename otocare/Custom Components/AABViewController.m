//
//  AABViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/9/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"
#import "UIImage+ImageUtils.h"

@interface AABViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic) BOOL loading;

@end

@implementation AABViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Specific Custom Implementation
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = AABDefaultAlertTag;
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
    //    self.labelLoading.textColor = self.view.tintColor;
    //    self.loadingIndicator.color = self.view.tintColor;
    
    self.labelLoading.textColor = [UIColor IMMagenta];
    self.labelLoading.textColor = [UIColor IMMagenta];
    
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
