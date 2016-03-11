//
//  NLUser.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/12/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

#import "NLUser.h"

@implementation NLUser

@dynamic name; 
@dynamic goal;
@dynamic goals;

@dynamic totalLatenessCost;

- (void)fetchGoals:(void(^)(NSArray *))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"user" equalTo:[NLUser currentUser]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userDateToBeOnTime" ascending:NO
                                        ];
    [query orderBySortDescriptor:sortDescriptor];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completion(objects);
    }];
}

@end
