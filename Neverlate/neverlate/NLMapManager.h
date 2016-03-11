//
//  NLMapManager.h
//  neverlate
//
//  Created by Charles Kang on 11/16/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NLMapManager : NSObject
<MKMapViewDelegate,
CLLocationManagerDelegate,
UISearchBarDelegate
>

@property (nonatomic) MKMapView *mapView;

@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) NSMutableArray *matchingSearchItems;
@property (nonatomic) BOOL hasUserLocation;

// geofence code
@property (nonatomic) id geofence;
@property (nonatomic) MKCircle *overlay;
@property (nonatomic) NSMutableSet *insideGeofenceIds;

@end

// THIS IS WHAT SHOULD HAPPEN WHEN THE USER USES THE MAP/GEOFENCING PORTION OF OUR APP
// 1) user searches for their work location, location pin shows on map
// 2) user presses the save or + button and the location and pin are saved to nsuserdefaults