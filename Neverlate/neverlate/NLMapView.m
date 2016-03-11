//
//  NLMapViewController.m
//  neverlate
//
//  Created by Charles Kang on 11/16/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>
#import <DXPopover/DXPopover.h>

#import "NLMapView.h"
#import "NLUser.h"
#import "NLGoal.h"
#import "NSDate+NLLocalTime.h"

static NSString *NLUserSavedSearchKey = @"NLSavedSearchesKey";

@interface NLMapView()

@property (weak, nonatomic) IBOutlet UIView *buttonViewContainer;

//@property (nonatomic) DXPopover *popover;

@end

@implementation NLMapView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([self hasPreviouslySavedLocation]) {
//        [self showPreviouslySavedLocation];
//        [self dropPinAtPreviouslySavedLocation];
        self.hasUserLocation = YES;
    }
    
    // set delegates
    self.locationManager.delegate = self;
    self.searchTextField.delegate = self;
    self.mapView.delegate = self;
    
    // call these necessary methods for everything to work!
//    [self hasPreviouslySavedLocation];
//    [self showPreviouslySavedLocation];
//    [self dropPinAtPreviouslySavedLocation];
    [self.locationManager startUpdatingLocation];
    
    [self setCurrentLocation];
    [self regionForSavedLocation];
//    [self updateGeoUI];
    
    // set hasUserLocation to false
    self.hasUserLocation = false;
    self.mapView.showsUserLocation = TRUE;
    
    // creates a geofence/overlay
    CLLocationDegrees lat = [[self.geofence valueForKey:@"NeverLateGoalLocations"] doubleValue];
    CLLocationDegrees lon = [[self.geofence valueForKey:@"NeverLateGoalLocations"] doubleValue];
    CLLocationDistance radius = [[self.geofence valueForKey:@"radius"] doubleValue];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(lat, lon);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, radius, radius);
    [self.mapView setRegion:region];
    [self setUpMapViewAndPin:self.location];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPress];
    
    [self performSelector:@selector(openCallout:) withObject:self.mapView.userLocation afterDelay:1.0];
    
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeYes;
    
    NSArray *savedSearches = [self savedSearches];
    if (savedSearches != nil) {
        NSLog(@"*******SAVED SEARCHES*******");
        for (NSString *search in savedSearches) {
            NSLog(@"%@", search);
        }
    }
}

- (IBAction)setButtonTapped:(UIButton *)sender {
    self.cancelButtonHandler();
}

- (BOOL) hasPreviouslySavedLocation {
    // kinda hacky
    MKCoordinateRegion region = [self regionForSavedLocation];
    return !(region.center.latitude == 0 && region.center.longitude == 0 && region.span.longitudeDelta == 0 && region.span.latitudeDelta == 0);
}

- (void) showPreviouslySavedLocation {
    MKCoordinateRegion region = [self regionForSavedLocation];
    [self.mapView setRegion:region animated:NO];
}

- (void) dropPinAtPreviouslySavedLocation {
    MKCoordinateRegion region = [self regionForSavedLocation];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = region.center;
    
    if (annotation) {
    }
    [self.mapView addAnnotation:annotation];
}

- (void) setCurrentLocation {
    
    if (self.locationManager == nil){
        self.locationManager = [[CLLocationManager alloc]init];
    }
    self.locationManager.delegate = self;
    
    //mandatory check http://stackoverflow.com/questions/24062509/location-services-not-working-in-ios-8
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.005, 0.005);
    
    // set zoom to user's location
    self.location = self.locationManager.location;
    
    if (!self.hasUserLocation) {
        self.hasUserLocation = YES;
        [self.mapView setRegion:mapRegion animated:YES];
        // add the annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = userLocation.coordinate;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    return circleView;
}

- (void)performSearch {
    
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchTextField.text;
    request.region = _mapView.region;
    
    self.matchingSearchItems = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search =
    [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"No Matches");
        } else {
            MKMapItem *item = response.mapItems[0];
            [self.mapView setRegion:MKCoordinateRegionMake(item.placemark.coordinate, MKCoordinateSpanMake(0.005, 0.005))];
            for (MKMapItem *item in response.mapItems)
            {
                [self.matchingSearchItems addObject:item];
                MKPointAnnotation *annotation =
                [[MKPointAnnotation alloc]init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                [_mapView addAnnotation:annotation];
            }
        }
    }];
}

- (MKCoordinateRegion)regionForSavedLocation {
    MKCoordinateRegion myRegion;
    myRegion.center.latitude  = [[NSUserDefaults standardUserDefaults] doubleForKey:@"map.location.center.latitude"];
    myRegion.center.longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"map.location.center.longitude"];
    myRegion.span.latitudeDelta  = [[NSUserDefaults standardUserDefaults] doubleForKey:@"map.location.span.latitude"];
    myRegion.span.longitudeDelta = [[NSUserDefaults standardUserDefaults] doubleForKey:@"map.location.span.longitude"];
    return myRegion;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self performSearch];
    [self setCurrentLocation];
    [self savedSearches];
    
    MKLocalSearchRequest *request =
    [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Places";
    request.region = _mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [self saveSearch:searchBar.text];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"No Matches");
            NSLog(@"User's Destination: %@ ", self.searchTextField.text);
        }
    }];
}

// nsuserdefaults code

- (void)saveSearch:(NSString *)text {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr;
    if ([defaults valueForKey:NLUserSavedSearchKey]) {
        arr = [[defaults objectForKey:NLUserSavedSearchKey] mutableCopy];
    } else {
        arr = [[NSMutableArray alloc] init];
    }
    
    [arr addObject:text];
    [defaults setObject:arr forKey:NLUserSavedSearchKey];
    [defaults synchronize];
}

- (NSArray *) savedSearches {
    return [[NSUserDefaults standardUserDefaults] objectForKey:NLUserSavedSearchKey];
}

- (MKAnnotationView *)annotationView {
    
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"MyCustomAnimation"];
    
    annotationView.enabled = YES;
    
    return annotationView;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] init];
    
    pin.canShowCallout = YES;
    pin.animatesDrop = YES;
    pin.draggable = YES;
    
    pin.rightCalloutAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    pin.rightCalloutAccessoryView = addButton;
    NSLog(@"Add Button Pressed");

        return pin;
    }


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            MKAnnotationView *annotationView = aV;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
        }
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annotation =
    [[MKPointAnnotation alloc]init];
    annotation.coordinate = touchMapCoordinate;
    annotation.title = @"Destination";
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark - create geofence when save location plus button tapped

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    // remove all existing geofences
    for (CLRegion *region in self.locationManager.monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
    
    // saves the pin location and zooms the map to that pin, when a user opens the app again
    CLLocationCoordinate2D location = view.annotation.coordinate;
    [[NSUserDefaults standardUserDefaults] setDouble:location.latitude forKey:@"map.location.center.latitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:location.longitude forKey:@"map.location.center.longitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:0.05 forKey:@"map.location.span.latitude"];
    [[NSUserDefaults standardUserDefaults] setDouble:0.05 forKey:@"map.location.span.longitude"];
    
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location radius:40.0 identifier:@"regionIdentifier"];
    
    //    NSLog(@"%f, %f", region.center.latitude, region.center.longitude);
    
    // create new geofence
    [self.locationManager startMonitoringForRegion:region];
    
    MKCoordinateRegion myRegion = [self regionForSavedLocation];
    
    NSLog(@"%@", [NSString stringWithFormat:@"Region read  : %f %f %f %f", myRegion.center.latitude, myRegion.center.longitude, myRegion.span.latitudeDelta, myRegion.span.longitudeDelta]);
    
    
    NSLog(@"%@", [NSString stringWithFormat:@"Region on map: %f %f %f %f", self.mapView.region.center.latitude, self.mapView.region.center.longitude, self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta]);
    NSLog(@"%@", self.locationManager);
    
    
    
    // Update UI for new geofence
    [self updateGeoUI];
    
    CLLocation *selectedLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [self.delegate mapView:self didSelectLocation:selectedLocation withTitle:((MKPointAnnotation *)view.annotation).title];
}

#pragma mark - setup geofence circle (UI) around the selected location

- (void)updateGeoUI {
    
    [self.mapView removeOverlay:self.overlay];
    for (CLCircularRegion *region in self.locationManager.monitoredRegions) {
        self.overlay = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
        [self.mapView addOverlay:self.overlay];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.locationManager stopUpdatingLocation];
    [self setUpMapViewAndPin:newLocation];
    
}

- (void)setUpMapViewAndPin:(CLLocation *)location {
    
    CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    //zoom in
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:location2D fromEyeCoordinate:location2D eyeAltitude:10000];
    [self.mapView setCamera:camera animated:NO];
}

- (void)openCallout:(id<MKAnnotation>)annotation {
    [self.mapView selectAnnotation:annotation animated:NO];
}

-(void)dismissKeyboard {
    [self.searchTextField resignFirstResponder];
}

@end