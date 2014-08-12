//
//  AABProfileViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABProfileViewController.h"
#import "Reachability/Reachability.h"
 #import <SystemConfiguration/SystemConfiguration.h>
#import "AABHTTPClient.h"
#import "Personal.h"
#import "Personal+Extended.h"
#import "AABDBManager.h"
#import "Vehicle+Extended.h"
#import "AABProfileTableViewController.h"
#import "MBProgressHUD.h"
#import "AABConstants.h"
#import "Personal+Import.h"

@interface AABProfileViewController ()<MBProgressHUDDelegate>

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) Vehicle * vehicle;

@end

@implementation AABProfileViewController

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
    
    //check from database
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Personal"];
    request.returnsObjectsAsFaults = YES;
    
    NSManagedObjectContext * context = [AABDBManager sharedManager].localDatabase.managedObjectContext;
    // Generate data
    NSError *error;
    NSArray * result = [context executeFetchRequest:request error:&error];
    if (error){
        NSLog(@"Error Loading Data : %@",[error description]);
    }
    
    if (![result count]) {
        //case there is no data on database
        //create new personal information
        if (!self.personal) {
            //create new personal
            self.personal = [Personal newPersonalInContext:context];
        }
    }else {
        //get data from database
        self.personal = [result lastObject];
        
        //get vehicle
        //get vehicle object from personal
        NSArray * objects = [self.personal.vehicle allObjects];
        
        if ([objects count]) {
            //save to local
            self.vehicle = [objects  lastObject];
        }
    }
    
    //case if already have data in profile, then
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (IBAction)policeNumber:(id)sender {
    //save data
//    if (self.policeNumber.text) {
//        self.vehicle.policeNumber = self.policeNumber.text;
//    }
}
- (IBAction)chassisNumber:(id)sender {
    
    //save data
//    if (self.chassisNumber.text) {
//        self.vehicle.chassisNumber = self.chassisNumber.text;
//    }
}

- (IBAction)customer:(id)sender {
    //save current data
//    self.personal.isCustomer = @(self.isNotCustomer.on);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)tapBackground:(id)sender {
        [self.view endEditing:YES];
}


- (IBAction)submitButton:(id)sender {
    
    //save current data
    self.personal.isCustomer = @(self.isNotCustomer.on);
    
    //case not Garda Oto Customer, than open blank profile registration
    if (self.isNotCustomer.on) {
    
        //open new profile
        AABProfileTableViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileTableViewController"];
        
        if (self.policeNumber.text.length || self.chassisNumber.text.length) {
            //user already input value then forward that value
            
            //get vehicle object from personal
            NSArray * objects = [self.personal.vehicle allObjects];
            
            if ([objects count]) {
                for (Vehicle * vehicle in objects) {
                    if ([vehicle.chassisNumber isEqualToString:self.chassisNumber.text] || [vehicle.policeNumber isEqualToString:self.policeNumber.text]) {
                        //save data
                        if (!self.chassisNumber.text) vehicle.chassisNumber = self.chassisNumber.text;
                        if (!self.policeNumber.text) vehicle.policeNumber = self.policeNumber.text;
                            
                            }
                }
            }else{
                //add manually to personal
                Vehicle * vehicle = [Vehicle newVehicleInContext:self.personal.managedObjectContext];
                
                if(self.chassisNumber.text) vehicle.chassisNumber = self.chassisNumber.text;
                if(self.policeNumber.text) vehicle.policeNumber = self.policeNumber.text;
            }
        }
//        if (self.personal) {
//             [profile setPersonal:self.personal];
//        }
        [self.tabBarController presentViewController:profile animated:YES completion:nil];
        
    }else {
        //if customer than, check the input and then send data to server
        if (!self.policeNumber.text.length && !self.chassisNumber.text.length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The police number and chassis number that you input is not valid" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (!self.policeNumber.text.length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input the policy number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (!self.chassisNumber.text.length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input the chassis number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
        
        
        //show confirmation
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Data"
                                                        message:@"All your data will be uploaded and you need internet connection to do this.\nContinue submit?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = AABAlertUpload_Tag;
        [alert show];

    }
    
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AABAlertUpload_Tag && buttonIndex != [alertView cancelButtonIndex]) {
        //start uploading
        if (!_HUD) {
            // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
            _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        }
        
        // Back to indeterminate mode
        _HUD.mode = MBProgressHUDModeIndeterminate;
        
        // Add HUD to screen
        [self.navigationController.view addSubview:_HUD];
        
        
        
        // Regisete for HUD callbacks so we can remove it from the window at the right time
        _HUD.delegate = self;
        
        _HUD.labelText = @"Submiting Data";
        
        
        // Show the HUD while the provided method executes in a new thread
        [_HUD showWhileExecuting:@selector(sending) onTarget:self withObject:nil animated:YES];
        
        
    }
    
}

- (void)sending {
    //check internet connection
    if (![self connected]) {
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can not perform this process when your mobile phone is offline. Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        // not connected
        NSLog(@"Not connected");
    } else {
        // connected, do some internet stuff
        NSLog(@"Connected");
        //formatting data & send
        NSMutableDictionary * formatted = [NSMutableDictionary dictionary];
        
        [formatted setObject:self.policeNumber.text forKey:@"policeNumber"];
        [formatted setObject:self.chassisNumber.text forKey:@"chassisNumber"];
        [formatted setObject:self.isNotCustomer.on?@"true":@"false" forKey:@"isNotCustomer"];
        NSLog(@"formatted : %@",[formatted description]);
        [self sendData:formatted];
    }
}


- (void)successSubmit:(NSDictionary *)json
{
    
    //parse json & forward to next view controller
    [self.personal parseJSON:json inManagedObjectContext:self.personal.managedObjectContext];
    
    
    //open new profile
    AABProfileTableViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileTableViewController"];
    
    //set editable to false
//    profile.ed
    
    
    //forward value to next view controller
    profile.personal = self.personal;
    
    [self.tabBarController presentViewController:profile animated:YES completion:nil];
    
}
- (void) sendData:(NSDictionary *)params
{
    NSLog(@"json example : %@",[params  description]);
    
    AABHTTPClient *client = [AABHTTPClient sharedClient];
    [client postJSONWithPath:@"otocare/submit"
                  parameters:params
                     success:^(NSDictionary *jsonData, int statusCode){
                         [self showAlertWithTitle:@"Upload Success" message:nil];
                         NSLog(@"Upload Success");
                         [self successSubmit:jsonData];
                     }
                     failure:^(NSDictionary *jsonData, NSError *error, int statusCode){
                         [self showAlertWithTitle:@"Upload Failed" message:@"Please check your network connection and try again. If problem persist, contact administrator."];
                         NSLog(@"Upload Fail : %@",[error description]);
                     }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    //    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
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
