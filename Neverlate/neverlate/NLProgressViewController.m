//
//  NLProgressViewController.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/26/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

#import "NLProgressViewController.h"
#import "AppDelegate.h"
#import "NLGoal.h"
#import "NLUser.h"
#import "NLMyGoalDataCustomTableViewCell.h"
#import "NLMapView.h"
#import "NLLogoutViewController.h"

@interface NLProgressViewController ()

@property (nonatomic) NLGoal *goal;
@property (nonatomic) NLUser *user;

@property (nonatomic) NSMutableArray *myGoalsData;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *myGoalsTableView;
@property (weak, nonatomic) IBOutlet UIView *totalCostViewContainer;
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;

@end

@implementation NLProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Progress";

//    self.totalCostViewContainer.layer.borderWidth = 2.5;
//    self.totalCostViewContainer.layer.borderColor = [[UIColor colorWithRed:216.0/255.0 green:30.0/255.0 blue:0.0/255.0 alpha:1.0] CGColor];
    
//    CALayer *topBorder = [CALayer layer];
//    topBorder.frame = CGRectMake(0.0f, 0.0f, self.totalCostViewContainer.frame.size.width, 2.5f);
//    topBorder.backgroundColor = [[UIColor colorWithRed:216.0/255.0 green:30.0/255.0 blue:0.0/255.0 alpha:1.0] CGColor];
//    [self.totalCostViewContainer.layer addSublayer:topBorder];
    
    self.totalCostLabel.layer.cornerRadius = 50;
    self.totalCostLabel.clipsToBounds = YES;
    
    [self requestNotificationsAuthorization];
    [self setupUI];
    [self updateTotalCostLabel];
    
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(pulledToRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.myGoalsTableView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchGoals];
}

- (void)pulledToRefresh:(UIRefreshControl *)sender {
    [self fetchGoals];
    [sender endRefreshing];
}

#pragma mark - requestNotificationsAuthorization method

- (void)requestNotificationsAuthorization {
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

#pragma mark - setup UI

- (void)setupUI {
    
    self.segmentedControl.layer.masksToBounds = YES;
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:216.0/255.0 green:30.0/255.0 blue:0.0/255.0 alpha:1.0]];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{
                                                              NSForegroundColorAttributeName : [UIColor redColor]
                                                              } forState:UIControlStateNormal];
    
    UINib *nib = [UINib nibWithNibName:@"NLMyGoalDataCustomTableViewCell" bundle:nil];
    [self.myGoalsTableView registerNib:nib forCellReuseIdentifier:@"MyGoalDataCellIdentifier"];
    
    self.myGoalsTableView.estimatedRowHeight = 44.0;
    self.myGoalsTableView.rowHeight = UITableViewAutomaticDimension;
}

- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    [self.myGoalsTableView reloadData];
}

- (void)fetchGoals {
    [[NLUser currentUser] fetchGoals:^(NSArray *goals) {
        self.myGoalsData = [[NSMutableArray alloc]initWithArray:goals];
        [self.myGoalsTableView reloadData];
    }];
}

#pragma mark - Update total cost of lateness label

- (void)updateTotalCostLabel {
    float totalCostAmountToDisplay = [NLUser currentUser].totalLatenessCost / 100;
    NSString *totalCostString = [NSString stringWithFormat:@"$%.0f", totalCostAmountToDisplay];
    self.totalCostLabel.text = totalCostString;
}

#pragma mark - Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return [self upcomingGoals].count;
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        return [self onTimeGoals].count;
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        return [self lateGoals].count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NLMyGoalDataCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoalDataCellIdentifier" forIndexPath:indexPath];
    
    NLGoal *goal;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        goal = [self upcomingGoals][indexPath.row];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        goal = [self onTimeGoals][indexPath.row];
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        goal = [self lateGoals][indexPath.row];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd 'at' h:mm a"];
    NSString *date = [dateFormatter stringFromDate:goal.userDateToBeOnTime];
    
    NSString *locationString = goal.locationString;
    NSString *buddyName = goal.buddyName;
    
    float moneyBetAmountValue = goal.moneyBetAmount;
    float moneyBetAmountToDisplay = moneyBetAmountValue/100;
    NSString *moneyBetAmountString = [NSString stringWithFormat:@"$%.0f", moneyBetAmountToDisplay];
    
    NSString *formattedText;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        formattedText = [NSString stringWithFormat:@"Pay %@ %@ if I'm late to %@! 💰", buddyName, moneyBetAmountString, locationString];
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        goal = [self onTimeGoals][indexPath.row];
        formattedText = [NSString stringWithFormat:@"Was on time to %@. Yay! 👍", locationString];
    } else if (self.segmentedControl.selectedSegmentIndex == 2) {
        goal = [self lateGoals][indexPath.row];
        formattedText = [NSString stringWithFormat:@"Paid %@ %@ cause I was late to %@ 💸", buddyName, moneyBetAmountString, locationString];
    }
    
    cell.dateAndTimeLabel.text = date;
    cell.myGoalStringLabel.text = formattedText;
    
    return cell;
}

# pragma mark - Goal filtering

- (NSArray *)upcomingGoals {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NLGoal *goal in self.myGoalsData) {
        if ([[NSDate date] timeIntervalSinceDate:goal.userDateToBeOnTime] < 0) {
            [arr addObject:goal];
        }
    }
    return arr;
}

- (NSArray *)onTimeGoals {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NLGoal *goal in self.myGoalsData) {
        if (goal.userWasLate == NO && [[NSDate date] timeIntervalSinceDate:goal.userDateToBeOnTime] > 0) {
            [arr addObject:goal];
        }
    }
    return arr;
}

- (NSArray *)lateGoals {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NLGoal *goal in self.myGoalsData) {
        if (goal.userWasLate == YES) {
            [arr  addObject:goal];
        }
    }
    return arr;
}

-(IBAction)settings:(id)sender {
    // set up UI for the back button for every VC pushed to the stack: red Neverlate color
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:221/255.0 green:24/255.0 blue:20/255.0 alpha:1.0];
    
    // instantiate VC
    NLLogoutViewController *logoutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogOutVCIdentifier"];
    [self.navigationController pushViewController:logoutVC animated:YES];
}

@end
