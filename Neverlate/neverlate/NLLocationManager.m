//
//  NLLocationManager.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/22/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>

#import "NLUser.h"
#import "NLGoal.h"
#import "NLLocationManager.h"
#import "NSDate+NLLocalTime.h"

@interface NLLocationManager() <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation NLLocationManager

// create a singleton of the NLLocationManager

+ (NLLocationManager *)sharedManager {
    static NLLocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    if (self == [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        return self;
    }
    return nil;
}

- (void)setGeofenceForGoal:(NLGoal *)goal {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:goal.location.latitude longitude:goal.location.longitude];
    CLCircularRegion *geofenceRegion = [[CLCircularRegion alloc]initWithCenter:location.coordinate radius:40.0 identifier:goal.objectId]; // radius is in meters

    [self.locationManager startMonitoringForRegion:geofenceRegion];
}

# pragma mark - CLLocationManagerDelegate didEnterRegion method

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"did start monitoring REGION %@", region);
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSArray <NLGoal*> *allGoals = [NLGoal goalsForCurrentUser];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertTitle = @"Neverlate";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.fireDate = [NSDate date];

    __weak typeof(self) weakSelf = self;
    for (NLGoal *goal in allGoals) {
        if ([goal.objectId isEqualToString:region.identifier] && [goal isWithinFourHours]) {
            if ([[NSDate date] timeIntervalSinceDate:goal.userDateToBeOnTime] < 0) {
                localNotification.alertBody = [NSString stringWithFormat:@"Looks like you are on time to %@. Great job being Neverlate! 👍 👏", goal.locationString];
            } else {
                localNotification.alertBody = [NSString stringWithFormat:@"You just paid %@ $%.0f cause you were late to %@ 💸 Next time - be Neverlate!", goal.buddyName, goal.moneyBetAmount/100, goal.locationString];
                goal.userWasLate = YES;
                [weakSelf makeTransaction];
                if (![NLUser currentUser].totalLatenessCost) {
                    [NLUser currentUser].totalLatenessCost = 0;
                }
                [NLUser currentUser].totalLatenessCost += goal.moneyBetAmount;
                [goal saveInBackground];
                [[NLUser currentUser] saveInBackground];
            }
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            // stop monitoring
            for (CLRegion *r in self.locationManager.monitoredRegions) {
                [self.locationManager stopMonitoringForRegion:r];
            }
        }
    }
}

- (void)makeTransaction {
    NSLog(@"%@", [NLUser currentUser].goal);
    [[Venmo sharedInstance] sendPaymentTo:[NLUser currentUser].goal.buddyPhoneNumber
                                   amount:[NLUser currentUser].goal.moneyBetAmount
                                     note:[NSString stringWithFormat:@"%@ was late, so here's $%.0f via Neverlate app!", [NLUser currentUser].name, [NLUser currentUser].goal.moneyBetAmount/100]
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            
                            if (success) {
                                NSLog(@"Transaction succeeded!");
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
    
}

@end
