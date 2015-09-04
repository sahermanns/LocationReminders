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
#import <Parse/Parse.h>
#import "Reminder.h"
#import "constants.h"
#import <ParseUI/ParseUI.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
  [super viewDidLoad];

  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderNotification:) name:kReminderNotification object:nil];
  
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



-(void)reminderNotification:(NSNotification *)notification {
  NSLog(@"notification fired!");
  NSDictionary *userInfo = notification.userInfo;
  if (userInfo) {
    
    Reminder *reminder = userInfo[@"NewReminder"];
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
      
      CLLocationCoordinate2D location = CLLocationCoordinate2DMake(reminder.coordinate.latitude, reminder.coordinate.longitude);
      
      CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:location radius:200 identifier:reminder.locationName];
      
      [self.locationManager startMonitoringForRegion:region];
      
      
      MKCircle *circle = [MKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(reminder.coordinate.latitude, reminder.coordinate.longitude) radius:200];
      
      [self.mapView addOverlay:circle];
      
//      NSArray *regions = [[self.locationManager monitoredRegions] allObjects];
      
    }
    
  }
  
}



-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (![PFUser currentUser]) {

  PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
  logInController.delegate = self;
  [self presentViewController:logInController animated:YES completion:nil];
  }
  
  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.6235, -122.3363), 100, 100) animated:true];
}

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateEnded) {
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locationCoordidate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *addDropPin = [[MKPointAnnotation alloc] init];
    addDropPin.coordinate = locationCoordidate;
    addDropPin.title = @"Reminder";
    [self.mapView addAnnotation:addDropPin];
  } else {


  }
}

// Buttons were part of first pice of assignment, I deleted them on the storyboard but kep their remnants 
//- (IBAction)buttonOne:(id)sender {
//  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.633567, -122.346287), 1000, 1000)];
//}
//
//- (IBAction)buttonTwo:(id)sender {
//  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.630681, -122.348639), 1000, 1000)];
//}
//
//- (IBAction)buttonThree:(id)sender {
//  [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(47.638050, -122.357182), 1000, 1000)];
//}

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

#pragma mark - Overlay Renderer
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
  MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
  
  circleRenderer.strokeColor = [UIColor blueColor];
  circleRenderer.fillColor = [UIColor redColor];
  circleRenderer.alpha = 0.5;
  
  return circleRenderer;
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
