//
//  NLTermsOfServiceViewController.m
//  neverlate
//
//  Created by Charles Kang on 12/7/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import "NLTermsOfServiceViewController.h"

@interface NLTermsOfServiceViewController ()

@end

@implementation NLTermsOfServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)backButtonTapped:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"back");
}

@end
