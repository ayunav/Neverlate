//
//  NLIntroViewController.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/27/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <EAIntroView/EAIntroView.h>
#import <QuartzCore/QuartzCore.h>

#import "NLIntroViewController.h"
#import "NLLoginViewController.h"
#import "NLSignupViewController.h"


@interface NLIntroViewController () <EAIntroDelegate> {
    EAIntroView *_intro;
}

@end

@implementation NLIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showIntro];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)showIntro {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"view1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"view2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"view3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"view4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.3];
    _intro = intro;
}

# pragma mark - EAIntroViewDelegate

- (void)introDidFinish:(EAIntroView *)introView {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex {
    if (pageIndex == 3) {
        [_intro limitScrollingToPage:_intro.visiblePageIndex];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0, self.view.frame.size.width, 50.0)];
    buttonView.backgroundColor = [UIColor greenColor];
    
    UIButton *signupButton = [[UIButton alloc] init];
    CGFloat signupButtonHeight = 50.0;
    signupButton.frame = CGRectMake(0, 0, self.view.frame.size.width / 2.0, signupButtonHeight);
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    signupButton.backgroundColor = [UIColor whiteColor];
    [signupButton addTarget:self action:@selector(signupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat lineWidth = 4.0;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - (lineWidth / 2.0), 0, lineWidth, 50.0)];
    lineView.backgroundColor = [UIColor blackColor];
    
    UIButton *loginButton = [[UIButton alloc] init];
    CGFloat loginButtonHeight = 50.0;
    loginButton.frame = CGRectMake(buttonView.frame.size.width / 2, 0, self.view.frame.size.width / 2.0, loginButtonHeight);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor whiteColor];
    [loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonView];
    [buttonView addSubview:signupButton];
    [buttonView addSubview:lineView];
    [buttonView addSubview:loginButton];
    
    buttonView.layer.shadowOffset = CGSizeMake(0, -2);
    buttonView.layer.shadowRadius = 4.0;
    buttonView.layer.shadowColor = [UIColor blackColor].CGColor;
    buttonView.layer.shadowOpacity = 0.15;
}

- (void)loginButtonPressed:(UIButton *)button {
    
    NLLoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)signupButtonPressed:(UIButton *)button {
    NLSignupViewController *signupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:signupViewController animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
