//
//  Node.h
//  LocationReminders
//
//  Created by Sarah Hermanns on 9/7/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (strong,nonatomic) id value;
@property (strong,nonatomic) Node *next;

@end
