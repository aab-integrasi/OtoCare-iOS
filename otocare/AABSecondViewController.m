//
//  AABSecondViewController.m
//  otocare
//
//  Created by Benny Susilo on 8/4/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABSecondViewController.h"
#import "AABDBManager.h"
#import "Personal.h"
#import "AABProfileViewController.h"
#import "AABPersonalViewController.h"

@interface AABSecondViewController ()

@end

@implementation AABSecondViewController


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
        
        //case not then goto to New profile page
        //open new profile
        AABProfileViewController *profile = [self.storyboard instantiateViewControllerWithIdentifier:@"AABProfileViewController"];
        [self.navigationController presentViewController:profile animated:YES completion:nil];
        
    }else {
        //get data from database
        NSLog(@"Data Exist");
        //case already then go to Profile page
        //AABPersonalViewController
        AABPersonalViewController *profil = [self.storyboard instantiateViewControllerWithIdentifier:@"AABPersonalViewController"];
        [self.navigationController presentViewController:profil animated:YES completion:nil];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
