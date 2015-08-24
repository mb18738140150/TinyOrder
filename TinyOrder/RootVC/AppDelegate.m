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
#import "KeyboardManager.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>


@interface AppDelegate ()<HTTPPostDelegate, UIAlertViewDelegate, BMKGeneralDelegate>


@property (nonatomic, strong)AVAudioPlayer * avPlayer;
@property (nonatomic, strong)LoginViewController * loginVC;

@end

@implementation AppDelegate


static SystemSoundID shake_sound_male_id = 0;

- (void)onGetNetworkState:(int)iError
{
    NSLog(@"1 ++ %d", iError);
}
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"2 ++ %d", iError);
}

- (void)downloadData
{
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@25,
                               @"RegistrationID":[[NSUserDefaults standardUserDefaults] objectForKey:@"RegistrationID"]
                               };
    NSString * jsonStr = [jsonDic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    //    NSLog(@"////%@", md5Str);
    NSString * urlString = [NSString stringWithFormat:@"http://p.vlifee.com/getdata.ashx?md5=%@",md5Str];
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}


- (void)refresh:(id)data
{
    NSLog(@"%@", data);
     if ([[data objectForKey:@"Result"] isEqual:@1]) {
         if ([[data objectForKey:@"State"] isEqual:@2]) {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户在另一台设备登陆了..." delegate:self cancelButtonTitle:@"重新登陆" otherButtonTitles:nil, nil];
             [alertView show];
         }else if ([[data objectForKey:@"State"] isEqual:@1])
         {
             
         }
     }
}

- (void)failWithError:(NSError *)error
{
//    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//    [alertV show];
//    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
//    NSLog(@"%@", error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
    [nav dismissViewControllerAnimated:YES completion:nil];
}



-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nky" ofType:@"mp3"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
//        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    BMKMapManager * mapManager = [[BMKMapManager alloc] init];
    BOOL a = [mapManager start:@"CSjaE7cxYbuKhE9jyaSMZjnx" generalDelegate:self];
    if (!a) {
        NSLog(@"地图SDK初始化失败");
    }
//    self.notificationDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    NSError * ero = nil;
//    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"nky" ofType:@"mp3"];
//    self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&ero];
//    _avPlayer.volume = 0.9;
//    _avPlayer.numberOfLoops = 2;
//    [_avPlayer prepareToPlay];
    /*
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
    */
    [APService setupWithOption:launchOptions];
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
    [APService handleRemoteNotification:userInfo];
//    [_avPlayer play];
    [self playSound];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
//    NSLog(@"\\\\rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
//    NSLog(@"++%@", self.notificationDic);
    if (application.applicationIconBadgeNumber) {
//        [self downloadData];
        self.loginVC.myTabBarC.selectedIndex = 0;
        NSString * badgeValue = self.loginVC.myTabBarC.selectedViewController.navigationController.tabBarItem.badgeValue;
        if (badgeValue) {
            self.loginVC.myTabBarC.selectedViewController.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [badgeValue intValue] + application.applicationIconBadgeNumber];
        }
    }
//    NSLog(@",,,,%d", application.applicationIconBadgeNumber);
//    [application setApplicationIconBadgeNumber:0];
//    [application cancelAllLocalNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [UserInfo shareUserInfo].registrationID = [APService registrationID];
    NSLog(@"2323--%@", [APService registrationID]);
    [APService registerDeviceToken:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:[APService registrationID] forKey:@"RegistrationID"];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HAVEID"]) {
//        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
//        LoginViewController * loginVC = (LoginViewController *)nav.topViewController;
//        [loginVC login];
//        [[NSUserDefaults standardUserDefaults] setValue:@NO forKey:@"HAVEID"];
//    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微生活提醒你，你的帐号在别的设备登录，您已被退出"]) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户在另一台设备登陆了..." delegate:self cancelButtonTitle:@"重新登陆" otherButtonTitles:nil, nil];
//        [alertView show];
    }else
    {
        //    self.notificationDic = userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
        NSLog(@"11%@, %@", userInfo, [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
        //    BOOL i = [_avPlayer play];
        //    NSLog(@"bool = %d", i);
        // IOS 7 Support Required
        [APService handleRemoteNotification:userInfo];
        [self playSound];
    }
    
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"+++%@", error);
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"推送远程注册失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微生活提醒你，你的帐号在别的设备登录，您已被退出"]) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户在另一台设备登陆了..." delegate:self cancelButtonTitle:@"重新登陆" otherButtonTitles:nil, nil];
//        [alertView show];
    }else
    {
        //    self.notificationDic = userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
        NSLog(@"11%@, %@", userInfo, [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
        //    BOOL i = [_avPlayer play];
        //    NSLog(@"bool = %d", i);
        // IOS 7 Support Required
        [APService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        [self playSound];
    }
    
    application.applicationIconBadgeNumber = 0;
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
    if (application.applicationIconBadgeNumber) {
//        [self downloadData];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
