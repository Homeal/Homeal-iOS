//
//  HMAppDelegate.m
//  HomealApp2
//
//  Created by Ling Hung on 8/12/14.
//  Copyright (c) 2014 Homeal. All rights reserved.
//

#import "HMAppDelegate.h"
#import "HMFilterViewController.h"
#import "HMTabBarViewController.h"
#import "HMHomeViewController.h"
#import "MMDrawerVisualState.h"

@implementation HMAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *mainStroryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HMFilterViewController *filterController = (HMFilterViewController *)[mainStroryboard instantiateViewControllerWithIdentifier:@"FilterViewControllerID"];
    HMTabBarViewController *tabBarViewController = (HMTabBarViewController *)[mainStroryboard instantiateViewControllerWithIdentifier:@"TabBarViewControllerID"];
    
    self.drawController = [[MMDrawerController alloc] initWithCenterViewController:tabBarViewController leftDrawerViewController:filterController];
    
    [self.drawController setMaximumLeftDrawerWidth:240.0];
    [self.drawController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawController];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"vZ30q80vfjuDtW2j8dBg60Ttqlt2frsiZWrsDcnE"
                  clientKey:@"XsS3wG5g5xno4tDLKbzgWhRYGrXMW9dURkUsZWmc"];
    [PFFacebookUtils initializeFacebook];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
