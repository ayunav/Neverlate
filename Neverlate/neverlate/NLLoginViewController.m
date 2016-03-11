//
//  NLLoginViewController.m
//  neverlate
//
//  Created by Ayuna Vogel on 11/26/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//

#import "NLLoginViewController.h"
#import "NLUser.h"
#import "NLTabBarViewController.h"

@interface NLLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation NLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumberTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.phoneNumberTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.passwordTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.phoneNumberTextField.layer.borderWidth = 1.5;
    self.passwordTextField.layer.borderWidth = 1.5;
    self.phoneNumberTextField.layer.cornerRadius = 20;
    self.passwordTextField.layer.cornerRadius = 20;
    
    self.loginButton.layer.cornerRadius = 20;
    
    [self textFieldShouldReturn:self.phoneNumberTextField];
    [self textFieldShouldReturn:self.passwordTextField];
    
    [self changePlaceholderTextToWhite];
    [self setupTapGestureRecognizer];
    [self dismissKeyboard];

}

- (IBAction)loginButtonTapped:(UIButton *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userPhoneNumber = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([userPhoneNumber length] == 0 || [password length] == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                                 message:@"Make sure to enter your phone number and password!"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        [NLUser logInWithUsernameInBackground:userPhoneNumber password:password block:^(PFUser *user, NSError *error) {
            if (user) {
                [defaults setBool:YES forKey:@"HasLaunchedOnce"];
                [defaults setBool:YES forKey:@"UserLoggedIn"];
                
                NLTabBarViewController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarViewControllerIdentifier"];
                if (![defaults boolForKey:@"UserHasGoal"]) {
                    [tabBarVC setSelectedIndex:1];
                }
                [self presentViewController:tabBarVC animated:YES completion:nil];
                
                [defaults synchronize];
            }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                                         message:[error.userInfo objectForKey:@"error"]
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];            }
        }];
    }
}

- (void)changePlaceholderTextToWhite {
    
    NSAttributedString *changePhoneNumberToWhite = [[NSAttributedString alloc] initWithString:@"   Phone Number" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    NSAttributedString *changePasswordToWhite = [[NSAttributedString alloc] initWithString:@"   Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    self.phoneNumberTextField.attributedPlaceholder = changePhoneNumberToWhite;
    self.passwordTextField.attributedPlaceholder = changePasswordToWhite;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
    } else if (textField == self.phoneNumberTextField) {
        [self.passwordTextField becomeFirstResponder];
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
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
