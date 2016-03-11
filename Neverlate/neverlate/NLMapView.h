//
//  NLMapViewController.h
//  neverlate
//
//  Created by Charles Kang on 11/16/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol NLMapViewDelegate;

@interface NLMapView : UIView
<MKMapViewDelegate,
CLLocationManagerDelegate,
UISearchBarDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, weak) id<NLMapViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic) NSMutableArray *matchingSearchItems;
@property (nonatomic) BOOL hasUserLocation;

@property (nonatomic, strong) void (^cancelButtonHandler)();

@property(nonatomic)IBOutlet UIView *view;


// property to save recent searches 12/5
@property (nonatomic) NSArray *recentSearches;

@property (nonatomic) MKMapItem *item;

// geofence code
@property (nonatomic) id geofence;
@property (nonatomic) MKCircle *overlay;
@property (nonatomic) NSMutableSet *insideGeofenceIds;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@property (nonatomic) NSMutableArray *allGoals;

@property (nonatomic) CLGeocoder *geocode;

@end



@protocol NLMapViewDelegate <NSObject>

- (void)mapView:(NLMapView *)mapView didSelectLocation:(CLLocation *)location
      withTitle:(NSString *)title;

@optional
- (void)didBeginMonitoringForRegion:(CLCircularRegion *)region;

@end