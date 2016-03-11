//
//  AppDelegate.m
//  neverlate
//
//  Created by Charles Kang on 11/10/15.
//  Copyright © 2015 Charles Kang. All rights reserved.
//
#import <Parse/Parse.h>
#import <Venmo-iOS-SDK/Venmo.h>

#import "AppDelegate.h"
#import "NLGoal.h"
#import "NLUser.h"
#import "NLIntroViewController.h"
#import "NLLoginViewController.h"
#import "NLSignupViewController.h"
#import "NLAddGoalViewController.h"
#import "NLTabBarViewController.h"

NSString * const parseApplicationId = @"YOUR_PARSE_APP_ID";
NSString * const parseClientKey = @"YOUR_PARSE_CLIENT_KEY";

NSString * const venmoAppId = @"YOUR_VENMO_APP_ID";
NSString * const venmoAppSecret = @"YOUR_VENMO_APP_SECRET";
NSString * const venmoAppName = @"YOUR_VENMO_APP_NAME";


@interface AppDelegate ()  

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse enableLocalDatastore];
    [NLUser registerSubclass];
    [NLGoal registerSubclass];
    [Parse setApplicationId:parseApplicationId
                  clientKey:parseClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Venmo startWithAppId:venmoAppId secret:venmoAppSecret name:venmoAppName];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (![defaults boolForKey:@"HasLaunchedOnce"]) {
        NLIntroViewController *introViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IntroViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:introViewController];
        self.window.rootViewController = navigationController;
    } else if ([defaults boolForKey:@"HasLaunchedOnce"] && [defaults boolForKey:@"UserLoggedIn"]) {
        NLTabBarViewController *tabBarVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarViewControllerIdentifier"];
     
        if ([defaults boolForKey:@"UserHasGoal"]) {
            [tabBarVC setSelectedIndex:1];
        }
        self.window.rootViewController = tabBarVC;
    }

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Pacifico" size:24], NSFontAttributeName, nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    return YES;

    // enable creating anonymous users w/out users having to sign up/register
    //    [PFUser enableAutomaticUser];
    //    [[PFUser currentUser] incrementKey:@"RunCount"];
    //    [[PFUser currentUser] saveInBackground];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    
    // deep linking
    if ([url.scheme isEqualToString: @"neverlate"]) {
        // check our `host` value to see what screen to display
        // TODO you can also pass parameters - e.g. birdland://home?refer=twitter
        if ([url.host isEqualToString: @"challenge"]) {
            // should open Profile VC, not create VC - Eric
            NLTabBarViewController *addGoalViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"tabBarViewControllerIdentifier"];
            self.window.rootViewController = addGoalViewController;
        } else {
            NSLog(@"An unknown action was passed.");
        }
    } else {
        NSLog(@"We were not opened with neverlate.");
    }
    
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.charleshkang.neverlate" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"neverlate" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"neverlate.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
