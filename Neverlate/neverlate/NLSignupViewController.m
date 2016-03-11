//
//  NLSignupViewController.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/26/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import <Parse/Parse.h>

#import "NLSignupViewController.h"
#import "NLUser.h"
#import "NLTabBarViewController.h"

@interface NLSignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation NLSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.firstNameTextField.delegate = self;
    self.firstNameTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.firstNameTextField.layer.borderWidth = 1.5;
    self.firstNameTextField.layer.cornerRadius = 20;
    
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.phoneNumberTextField.layer.borderWidth = 1.5;
    self.phoneNumberTextField.layer.cornerRadius = 20;

    self.passwordTextField.delegate = self;
    self.passwordTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.passwordTextField.layer.borderWidth = 1.5;
    self.passwordTextField.layer.cornerRadius = 20;
    
    self.signUpButton.layer.cornerRadius = 20;
    
    [self textFieldShouldReturn:self.firstNameTextField];
    [self textFieldShouldReturn:self.phoneNumberTextField];
    [self textFieldShouldReturn:self.passwordTextField];
    
    [self changePlaceholderTextToWhite];
    [self setupTapGestureRecognizer];
    [self dismissKeyboard];
}

- (IBAction)signupButtonTapped:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userFirstName = [self.firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *userPhoneNumber = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *userPassword = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([userFirstName length] == 0 || [userPassword length] == 0 || [userPhoneNumber length] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"Make sure to enter your first name, phone number, and password!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        NLUser *newUser = [NLUser user];
        newUser.username = userPhoneNumber;
        newUser.password = userPassword;
        newUser[@"phoneNumber"] = userPhoneNumber;
        newUser[@"name"] = userFirstName;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [defaults setBool:YES forKey:@"HasLaunchedOnce"];
                [defaults setBool:YES forKey:@"UserLoggedIn"];

                NLTabBarViewController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarViewControllerIdentifier"];
                if (![defaults boolForKey:@"UserHasGoal"]) {
                    [tabBarVC setSelectedIndex:1];
                }
                [self presentViewController:tabBarVC animated:YES completion:nil];
                
                [defaults synchronize];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                                         message:[error.userInfo objectForKey:@"error"]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
}

- (void)changePlaceholderTextToWhite {
    
    NSAttributedString *changeFirstNameToWhite = [[NSAttributedString alloc] initWithString:@"   First Name" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    NSAttributedString *changePhoneNumberToWhite = [[NSAttributedString alloc] initWithString:@"   Phone Number" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    NSAttributedString *changePasswordToWhite = [[NSAttributedString alloc] initWithString:@"   Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    self.firstNameTextField.attributedPlaceholder = changeFirstNameToWhite;
    self.phoneNumberTextField.attributedPlaceholder = changePhoneNumberToWhite;
    self.passwordTextField.attributedPlaceholder = changePasswordToWhite;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
    } else if (textField == self.firstNameTextField) {
        [self.phoneNumberTextField becomeFirstResponder];
    }
    return YES;
}

- (void)setupTapGestureRecognizer {
    // tap to dismiss keyboard!
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:YES];
}

-(void)dismissKeyboard {
    [self.firstNameTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
