//
//  MyLoginViewController.m
//  LocationReminders
//
//  Created by Sarah Hermanns on 9/3/15.
//  Copyright (c) 2015 SASH. All rights reserved.
//

#import "MyLoginViewController.h"

@interface MyLoginViewController ()

@end

@implementation MyLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor darkGrayColor];
  
  UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reminder.png"]];
  self.logInView.logo = logoView; // logo can be any UIView
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
