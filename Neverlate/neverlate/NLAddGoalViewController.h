//
//  NLAddGoalViewController.h
//  neverlate
//
//  Created by Eric Sze on 11/11/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NLAddGoalViewController : UIViewController
<
MKMapViewDelegate,
CLLocationManagerDelegate,
UISearchBarDelegate
>

@property (retain, nonatomic) NSString *timeString;
@property (nonatomic) CLLocationManager *locationManager;

@end
