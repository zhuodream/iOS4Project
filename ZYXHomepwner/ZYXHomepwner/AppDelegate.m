//
//  AppDelegate.m
//  ZYXHomepwner
//
//  Created by 卓酉鑫 on 16/3/1.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYXItemsViewController.h"
#import "ZYXItemStore.h"

NSString *const ZYXNextItemValuePrefsKey = @"NextItemValue";
NSString *const ZYXNextItemNamePrefsKey = @"NextItemName";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySetting = @{ ZYXNextItemValuePrefsKey : @75,
                                      ZYXNextItemNamePrefsKey : @"Coffe Cup"};
    [defaults registerDefaults:factorySetting];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (!self.window.rootViewController)
    {
        ZYXItemsViewController *itemsViewController = [[ZYXItemsViewController alloc]
                                                       init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
        nav.restorationIdentifier = NSStringFromClass([nav class]);
        self.window.rootViewController = nav;
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[ZYXItemStore sharedStore] saveChanges];
    if (success)
    {
        NSLog(@"Saved all of the ZYXItems");
    }
    else
    {
        NSLog(@"Could not save any of the ZYXItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController *vc = [[UINavigationController alloc] init];
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    if ([identifierComponents count] == 1)
    {
        self.window.rootViewController = vc;
    }
    
    return vc;
}

@end
