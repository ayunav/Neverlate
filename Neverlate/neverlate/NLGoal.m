//
//  NLGoal.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/13/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import "NLGoal.h"
#import "NLUser.h"

@implementation NLGoal

+ (NSString *)parseClassName {
    return @"Goal";
}

+ (NSArray <NLGoal *> *)goalsForCurrentUser {
    
    PFQuery *query = [self query];
    [query whereKey:@"user" equalTo:[NLUser currentUser]];
    return [query findObjects];
}

- (BOOL)isWithinFourHours {
    NSInteger timeFrame = 60 * 60 * 4;
    NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:self.userDateToBeOnTime];
    return fabs(timeDifference) <= timeFrame;
}

@dynamic buddyName;
@dynamic buddyPhoneNumber;
@dynamic moneyBetAmount;
@dynamic locationString;
@dynamic userDateToBeOnTime;

@dynamic  userWasLate; 

// is not getting used currently in the code (these properties are intended for V2 as "two user mode")
@dynamic buddy;
@dynamic location;




@end
