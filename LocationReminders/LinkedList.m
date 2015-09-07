//
//  LinkedList.m
//  LocationReminders
//
//  Created by Sarah Hermanns on 9/7/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "LinkedList.h"
#import "Node.h"

@interface LinkedList()

@property (strong, nonatomic) Node *head;


@end

@implementation LinkedList

-(void)addValue: (id)value {
  
  Node *newNode = [[Node alloc] init];
  newNode.value = value;
  
  if (!self.head) {
    self.head = newNode;
    return;
  } else {
    Node *currentNode = self.head;
    
    while (currentNode.next) {
      currentNode = currentNode.next;
    }
    currentNode.next = newNode;
  }
}



@end
