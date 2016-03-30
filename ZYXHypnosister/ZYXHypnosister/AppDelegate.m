//
//  AppDelegate.m
//  ZYXHypnosister
//
//  Created by 卓酉鑫 on 16/2/23.
//  Copyright © 2016年 卓酉鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYXHypnosisView.h"
//#import "ZYXViewController.h"

@interface AppDelegate () <UIScrollViewDelegate>

@property (nonatomic, strong) ZYXHypnosisView *firstView;

@end

@implementation AppDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"缩放");
    return self.firstView;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //Xcode7 iOS9之后window必须有一个rootViewController
    //Xcode7 iOS9之后必须将rootViewController方法和makeKeyAndVisible放在UIWindow添加subview的前面才可以自动变颜色
    //因为在后面添加rootViewController,则controller的view会盖住window添加的subView
    
    //正常使用其实应该在vc中的view上添加subView，这样顺序就不会出问题
    UIViewController *vc = [[UIViewController alloc] init];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    //bigRect.size.height *= 2.0;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.pagingEnabled = NO;
    scrollView.delegate = self;
    self.firstView = [[ZYXHypnosisView alloc] initWithFrame:screenRect];
    screenRect.origin.x += screenRect.size.width;
    ZYXHypnosisView *secondView = [[ZYXHypnosisView alloc] initWithFrame:screenRect];
   
    
    scrollView.contentSize = bigRect.size;
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = 0.5;
    [scrollView addSubview:self.firstView];
    [scrollView addSubview:secondView];
    [self.window addSubview:scrollView];
    
    //只能Debug状态下使用
    //[self.window performSelector:@selector(recursiveDescription)];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    return YES;
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
}

@end
