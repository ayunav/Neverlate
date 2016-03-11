//
//  NLUser.h
//  neverlate
//
//  Created by Ayuna Vogel on 11/12/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <Parse/Parse.h>

#import "NLGoal.h"

@interface NLUser : PFUser <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NLGoal *goal;
@property (nonatomic, strong) NSMutableArray *goals;

@property (nonatomic) float totalLatenessCost;

- (void)fetchGoals:(void(^)(NSArray *))completion;

@end
