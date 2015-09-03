//
//  AddReminderDetailViewController.m
//  LocationReminders
//
//  Created by Sarah Hermanns on 9/2/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "AddReminderDetailViewController.h"
#import "ViewController.h"
#import "Reminder.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "constants.h"

@interface AddReminderDetailViewController ()


@property (weak, nonatomic) IBOutlet UITextField *annotationTitle;

@property (weak, nonatomic) IBOutlet UITextField *reminderTextField;



@end

@implementation AddReminderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  

  
}


- (IBAction)addReminderButton:(id)sender {
  
 
  Reminder *reminder = [Reminder object];
  reminder.locationName = self.annotationTitle.text;
  reminder.reminderText = self.reminderTextField.text;
  
  PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.annotationCoordinates.latitude longitude: self.annotationCoordinates.longitude];
  
  reminder.coordinate = geoPoint;
  
  [reminder saveInBackground];
  
  PFQuery *reminderQuery = [Reminder query];
  [reminderQuery findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
    
  Reminder *firstReminder = [reminders firstObject];
  NSLog(@"%@",firstReminder.locationName);
  NSLog(@"%@",firstReminder.reminderText);
    
  }];
  
  
  
  
  NSDictionary *userInfo = [NSDictionary dictionaryWithObject:reminder forKey:@"NewReminder"];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:kReminderNotification object:self userInfo:userInfo];
  
}
@end
