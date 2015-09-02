//
//  ViewController.m
//  LocationReminders
//
//  Created by Sarah Hermanns on 8/31/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderDetailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = true;
  
  NSLog(@"%d",[CLLocationManager authorizationStatus]);
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  [self.locationManager requestWhenInUseAuthorization];
  
  [self.locationManager startUpdatingLocation];
  
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
  [self.mapView addGestureRecognizer:longPressGesture];
  
  
}



-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 100, 100) animated:true];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateEnded) {
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locationCoordidate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *addDropPin = [[MKPointAnnotation alloc] init];
    addDropPin.coordinate = locationCoordidate;
    addDropPin.title = @"Dummy";
    [self.mapView addAnnotation:addDropPin];
  } else {


  }
}


- (IBAction)buttonOne:(id)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.633567, -122.346287), 1000, 1000)];
}

- (IBAction)buttonTwo:(id)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.630681, -122.348639), 1000, 1000)];
}

- (IBAction)buttonThree:(id)sender {
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.638050, -122.357182), 1000, 1000)];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  switch (status) {
    case kCLAuthorizationStatusAuthorizedWhenInUse:
      [self.locationManager startUpdatingLocation];
      break;
      
    default:
      break;
  }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  
  CLLocation *location = locations.lastObject;
  NSLog(@"lat:%f, long:%f", location.coordinate.latitude, location.coordinate.longitude);
}

#pragma mark - CLLocationManagerDelegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
  pinView.annotation = annotation;
  
  if (!pinView) {
    pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
  }
  pinView.animatesDrop = true;
  pinView.pinColor = MKPinAnnotationColorGreen;
  [pinView setCanShowCallout: YES];
  pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  
  return pinView;
}

#pragma mark - CalloutAccessoryIdentifier
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
   [self performSegueWithIdentifier:@"ShowAddReminderVC" sender:view];
  
}

#pragma mark - Prepare for Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender {
    if ([segue.identifier isEqualToString:@"ShowAddReminderVC"]) {
      AddReminderDetailViewController *destinationViewController = segue.destinationViewController;
      destinationViewController.annotationCoordinates = sender.annotation.coordinate;
    
    } else {
      NSLog(@"error");
    }
}


@end
