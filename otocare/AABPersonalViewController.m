//
//  AABPersonalViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/14/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABPersonalViewController.h"
#import "Personal.h"
#import "AABProfileTableViewController.h"
#import "AABVehicleViewController.h"
#import "AABInsuranceViewController.h"

@interface AABPersonalViewController ()

@property (nonatomic, strong) Personal *personal;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *title;

@end

@implementation AABPersonalViewController

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


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

// This method is called when the user selects an event in the table view. It configures the destination
// event view controller with this event.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showViewController"])
    {
    
        if([self.title isEqualToString:@"Personal information"]){
            AABProfileTableViewController * vc = (AABProfileTableViewController*) [segue destinationViewController];
            vc.title = self.title;
        }else if([self.title isEqualToString:@"Vehicle information"]){
            //vehicle
            //            show Vehicle information view controller
            NSLog(@"show Vehicle information view controller");
            self.title= @"Vehicle information";
//            AABVehicleViewController * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"AABVehicleViewController"];
                        AABVehicleViewController * vc = (AABVehicleViewController*) [segue destinationViewController];
            vc.title = self.title;
            
            //                         [self.navigationController pushViewController:vc animated:YES];
            //             [self presentViewController:vc animated:YES completion:nil];
            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navCon animated:YES completion:nil];
        }else if([self.title isEqualToString:@"Insurance information"]){
            AABInsuranceViewController * vc = (AABInsuranceViewController*) [segue destinationViewController];
            vc.title = self.title;
        }
       
        
    }
}

- (void) test{
    NSLog(@"Call Test");
}

- (void) cancel{
    NSLog(@"Call Cancel");
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        // Get the event at the row selected and display its title
        if(indexPath.row == 0){
            //personal
//            show Personal information view controller
            NSLog(@"show Personal information view controller");
            self.title= @"Personal information";
            AABProfileTableViewController * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileTableViewController"];
            
            vc.title = self.title;
//            vc.nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
//                                                                                                          target:self action:@selector(test)];
//             vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(cancel)];
//    [self.presentingViewController pushViewController:vc animated:YES];
            //disable editing
//            vc.allowEditing = NO;
            vc.editButtonItem.title = @"Edit";
             [self.navigationController presentViewController:vc animated:YES completion:nil];
            

            
        }else if (indexPath.row == 1){
//            //vehicle
////            show Vehicle information view controller
//            NSLog(@"show Vehicle information view controller");
//             self.title= @"Vehicle information";
//            AABVehicleViewController * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"AABVehicleViewController"];
//            vc.title = self.title;
////                         [self.navigationController pushViewController:vc animated:YES];
////             [self presentViewController:vc animated:YES completion:nil];
//            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
//            [self presentViewController:navCon animated:YES completion:nil];
            
        }else if (indexPath.row == 2){
            //insurance
//            show Insurance information view controller;
                        NSLog(@"show Insurance information view controller");
            
             self.title= @"Insurance information";
            AABInsuranceViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AABInsuranceViewController"];
            vc.title = self.title;
//                [self.parentViewController.navigationController pushViewController:vc animated:YES];
//                         [self.parentViewController.navigationController presentViewController:vc animated:YES completion:nil];
            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.parentViewController presentViewController:navCon animated:YES completion:nil];
        }
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
    // Get the event at the row selected and display its title
    if(indexPath.row == 0){
        //personal
            cell.textLabel.text = @"Personal information";
    }else if (indexPath.row == 1){
        //vehicle
                    cell.textLabel.text = @"Vehicle information";
    }else if (indexPath.row == 2){
        //insurance
         cell.textLabel.text = @"Insurance information";
    }
    
    }
    return cell;
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
