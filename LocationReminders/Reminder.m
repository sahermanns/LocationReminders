//
//  Reminder.m
//  LocationReminders
//
//  Created by Sarah Hermanns on 9/2/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "Reminder.h"

@interface Reminder()

@end

@implementation Reminder

@dynamic locationName;
@dynamic reminderText;
@dynamic coordinate;

+ (NSString * __nonnull)parseClassName {
  return @"Reminder";
}


@end
