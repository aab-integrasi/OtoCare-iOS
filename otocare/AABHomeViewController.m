//
//  AABHomeViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/5/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABHomeViewController.h"
#import "AABDBManager.h"
#import "Personal.h"
#import "Insurance.h"
#import "Vehicle.h"
#import "NSDate+Relativity.h"

@interface AABHomeViewController ()


@end

@implementation AABHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)reminderGesture:(id)sender {
    NSLog(@"reminderGesture");
}
- (IBAction)insuranceGesture:(id)sender {
        NSLog(@"insuranceGesture");
    if (!self.insuranceNotification.hidden) {
        self.insuranceNotification.hidden = YES;
    }
}

- (IBAction)serviceGesture:(id)sender {
          NSLog(@"serviceGesture");
}
- (IBAction)simGesture:(id)sender {
          NSLog(@"simGesture");
    if (!self.simNotification.hidden) {
        self.simNotification.hidden = YES;
    }
}

- (IBAction)fuelGesture:(id)sender {
      NSLog(@"fuelGesture");
}

- (IBAction)serviceBigGesture:(id)sender {
      NSLog(@"serviceBigGesture");
    if (!self.serviceNotification.hidden) {
        self.serviceNotification.hidden = YES;
    }
}

- (IBAction)reportGesture:(id)sender {
      NSLog(@"reportGesture");
}

- (IBAction)callGesture:(id)sender {
      NSLog(@"callGesture");
}

- (IBAction)reportClaimGesture:(id)sender {
      NSLog(@"reportClaimGesture");
}

- (IBAction)stnkGesture:(id)sender {
      NSLog(@"stnkGesture");
    if (!self.stnkNotification.hidden) {
        self.stnkNotification.hidden = YES;
    }
}

- (IBAction)valueTagGesture:(id)sender {
    NSLog(@"valueTagGesture");
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //reload data
    if (!self.personal) {
        [self checkDatabase];
    }
    
}
- (void)checkDatabase
{
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
    
    if ([result count]) {
        //get data from database
        self.personal = [result lastObject];
        
        self.simLabel.text = [self.personal.simExpiredDate mediumFormatted];
        
        //get vehicle and insurance
        for (Insurance * insurance in self.personal.insurance) {
            //todo : need more algorithm
            self.InsuranceDate.text =[insurance.policyPeriodTo mediumFormatted];
        }
        
        for (Vehicle * vehicle in self.personal.vehicle) {
            self.stnkLabel.text = [vehicle.stnkExpiredDate mediumFormatted];
        }
    
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    //test
    self.simNotification.hidden = self.stnkNotification.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
