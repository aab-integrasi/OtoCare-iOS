//
//  AABVehicleDetailVC.m
//  otocare
//
//  Created by Asuransi Astra Buana on 8/14/14.
//  Copyright (c) 2014 PT. Asuransi Astra Buana. All rights reserved.
//

#import "AABVehicleDetailVC.h"

#import "AABTableHeaderView.h"
#import "AABFormCell.h"

#import "AABTableHeaderView.h"
#import "AABFormCell.h"
#import "AABDatePickerVC.h"
#import "Vehicle+Extended.h"
#import "AABDBManager.h"
#import "AABOptionChooserViewController.h"
#import "FPPopoverController.h"
#import "DemoTableController.h"
#import "FPPopoverController.h"

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

// keep track of which rows have date cells

#define kDateSTNKRow     6

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kCellAddress = @"cellAddress";     // the remaining cells at the end
static NSString *kCell = @"cell";     // the remaining cells at the end


@interface AABVehicleDetailVC () <UITableViewDataSource, UITableViewDelegate,UIPopoverControllerDelegate, AABOptionChooserDelegate,FPPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) FPPopoverController *popover;

@property (nonatomic, strong) UIBarButtonItem *backButton;
@property (nonatomic, strong) UIBarButtonItem *editSaveButton;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@end

@implementation AABVehicleDetailVC

- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL) validate {
    
    /*
     
     B 1972 SON
     Ford
     Fiesta
     2012
     MNBJXXRDJGBS58166
     N5JABS68176
     */
    NSLog(@"policeNumber : %@, brand : %@, type : %@, year : %@, chassisNumber : %@, engineNumber : %@ , stnkExpired : %@",self.vehicle.policeNumber,self.vehicle.brand,self.vehicle.type,self.vehicle.year,self.vehicle.chassisNumber,self.vehicle.engineNumber,self.vehicle.stnkExpiredDate);
    BOOL value = NO;
    
    if([self.vehicle.policeNumber isEqualToString:@""] || !self.vehicle.policeNumber) return value;
    if([self.vehicle.brand isEqualToString:@""] || !self.vehicle.brand) return value;
    if([self.vehicle.type isEqualToString:@""] || !self.vehicle.type) return value;
    if([self.vehicle.year isEqualToString:@""] || !self.vehicle.year) return value;
    if([self.vehicle.chassisNumber isEqualToString:@""] || !self.vehicle.chassisNumber) return value;
    if([self.vehicle.engineNumber isEqualToString:@""] || !self.vehicle.engineNumber) return value;
    if(!self.vehicle.stnkExpiredDate) return value;
    
    //    value = self.vehicle.policeNumber != Nil;
    //    value &= self.vehicle.policeNumber && self.vehicle.brand && self.vehicle.type && self.vehicle.year && self.vehicle.chassisNumber && self.vehicle.engineNumber && self.vehicle.stnkExpiredDate;
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // setup our data source
    NSMutableDictionary *policeNum = [@{ kTitleKey : @"Police number" } mutableCopy];
    NSMutableDictionary *viBrand = [@{ kTitleKey : @"Vehicle brand" } mutableCopy];
    NSMutableDictionary *viType = [@{ kTitleKey : @"Vehicle type" } mutableCopy];
    NSMutableDictionary *viYear = [@{ kTitleKey : @"Vehicle year" } mutableCopy];
    NSMutableDictionary *chassis = [@{ kTitleKey : @"Chassis number" } mutableCopy];
    NSMutableDictionary *engine = [@{ kTitleKey : @"Engine number" } mutableCopy];
    NSMutableDictionary *stnk = Nil;
    
    
    
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    //create new vehicle object
    if (!self.vehicle) {
        //        //create vehicle
        //        NSManagedObjectContext * context = [AABDBManager sharedManager].localDatabase.managedObjectContext;
        //
        //        //create new personal
        //        self.vehicle = [Vehicle newVehicleInContext:context];
        //check from database
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vehicle"];
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
            if (!self.vehicle) {
                //create new personal
                self.vehicle = [Vehicle newVehicleInContext:context];
            }
        }else {
            //get data from database
            self.vehicle = [result lastObject];
        }
        
    }else{
        stnk = [@{ kTitleKey : @"STNK expired date",
                   kDateKey : self.vehicle.stnkExpiredDate } mutableCopy];
    }
    
    if (!stnk) {
        stnk = [@{ kTitleKey : @"STNK expired date",
                   kDateKey : [NSDate date] } mutableCopy];
        
    }
    self.dataArray = @[policeNum,viBrand,viType,viYear,chassis,engine,stnk];


    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItems = @[self.backButton];
    
    
    self.editSaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(setButton)];
    
    self.navigationItem.rightBarButtonItems = @[self.editSaveButton];
}

- (void)setButton
{
    if ([self.editSaveButton.title isEqualToString:@"Edit"]) {
        self.tableView.allowsSelection = YES;
        //change title to Save
        self.editSaveButton.title = @"Save";
        
        //reload data
        if ([self isViewLoaded]) {
            [self.tableView reloadData];
        }
        
    }else {
        //change title to Select
        self.editSaveButton.title = @"Edit";
        self.tableView.allowsSelection = NO;
        
        
        
    }
}

-(void)edit{
    NSLog(@"Edit");
}

- (void)back{
    NSLog(@"Back");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}


#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}


#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateSTNKRow) || ([self hasInlineDatePicker] && (indexPath.row == kDateSTNKRow + 1)))
    {
        hasDate = YES;
    }
    
    return hasDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerIdentifier = @"vehicleHeader";
    
    AABTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!headerView) {
        headerView = [[AABTableHeaderView alloc] initWithTitle:@"" actionTitle:nil alignCenterY:YES reuseIdentifier:headerIdentifier];
//        headerView.labelTitle.font = [UIFont thinFontWithSize:28];
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        //        headerView.labelTitle.font = [UIFont thinFontWithSize:28];
        headerView.labelTitle.font = font;
        headerView.labelTitle.textAlignment = NSTextAlignmentLeft;
        headerView.labelTitle.textColor = [UIColor blackColor];
        headerView.backgroundView = [[UIView alloc] init];
        headerView.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    switch (section) {
        case 0:
            headerView.labelTitle.text = @"Vehicle";
            break;
        default:
            break;
    }
    
    return headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender {
    
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    
    if (targetedCellIndexPath.row == kDateSTNKRow) {
        //save date
        self.vehicle.stnkExpiredDate = targetedDatePicker.date;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows = self.dataArray.count;
        return ++numRows;
    }
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = kCell;
    
    if ([self indexPathHasPicker:indexPath])
    {
        UITableViewCell *cell = nil;
        // the indexPath is the one containing the inline date picker
        cellIdentifier = kDatePickerID;     // the current/opened date picker cell
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        return cell;
    }
    else if ([self indexPathHasDate:indexPath])
    {
        UITableViewCell *cell = nil;
        // the indexPath is one that contains the date information
        cellIdentifier = kDateCellID;       // the start/end date cells
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSInteger modelRow = indexPath.row;
        if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
        {
            modelRow--;
        }
        NSDictionary *itemData = self.dataArray[modelRow];
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
        
        return cell;
    }
    
    
    AABFormCell *cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            
            cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
            cell.labelTitle.text = @"Police number";
//            cell.textValue.placeholder = @"e.g B 1972 SON";
            cell.textValue.text = self.vehicle.policeNumber;
            cell.onTextValueReturn = ^(NSString *value){
                self.vehicle.policeNumber = value;
            };
            cell.characterSets = @[[NSCharacterSet alphanumericCharacterSet], [NSCharacterSet whitespaceCharacterSet], [NSCharacterSet uppercaseLetterCharacterSet]];
            cell.maxCharCount = 40;
        }else if (indexPath.row == 1) {
            cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeDetail reuseIdentifier:cellIdentifier];
            cell.labelTitle.text = @"Vehicle brand";
            cell.labelValue.text = self.vehicle.brand;
        }else if (indexPath.row == 2) {
            cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeDetail reuseIdentifier:cellIdentifier];
            cell.labelTitle.text = @"Vehicle type";
            cell.labelValue.text = self.vehicle.type;
        }else if (indexPath.row == 3) {
            cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeDetail reuseIdentifier:cellIdentifier];cell.labelTitle.text = @"Vehicle year";
            cell.labelValue.text = self.vehicle.year;
        }else if (indexPath.row == 4) {
            
            cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
            cell.labelTitle.text = @"Chassis number";
//            cell.textValue.placeholder = @"e.g MNBJXXRDJGBS58166";
            cell.textValue.text = self.vehicle.chassisNumber;
            cell.onTextValueReturn = ^(NSString *value){
                self.vehicle.chassisNumber = value;
            };
            cell.characterSets = @[[NSCharacterSet alphanumericCharacterSet], [NSCharacterSet whitespaceCharacterSet], [NSCharacterSet uppercaseLetterCharacterSet]];
            cell.maxCharCount = 20;
        }else if (indexPath.row == 5) {
            cell = [[AABFormCell alloc] initWithFormType:AABFormCellTypeTextInput reuseIdentifier:cellIdentifier];
            cell.labelTitle.text = @"Engine number";
//            cell.textValue.placeholder = @"e.g N5JABS68176";
            cell.textValue.text = self.vehicle.engineNumber;
            cell.onTextValueReturn = ^(NSString *value){
                self.vehicle.engineNumber = value;
            };
            cell.characterSets = @[[NSCharacterSet alphanumericCharacterSet], [NSCharacterSet whitespaceCharacterSet], [NSCharacterSet uppercaseLetterCharacterSet]];
            cell.maxCharCount = 20;
        }
    }
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
    {
        modelRow--;
    }
    
    NSDictionary *itemData = self.dataArray[modelRow];
    
    // proceed to configure our cell
    if ([cellIdentifier isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
    }
    else if ([cellIdentifier isEqualToString:kCell])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        //        cell.textLabel.text = [itemData valueForKey:kTitleKey];
    }else if ([cellIdentifier isEqualToString:kCellAddress])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        //        cell.textLabel.text = [itemData valueForKey:kTitleKey];
    }
    
    if ([self.editSaveButton.title isEqualToString:@"Edit"]) {
        cell.editingEnabled = NO;
    }else cell.editingEnabled = YES;
    
	return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.editSaveButton.title isEqualToString:@"Edit"]) {
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        if (EMBEDDED_DATE_PICKER)
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        else
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
    }
    else
    {
        //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                AABOptionChooserViewController *vc = [[AABOptionChooserViewController alloc] initWithConstantsKey:CONST_VEHICLE_BRAND delegate:self];
                vc.selectedValue = self.vehicle.brand;
                vc.title = @"Vehicle Brands";
                [self showPopoverFromRect:[self.tableView rectForRowAtIndexPath:indexPath] withViewController:vc navigationController:NO];
            }else if (indexPath.row == 2) {
                AABOptionChooserViewController *vc = [[AABOptionChooserViewController alloc] initWithConstantsKey:CONST_VEHICLE_TYPE delegate:self];
                vc.selectedValue = self.vehicle.type;
                vc.title = @"Vehicle Type";
                [self showPopoverFromRect:[self.tableView rectForRowAtIndexPath:indexPath] withViewController:vc navigationController:NO];
            }else if (indexPath.row == 3) {
                AABOptionChooserViewController *vc = [[AABOptionChooserViewController alloc] initWithConstantsKey:CONST_VEHICLE_YEAR delegate:self];
                vc.selectedValue = self.vehicle.year;
                vc.title = @"Vehicle Year";
                [self showPopoverFromRect:[self.tableView rectForRowAtIndexPath:indexPath] withViewController:vc navigationController:NO];
            }
        }
        
    }
}


/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    NSDictionary *itemData = self.dataArray[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kDateKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = CGRectGetHeight(self.view.frame);
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - CGRectGetHeight(endFrame);
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             //                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if ([identifier isEqualToString:@"ShowInsurance"]) {
        if (![self validate])  {
            //show alert that some data must be filled before next step
            //            NSString * message = @"Please fill ";
            NSString *message = [[NSString alloc] init];
            //            message = @"Please fill ";
            //            [message stringByAppendingString:@"Please fill "];
            
            //            message = [NSString stringWithFormat:@"%@",@"Please fill "];
            
            
            //            [message stringByAppendingString:@" value"];
            if([self.vehicle.policeNumber isEqualToString:@""] || !self.vehicle.policeNumber) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"Police number"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
            }
            if([self.vehicle.brand isEqualToString:@""] || !self.vehicle.brand) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"Brand"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
                
            }
            if([self.vehicle.type isEqualToString:@""] || !self.vehicle.type) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"Type"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
            }
            if([self.vehicle.year isEqualToString:@""] || !self.vehicle.year) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"Year"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
            }
            if([self.vehicle.chassisNumber isEqualToString:@""] || !self.vehicle.chassisNumber) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"Chassis Number"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
            }
            if([self.vehicle.engineNumber isEqualToString:@""] || !self.vehicle.engineNumber) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"Engine Number"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
            }
            if(!self.vehicle.stnkExpiredDate) {
                message = [NSString stringWithFormat:@"%@%@",@"Please fill ",@"STNK expired Date"];
                //show message
                [self showAlertWithTitle:@"Invalid input" message:message];
                
                NSLog(@"message : %@",message);
                message = Nil;
                return NO;
            }
            
            return NO;
        }
        
    }
    return YES;
    
}

- (void)setPersonal:(Personal *)personal
{
    if (personal) {
        _personal = personal;
        //check if there is current Vehicle data, case exist, then update.
        if ([self.personal.vehicle count]) {
            //case exist, then update value
            NSArray * data = [self.personal.vehicle allObjects];
            
            self.vehicle = [data lastObject];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowInsurance"]) {
        [[segue destinationViewController] setDelegate:self];
        //check if there is current Vehicle data, case exist, then update. Case not, then add
        if ([self.personal.vehicle count]) {
            NSError * error;
            //save database
            [self.personal.managedObjectContext save:&error];
            if (error) {
                NSLog(@"Error while saving to database : %@", [error description]);
            }
        }else {
            //case not exist
            //concatenate personal and vehicle
            [self.personal addVehicleObject:self.vehicle];
        }
        [[segue destinationViewController] setPersonal:self.personal];
    }
}
- (void)showOptionChooserWithConstantsKey:(NSString *)constantsKey indexPath:(NSIndexPath *)indexPath useNavigation:(BOOL)useNavigation
{
    AABOptionChooserViewController *vc = [[AABOptionChooserViewController alloc] initWithConstantsKey:constantsKey delegate:self];
    vc.view.tintColor = [UIColor IMMagenta];
    [self showPopoverFromRect:[self.tableView rectForRowAtIndexPath:indexPath] withViewController:vc navigationController:useNavigation];
}

- (void)optionChooser:(AABOptionChooserViewController *)optionChooser didSelectOptionAtIndex:(NSUInteger)selectedIndex withValue:(id)value
{
    
    NSLog(@"value : %@",value);
    if (optionChooser.constantsKey == CONST_VEHICLE_BRAND) {
        self.vehicle.brand = value;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (optionChooser.constantsKey == CONST_VEHICLE_TYPE) {
        self.vehicle.type = value;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (optionChooser.constantsKey == CONST_VEHICLE_YEAR) {
        self.vehicle.year = value;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (void)showPopoverFromRect:(CGRect)rect withViewController:(UIViewController *)vc navigationController:(BOOL)useNavigation
{
    
    rect = CGRectMake(rect.size.width - 150, rect.origin.y, rect.size.width, rect.size.height);
    //    vc.view.tintColor = [UIColor IMMagenta];
    //    vc.modalInPopover = NO;
    
    if (useNavigation) {
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        navCon.navigationBar.tintColor = [UIColor IMMagenta];
        self.popover = [[FPPopoverController alloc] initWithViewController:navCon];
    }else {
        vc.view.tintColor = [UIColor IMMagenta];
        self.popover = [[FPPopoverController alloc] initWithViewController:vc];
    }
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    self.popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.popover.contentSize = CGSizeMake(300, 500);
    }
    self.popover.arrowDirection = FPPopoverArrowDirectionRight;
    
    //    self.popover.delegate = self;
    //    [self.popover presentPopoverFromRect:rect inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //    self.popover.contentSize = CGSizeMake(150,200);
    [self.popover presentPopoverFromView:self.tableView];
    //    [self.popover presentPopoverFromPoint:rect.origin];
}

-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    DemoTableController *controller = [[DemoTableController alloc] initWithStyle:UITableViewStylePlain];
    controller.delegate = self;
    //    controller.title = @"Vehicle Brands";
    controller.data = [AABConstants constantsForKey:CONST_VEHICLE_BRAND];
    //    NSArray * tmp =[AABConstants constantsForKey:CONST_VEHICLE_BRAND];
    //
    //    NSLog(@"brands : %@",[tmp description]);
    //    AABOptionChooserViewController *controller = [[AABOptionChooserViewController alloc] initWithConstantsKey:CONST_VEHICLE_BRAND delegate:self];
    //    controller.selectedValue = self.vehicle.brand;
    controller.title =@"Vehicle Brands";
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(300, 500);
    }
    popover.arrowDirection = FPPopoverArrowDirectionRight;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];
    
}



- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.popover = nil;
}

@end
