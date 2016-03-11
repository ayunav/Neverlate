//
//  NLGoal.h
//  neverlate
//
//  Created by Ayuna Vogel on 11/13/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

#import "PFObject.h"

@interface NLGoal : PFObject <PFSubclassing>

+ (NSArray <NLGoal *> *)goalsForCurrentUser;

- (BOOL)isWithinFourHours;

@property (nonatomic) NSString *buddyName;
@property (nonatomic) NSString *buddyPhoneNumber;
@property (nonatomic) float moneyBetAmount;
@property (nonatomic) NSString *locationString;
@property (nonatomic) NSDate *userDateToBeOnTime;


@property (nonatomic) BOOL userWasLate; 

// is not getting used currently in the code (these properties are intended for V2 as "two user mode")
@property (nonatomic) PFUser *buddy;
@property (nonatomic) PFGeoPoint *location;

@end
