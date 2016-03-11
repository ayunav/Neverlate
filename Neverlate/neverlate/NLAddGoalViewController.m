//
//  NLAddGoalViewController.m
//  neverlate
//
//  Created by Eric Sze on 11/11/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <DXPopover/DXPopover.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <Venmo-iOS-SDK/Venmo.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import <Webkit/Webkit.h>

#import "NLTimeAndDatePickerView.h"
#import "NLMapView.h"
#import "NLAddGoalViewController.h"
#import "NLUser.h"
#import "NLGoal.h"
#import "NLMapManager.h"
#import "NSDate+NLLocalTime.h"
#import "NLLocationManager.h"
#import "NLLoginViewController.h"
#import "NLSignupViewController.h"
#import "NLProgressViewController.h"


@interface NLAddGoalViewController ()
<
CNContactPickerDelegate,
UITextFieldDelegate,
NLMapViewDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *buddyNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *locationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *buddyButton;
@property (weak, nonatomic) IBOutlet UIButton *moneyAmountButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *timeAndDatePickerButton;

@property (nonatomic, strong) NLGoal *goal;

@property (nonatomic) NLMapView *popOutMapView;

@property (nonatomic) MKPlacemark *placemark;
@property (weak, nonatomic) IBOutlet UIButton *redNLButton;

@end



@implementation NLAddGoalViewController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.navigationController.navigationBar.topItem setTitleView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setGoal"]]];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    NLUser *currentUser = [NLUser currentUser];
    self.goal = [NLGoal object];
    
    self.redNLButton.layer.cornerRadius = 26;
    
    self.moneyAmountTextField.delegate = self;
    [self numberToolBarForNumberPad];
    [self.moneyAmountTextField addTarget:self action:@selector(animateTextField:up:) forControlEvents:UIControlEventEditingDidBegin];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([Venmo sharedInstance].isSessionValid) {
        NSLog(@"VENMO SESSION IS VALID");
        self.moneyAmountButton.hidden = YES;
        self.moneyAmountTextField.enabled = YES;
    }
    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    
    if (UIScreen.mainScreen.bounds.size.height == 568) {
        // IPhone 5
        //label.font = label.font.fontWithSize(20)
    }
    
}

#pragma mark - timeAndDatePickerButtonTapped

- (IBAction)timeAndDatePickerButtonTapped:(UIButton *)sender {
    
    NLTimeAndDatePickerView *timeAndDateView = [[[NSBundle mainBundle] loadNibNamed:@"NLTimeAndDatePickerView" owner:nil options:nil] firstObject];
    CGRect newFrame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y, self.view.frame.size.width / 1.1, self.view.frame.size.height / 1.305);
    timeAndDateView.frame = newFrame;
    
    DXPopover *popover = [DXPopover popover];
    //    [popover showAtPoint:CGPointMake((self.view.frame.size.width / 2), sender.frame.origin.y - 100)
    [popover showAtPoint:CGPointMake((self.view.frame.size.width / 2), 80)
          popoverPostion:DXPopoverPositionDown
         withContentView:timeAndDateView
                  inView:self.view];
    
    timeAndDateView.frame = popover.frame;
    
    // Set the date and time and push it to parse AFTER popover is dismissed
    
    NSTimeInterval timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT]);
    NSDate *converted = [NSDate dateWithTimeIntervalSinceNow:timezoneoffset];
    
    [timeAndDateView.calendar selectDate:converted];
    
//    timeAndDateView.dismissButtonHandler = ^ {
//        [popover dismiss];
//    };
    
    timeAndDateView.cancelButtonHandler = ^{
        [popover dismiss];
    };
    
    __weak typeof(self) weakSelf = self;
    timeAndDateView.setButtonHandler = ^(NSDate *calendarDate, NSDate *datePickerDate) {
        [popover dismiss];
        
        // http://stackoverflow.com/questions/5646539/iphonefind-the-current-timezone-offset-in-hours
        NSTimeInterval timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT]);
        NSDate *converted = [NSDate dateWithTimeInterval:fabs(timezoneoffset) sinceDate:calendarDate];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay ) fromDate:converted];
        
        NSDateComponents *timeComponents = [calendar components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:datePickerDate];
        
        [dateComponents setHour:[timeComponents hour]];
        [dateComponents setMinute:[timeComponents minute]];
        [dateComponents setSecond:0.0];
        
        NSDate *newDate = [calendar dateFromComponents:dateComponents];
        
        weakSelf.goal.userDateToBeOnTime = newDate;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        //        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
        
        self.dateLabel.text = [dateFormatter stringFromDate:self.goal.userDateToBeOnTime];
        //        NSLog(@"goal.userDateToBeOnTime is %@", stringFromDate);
        
        
        //        if (self.goal.userDateToBeOnTime == emptyDate) {
        //            self.goal.userDateToBeOnTime = timeAndDateView.calendar.today;
        //        } else {
        //        self.dateLabel.text = [dateFormatter stringFromDate:self.goal.userDateToBeOnTime];
        //        }
        
        
        
        //        if (self.dateLabel.text == nil) {
        //            self.goal.userDateToBeOnTime = timeAndDateView.calendar.today;
        //        } else {
        //            self.dateLabel.text = [dateFormatter stringFromDate:self.goal.userDateToBeOnTime];
        //        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy h:mm a"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        
        NSString *stringFromDate = [formatter stringFromDate:self.goal.userDateToBeOnTime];
        
        self.dateLabel.text = [dateFormatter stringFromDate:self.goal.userDateToBeOnTime];
        NSLog(@"goal.userDateToBeOnTime is %@", stringFromDate);
        
    };
}

#pragma mark - locationButtonTapped method

- (IBAction)locationButtonTapped:(UIButton *)sender {
    
    [self requestLocationPermission];
    
    NLMapView *mapView = [[[NSBundle mainBundle] loadNibNamed:@"NLMapView" owner:nil options:nil] firstObject];
    mapView.delegate = self;
    
    CGRect newFrame = CGRectMake(self.timeAndDatePickerButton.frame.origin.x, self.timeAndDatePickerButton.frame.origin.y, self.view.frame.size.width / 1.1, self.view.frame.size.height / 1.93);
    mapView.frame = newFrame;
    
    DXPopover *popover = [DXPopover popover];
    //    [popover showAtPoint:CGPointMake((self.view.frame.size.width / 2), self.timeAndDatePickerButton.frame.origin.y - 100)
    [popover showAtPoint:CGPointMake((self.view.frame.size.width / 2), 80)
          popoverPostion:DXPopoverPositionDown
         withContentView:mapView
                  inView:self.view];
    
    mapView.cancelButtonHandler = ^ {
        [popover dismiss];
    };
    
    mapView.frame = popover.frame;
    
    BOOL up;
    
    const int movementDistance = -150; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    popover.frame = CGRectOffset(popover.frame, 0, movement);
    
    [UIView commitAnimations];
    
}

- (void)requestLocationPermission {
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

#pragma mark NLMapView Delegate

- (void)mapView:(NLMapView *)mapView didSelectLocation:(CLLocation *)location withTitle:(NSString *)title {
    self.goal.location = [PFGeoPoint geoPointWithLocation:location];
    
    if ([[title lowercaseString] isEqualToString:@"current location"] || [[title lowercaseString] isEqualToString:@"destination"]) {
        __weak typeof(self) weakSelf = self;
        [self reverseGeocodeCoordinates:location completion:^(CLPlacemark *placemark) {
            NSString *name = placemark.name;
            NSString *streetNumber = placemark.subThoroughfare;
            NSString *street = placemark.thoroughfare;
            NSString *locationStringToDisplayInProgressTableView = [NSString stringWithFormat:@"%@ %@", streetNumber, street];
            self.goal.locationString = name;
            self.locationAddressLabel.text = name;
        }];
    } else {
        self.goal.locationString = title; //locationStringToDisplayInProgressTableView;
        self.locationAddressLabel.text = title; //locationStringToDisplayInProgressTableView;
    }
}

- (void)reverseGeocodeCoordinates:(CLLocation *)location completion:(void(^)(CLPlacemark *placemark))completion {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        completion(placemarks[0]);
    }];
}

#pragma mark - selectBuddyFromContactsButtonTapped

- (IBAction)selectBuddyFromContactsButtonTapped:(UIButton *)sender {
    
    CNContactPickerViewController *contactViewController = [[CNContactPickerViewController alloc] init];
    contactViewController.delegate = self;
    [self presentViewController:contactViewController animated:YES completion:nil];
    
    // check permissions
    NSLog(@"%ld", (long)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]);
    
    // grant access to contacts
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSLog(@"%d", granted);
    }];
    
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    NSString *name = contact.givenName;
    self.goal.buddyName = name;
    self.buddyNameLabel.text = name;
    
    NSString *phoneNumber = ((CNPhoneNumber *)contact.phoneNumbers[0].value).stringValue;
    self.goal.buddyPhoneNumber = phoneNumber;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - moneyAmountButtonTapped

- (IBAction)moneyAmountButtonTapped:(UIButton *)sender {
    
    if (![Venmo sharedInstance].isSessionValid) {
       [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                     VENPermissionAccessProfile]
                               fromViewController:self
                            withCompletionHandler:^(BOOL success, NSError *error) {
                                 if (success) {
                                     NSLog(@"venmo authorization request was successful & permissions were granted");
                                     self.moneyAmountButton.hidden = YES;
                                     self.moneyAmountTextField.enabled = YES;
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }
                             }];
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    }
    
}

#pragma mark - submitButtonTapped

- (IBAction)beNeverlateButtonTapped:(UIButton *)sender {
    
    NSString *buddyName = self.buddyNameLabel.text;
    NSString *moneyAmount = [self.moneyAmountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *locationToBeOnTimeAt = self.locationAddressLabel.text;
    NSString *dateToBeOnTime = self.dateLabel.text;
    
    if (self.moneyAmountTextField.text.floatValue >= 101) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry, Big Shot!"
                                                                                 message:@"$100 max 💵"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([buddyName length] == 0 || [moneyAmount length] == 0 || self.moneyAmountTextField.text.floatValue <= 0 || [locationToBeOnTimeAt length] == 0 || [dateToBeOnTime length] == 0) {
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"Looks like you forgot to fill something out. When you are ready, press the button to be Neverlate!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *formattedText = [NSString stringWithFormat:@"Pay %@ $%@ if I'm late to %@ on %@! 💰", buddyName, moneyAmount, locationToBeOnTimeAt, dateToBeOnTime];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Is this right?"
                                                                                 message:formattedText
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [NLUser currentUser].goal = self.goal;
            
            float amount = self.moneyAmountTextField.text.floatValue * 100; // this is in cents (Venmo standards)
            self.goal.moneyBetAmount = amount;
            [self.goal setObject:[NLUser currentUser] forKey:@"user"];
            
            if ([NLUser currentUser].goals == nil) {
                [NLUser currentUser].goals = [[NSMutableArray alloc] init];
            }
            [[NLUser currentUser].goals addObject:self.goal];
            [self saveGoal];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"UserHasGoal"];
            [defaults synchronize];
        }];
        
        [alertController addAction:cancel];
        [alertController addAction:confirm];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)saveGoal {
    [[NLUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[NLLocationManager sharedManager] setGeofenceForGoal:self.goal];
        [self.tabBarController setSelectedIndex:1];
    }];
    self.buddyNameLabel.text = @"";
    self.moneyAmountTextField.text = @"";
    self.locationAddressLabel.text = @"";
    self.dateLabel.text = @"";
}

#pragma mark - Number pad methods

- (void)numberToolBarForNumberPad {
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.moneyAmountTextField.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [self.moneyAmountTextField resignFirstResponder];
    self.moneyAmountTextField.text = @"";
    [self animateTextField:self.moneyAmountTextField up:YES];
}

-(void)doneWithNumberPad{
    self.goal.moneyBetAmount = [self.moneyAmountTextField.text floatValue];
    [self.moneyAmountTextField resignFirstResponder];
    [self animateTextField:self.moneyAmountTextField up:YES];
}

- (void)animateTextField: (UITextField *)textField up: (BOOL) up
{
    //    const int movementDistance = -170; // tweak as needed
    //    const float movementDuration = 0.3f; // tweak as needed
    
    const int movementDistance = 0; // tweak as needed
    const float movementDuration = 0.0f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
