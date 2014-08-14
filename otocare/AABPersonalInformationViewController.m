//
//  AABPersonalInformationViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/14/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABPersonalInformationViewController.h"

@interface AABPersonalInformationViewController ()
@property (nonatomic,strong)  UIBarButtonItem *itemSelected;
@end

@implementation AABPersonalInformationViewController

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
    self.itemSelected = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(setButton)];
            self.tableView.allowsSelection = NO;
    
    self.navigationItem.rightBarButtonItems = @[self.itemSelected];
    self.title = @"General Editing";
}

- (void)setButton
{
    if ([self.itemSelected.title isEqualToString:@"Edit"]) {
        self.tableView.allowsSelection = YES;
        //change title to Save
        self.itemSelected.title = @"Save";
        
        //reload data
        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
        
    }else {
        //change title to Select
        self.itemSelected.title = @"Edit";
        self.tableView.allowsSelection = NO;
        
        
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButton:(id)sender {
    if([self.actionButton.title isEqualToString:@"Edit"]){
        self.actionButton.title = @"Save";
    }else if ([self.actionButton.title isEqualToString:@"Save"]){
                self.actionButton.title = @"Edit";
    }
    
    NSLog(@"self.actionButton.title : %@",self.actionButton.title);
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
