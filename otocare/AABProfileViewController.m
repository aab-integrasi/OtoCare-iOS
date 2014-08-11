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

@interface AABProfileViewController ()

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
}
- (IBAction)chassisNumber:(id)sender {
}
- (IBAction)submitButton:(id)sender {
    
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
        NSLog(@"formatted : %@",[formatted description]);
        [self sendData:formatted];
    }
}

- (void)send {
    
}

- (void)sending {
    
}

- (void) sendData:(NSDictionary *)params
{
    
    AABHTTPClient *client = [AABHTTPClient sharedClient];
    [client postJSONWithPath:@"otocare/submit"
                  parameters:params
                     success:^(NSDictionary *jsonData, int statusCode){
                         [self showAlertWithTitle:@"Upload Success" message:nil];
                         NSLog(@"Upload Success");
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
