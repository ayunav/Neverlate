//
//  NLLocationManager.h
//  neverlate
//
//  Created by Ayuna Vogel on 11/22/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class NLGoal;

@interface NLLocationManager : NSObject

+ (NLLocationManager *)sharedManager;

- (void)setGeofenceForGoal:(NLGoal *)goal;

@end
