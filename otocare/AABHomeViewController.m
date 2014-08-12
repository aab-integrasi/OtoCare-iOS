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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
