//
//  NSDate+NLLocalTime.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/21/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import "NSDate+NLLocalTime.h"

@implementation NSDate (NLLocalTime)

- (NSDate *)dateForLocalTimeZone {
    NSTimeInterval timezoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    return [self dateByAddingTimeInterval:timezoneOffset];
}

@end
