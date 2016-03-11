//
//  NLLogoutViewController.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/28/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <Parse/Parse.h>

#import "NLLogoutViewController.h"
#import "NLUser.h"
#import "NLIntroViewController.h"

@interface NLLogoutViewController ()

@end

@implementation NLLogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)logoutButtonTapped:(UIButton *)sender {
    
    [NLUser logOut];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"UserLoggedIn"];
    [defaults setBool:NO forKey:@"HasLaunchedOnce"];
    [defaults synchronize];

    NLIntroViewController *introViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IntroViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:introViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
