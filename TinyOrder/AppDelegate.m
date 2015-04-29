//
//  AppDelegate.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "LoginViewController.h"
#import <APService.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()


@property (nonatomic, strong)AVAudioPlayer * avPlayer;
@property (nonatomic, strong)LoginViewController * loginVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.notificationDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSError * ero = nil;
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"nky" ofType:@"mp3"];
    self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&ero];
    _avPlayer.volume = 0.9;
//    _avPlayer.numberOfLoops = 3;
    [_avPlayer prepareToPlay];
    
    // Required
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //categories
            [APService
             registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                 UIUserNotificationTypeSound |
                                                 UIUserNotificationTypeAlert)
             categories:nil];
        } else {
            //categories nil
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#else
             //categories nil
             categories:nil];
            [APService
             registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                 UIRemoteNotificationTypeSound |
                                                 UIRemoteNotificationTypeAlert)
#endif
             // Required
             categories:nil];
        }
    [APService setupWithOption:launchOptions];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [application setApplicationIconBadgeNumber:0];
    self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    loginNav.navigationBar.translucent = NO;
    self.window.rootViewController = loginNav;
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    NSLog(@".....%@", userInfo);
    [APService handleRemoteNotification:userInfo];
    [_avPlayer play];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"\\\\rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (application.applicationIconBadgeNumber) {
        self.loginVC.myTabBarC.selectedIndex = 0;
        NSString * badgeValue = self.loginVC.myTabBarC.selectedViewController.navigationController.tabBarItem.badgeValue;
        if (badgeValue) {
            self.loginVC.myTabBarC.selectedViewController.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [badgeValue intValue] + application.applicationIconBadgeNumber];
        }
    }
//    NSLog(@",,,,%d", application.applicationIconBadgeNumber);
    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSLog(@"2323%@", deviceToken);
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
    NSLog(@"22%@", userInfo);
//    [_avPlayer play];
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"+++%@", error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"推送远程注册失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
    NSLog(@"11%@, %@", userInfo, [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
//    BOOL i = [_avPlayer play];
//    NSLog(@"%d", i);
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}
#endif




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
