//
//  Reminder.h
//  LocationReminders
//
//  Created by Sarah Hermanns on 9/2/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface Reminder : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *reminderText;
@property (nonatomic) PFGeoPoint *coordinate;


@end
