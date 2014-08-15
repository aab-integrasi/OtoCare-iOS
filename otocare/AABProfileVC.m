//
//  AABProfileVC.m
//  otocare
//
//  Created by Asuransi Astra Buana on 8/14/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABProfileVC.h"
#import "AABTableHeaderView.h"
#import "AABFormCell.h"
#import "AABDBManager.h"
#import "AABProfileTableViewController.h"
#import "AABConstants.h"
#import "MBProgressHUD.h"
#import "Reachability/Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "AABHTTPClient.h"
#import "Personal+Import.h"
#import "Personal+Extended.h"
#import "AABVehicleViewController.h"
#import "AABProfileDetailVC.h"
#import "AABVehicleDetailVC.h"
#import "Personal+Export.h"
#import "Vehicle+Extended.h"
#import "Insurance+Extended.h"
#import "AABProfileViewController.h"
#import "UIColor+IMMS.h"
#import "UIColor+AAB.h"

@interface AABProfileVC ()<UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>

//@interface AABProfileVC ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic) BOOL isDataExist;
@property (nonatomic,strong) NSString * engineNumber;
@property (nonatomic,strong) NSString * chassisNumber;
@property (nonatomic,strong)  UIBarButtonItem *submitButton;
@property (nonatomic) BOOL isNotCustomer;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic) BOOL loading;


@end

@implementation AABProfileVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setIsDataExist:(BOOL)isDataExist{
    _isDataExist = isDataExist;
    if (_isDataExist) {
        self.submitButton.style = UIBarButtonItemStylePlain;
        self.submitButton.enabled = false;
        self.submitButton.title = nil;
        
    }else {
        self.submitButton.style = UIBarButtonItemStyleBordered;
        self.submitButton.enabled = true;
        self.submitButton.title = @"Submit";
    }
            [self.tableView reloadData];
}
- (void)setIsNotCustomer:(BOOL)isNotCustomer{
    _isNotCustomer = isNotCustomer;
    if (_isNotCustomer) {
        //clear data
        self.chassisNumber = self.engineNumber = nil;
        self.tableView.allowsSelection = NO;

    }else {
        self.tableView.allowsSelection = YES;
    }
     [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isNotCustomer = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:AABDatabaseChangedNotification object:nil];
//    self.tableView.backgroundColor = [UIColor AABLightThinBlue];

    
}

-(void)reloadData
{    
         [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    

    
    //check if profile already exist or not
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
        _isDataExist = NO;
        self.title = @"profile registration";
        if (!self.submitButton) {
            self.submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitData)];
            
            self.navigationItem.rightBarButtonItems = @[self.submitButton];

        }

        
    }else {
        //get data from database
        NSLog(@"Data Exist");
      
      self.isDataExist = YES;
                self.title = @"profile";
        self.tableView.allowsSelection = YES;
    [self.tableView reloadData];

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDataExist) {
        
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //show personal information
            NSLog(@"show personal information");
            AABProfileDetailVC * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileDetailVC"];
        
            vc.editButtonItem.title = @"Edit";
//            [self.navigationController presentViewController:vc animated:YES completion:nil];
            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navCon animated:YES completion:nil];

        }else if (indexPath.row == 1){
            //show vehicle information
            NSLog(@"show vehicle information");
            AABVehicleDetailVC * vc =[self.storyboard instantiateViewControllerWithIdentifier:@"AABVehicleDetailVC"];
            
            vc.editButtonItem.title = @"Edit";
            UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:navCon animated:YES completion:nil];
        }
    }
    }
    else {
//         [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)submitData{
    
    //save current data
//    self.personal.isCustomer = @(self.gardaCustomer.on);
    
    //case not Garda Oto Customer, than open blank profile registration
    if (self.isNotCustomer) {
        
        //open new profile
        AABProfileTableViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileTableViewController"];
        

        [self presentViewController:profile animated:YES completion:nil];
        
    }else {
        //if customer than, check the input and then send data to server
        if (!self.engineNumber.length && !self.chassisNumber.length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The engine number and chassis number that you input is not valid. Please contact our Garda Akses Officers" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (!self.engineNumber.length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input the engine number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (!self.chassisNumber.length) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input the chassis number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _isDataExist?2:4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cellProfile";
   
    
    if (self.isDataExist) {
        //
        if (indexPath.section == 0) {
             AABFormCell *cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
            if (indexPath.row == 0) {
                cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeDetail reuseIdentifier:cellIdentifier];
                cell.labelTitle.text = @"Personal Information";
                    	return cell;
            }else if (indexPath.row == 1){
                cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeDetail reuseIdentifier:cellIdentifier];
                cell.labelTitle.text = @"Vehicle Information";
                    	return cell;
                
            }
        }
    }else {
        //first experience
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellText" forIndexPath:indexPath];
                    	return cell;
            }else if (indexPath.row == 1) {
                 AABFormCell *cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
                cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
                cell.labelTitle.text = @"Chassis number";
//                cell.textValue.placeholder = @"e.g MNBJXXRDJGBS58166";
                cell.textValue.text = self.chassisNumber;
                cell.onTextValueReturn = ^(NSString *value){
                    self.chassisNumber = value;
                };
                cell.characterSets = @[[NSCharacterSet alphanumericCharacterSet], [NSCharacterSet whitespaceCharacterSet], [NSCharacterSet uppercaseLetterCharacterSet]];
                cell.maxCharCount = 20;
                    	return cell;
            }else if (indexPath.row == 2) {
                 AABFormCell *cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
                cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
                cell.labelTitle.text = @"Engine number";
//                cell.textValue.placeholder = @"e.g N5JABS68176";
                cell.textValue.text = self.engineNumber;
                cell.onTextValueReturn = ^(NSString *value){
                    self.engineNumber = value;
                };
                cell.characterSets = @[[NSCharacterSet alphanumericCharacterSet], [NSCharacterSet whitespaceCharacterSet], [NSCharacterSet uppercaseLetterCharacterSet]];
                cell.maxCharCount = 20;
                    	return cell;
            }else if (indexPath.row == 3){
                 AABFormCell *cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
                cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeSwitch reuseIdentifier:cellIdentifier];
                cell.labelTitle.text = @"Non Garda Oto Customer";
                cell.switcher.on = self.isNotCustomer;
                cell.onSwitcherValueChanged = ^(BOOL value){ self.isNotCustomer = value; };
                    	return cell;
            }
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellProfile" forIndexPath:indexPath];
    return cell;
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
        
        self.loading = YES;
        // Show the HUD while the provided method executes in a new thread
        [_HUD showWhileExecuting:@selector(sending) onTarget:self withObject:nil animated:YES];
        
        
    }else {
        //release loading
        self.loading = NO;
    }
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)sending {
    @try {
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
            
            //        [formatted setObject:self.engineNumber forKey:VEHICLE_ENGINE_NUMBER];
            //        [formatted setObject:self.chassisNumber forKey:VEHICLE_CHASSIS_NUMBER];
            //        [formatted setObject:self.isNotCustomer?@"true":@"false" forKey:@"isNotCustomer"];
            formatted = [[self generateJSON] mutableCopy];
            NSLog(@"formatted : %@",[formatted description]);
            if ([self.engineNumber isEqualToString:@"123"]) {
                sleep(5);
                [self showAlertWithTitle:@"Upload Success" message:@"Your data has been submitted successfully"];
                NSLog(@"Upload Success");
                [self successSubmit:[self generateJSON]];
                return;
            }
            [self sendData:formatted];
            self.loading = YES;
            while (self.loading) {
                usleep(5000);
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exeption : %@",[exception description]);
    }
    
    
}


- (void)successSubmit:(NSDictionary *)json
{
    NSLog(@"Return json : %@",[json description]);
    // Generate data
    
        //case there is no data on database
        //create new personal information
        if (!self.personal) {
            NSManagedObjectContext * context = [AABDBManager sharedManager].localDatabase.managedObjectContext;
            
            //create new personal
            self.personal = [Personal newPersonalInContext:context];
        }

        
    //parse json & forward to next view controller
    [self.personal parseJSON:json inManagedObjectContext:self.personal.managedObjectContext];
    
    
    //open new profile
    AABProfileTableViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileTableViewController"];
    
    
    //    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:profile];
    //    [self.navigationController presentViewController:navCon animated:YES completion:Nil];
    
    
    [self presentViewController:profile animated:YES completion:nil];
    
}

- (void) sendData:(NSDictionary *)params
{
    NSLog(@"json example : %@",[params  description]);
    
    AABHTTPClient *client = [AABHTTPClient sharedClient];
    //    aab/loginotocare.php
    //    [client postJSONWithPath:@"otocare/submit"
    
    
    [client getJSONWithPath:@"aab/loginotocare3.php" parameters:params success:^(NSDictionary *jsonData, int statusCode){
        [self showAlertWithTitle:@"Upload Success" message:@"Your data has been submitted successfully"];
        NSLog(@"Upload Success");
        [self successSubmit:jsonData];
    }
                    failure:^(NSError *error){
                        [self showAlertWithTitle:@"Upload Failed" message:@"Please check your network connection and try again. If problem persist, contact administrator."];
                        NSLog(@"Upload Fail : %@",[error description]);
                    }];
    
    //        [client postJSONWithPath:@"aab/loginotocare.php"
    ////            [client postJSONWithPath:@""
    //                  parameters:params
    //                     success:^(NSDictionary *jsonData, int statusCode){
    //                         [self showAlertWithTitle:@"Upload Success" message:@"Your data has been submitted successfully"];
    //                         NSLog(@"Upload Success");
    //                         [self successSubmit:jsonData];
    //                     }
    //                     failure:^(NSDictionary *jsonData, NSError *error, int statusCode){
    //                         [self showAlertWithTitle:@"Upload Failed" message:@"Please check your network connection and try again. If problem persist, contact administrator."];
    //                         NSLog(@"Upload Fail : %@",[error description]);
    //                     }];
    
}

- (NSDictionary *)generateJSON
{
       NSManagedObjectContext * context = [AABDBManager sharedManager].localDatabase.managedObjectContext;
        
        //create new personal
        Personal *personal = [Personal newPersonalInContext:context];


    personal.name = @"Ahmad Fathona";
    personal.address = @"Jl. Raya panjang 11";
    personal.simExpiredDate = [NSDate date];
    personal.email = @"xxx@yyy.com";
    personal.telephone = @"0218012345678";
    personal.isCustomer = @(1);
    personal.dateOfBirth = [NSDate date];
    //formatting JSON
    Vehicle * vehicle = [Vehicle newVehicleInContext:context];
    vehicle.brand = @"Toyota";
    vehicle.chassisNumber = @"MHK111234TRO";
    vehicle.engineNumber = @"EEE124321NND";
    vehicle.policeNumber = @"B6431TRO";
    vehicle.stnkExpiredDate = [NSDate date];
    vehicle.type = @"Car";
    vehicle.year = @"2012";
    [personal addVehicleObject:vehicle];
        Insurance * insurance = [Insurance newInsuranceInContext:context];
    
    insurance.coverage = @"Everything everywhere anytime";
    insurance.name = @"Garda Oto";
    insurance.policyNumber =@"12432109344";
    insurance.policyPeriodFrom = [NSDate date];
        insurance.policyPeriodTo = [NSDate date];
    [personal addInsuranceObject:insurance];
    return [personal formatted];
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
