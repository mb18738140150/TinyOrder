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
#import <AudioToolbox/AudioToolbox.h>
#import "QRCode.h"
#import "JRSwizzle.h"

#import "Meal.h"
#import "NewOrderModel.h"
#import "GeneralBlueTooth.h"

@interface AppDelegate ()<HTTPPostDelegate, UIAlertViewDelegate, BMKGeneralDelegate>


@property (nonatomic, strong)AVAudioPlayer * avPlayer;
@property (nonatomic, strong)LoginViewController * loginVC;

@property (nonatomic, strong)NewOrderModel *nOrdermodel;

@property (nonatomic, assign)int isWaimaiOrTangshi;

@property (nonatomic, assign)int aprint ;// 记录点击打印时，是否gprs与蓝牙同时打印
@property (nonatomic, assign)int isRequest; // 是否gprs蓝牙同时请求
@property (nonatomic, strong) NSDate * date;

@property (nonatomic, copy)NSString * orderID;

@end

@implementation AppDelegate


static SystemSoundID shake_sound_male_id = 0;

- (void)onGetNetworkState:(int)iError
{
    NSLog(@"网络错误 = %d", iError);
}
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"授权验证错误 = %d", iError);
}

// 该方法已被注
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

- (NewOrderModel *)nOrdermodel
{
    if (!_nOrdermodel) {
        self.nOrdermodel = [[NewOrderModel alloc]init];
    }
    return _nOrdermodel;
}

- (void)refresh:(id)data
{
    NSLog(@"%@", data);
     if ([[data objectForKey:@"Result"] isEqual:@1]) {
         int command = [[data objectForKey:@"Command"] intValue];
         if (command == 10025) {
             if ([[data objectForKey:@"State"] isEqual:@2]) {
                 UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户在另一台设备登录了..." delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
                 [alertView show];
             }else if ([[data objectForKey:@"State"] isEqual:@1])
             {
                 
             }
         }else if (command == 10003)
         {
             
             if ([PrintType sharePrintType].isGPRSenable) {
                 if ([PrintType sharePrintType].isBlutooth && [GeneralSwitch shareGeneralSwitch].bluetoothSwitch.on) {
                     // gprs蓝牙都有
                     if (self.isRequest == 1) {
                         NSArray * array = [data objectForKey:@"OrderList"];
                         NewOrderModel *model = [[NewOrderModel alloc]initWithDictionary:[array firstObject]];
                         self.nOrdermodel = model;
                         
                         [self printTest:model];
                         self.isRequest = 0;
                     }
                 }else
                 {
                     // 仅有gprs
                     NSArray * array = [data objectForKey:@"OrderList"];
                     NewOrderModel *model = [[NewOrderModel alloc]initWithDictionary:[array firstObject]];
                     self.nOrdermodel = model;
                     
                     [self printTest:model];
                 }
                 
             }else
             {
                 // 仅有蓝牙
                 NSArray * array = [data objectForKey:@"OrderList"];
                 NewOrderModel *model = [[NewOrderModel alloc]initWithDictionary:[array firstObject]];
                 self.nOrdermodel = model;
                 
                 [self printTest:model];
                 self.isRequest = 0;
             }
         
             
         }else if (command == 10015)
         {
             
//             if ([PrintType sharePrintType].isGPRSenable ) {
//                 ;
//             }
             if ([PrintType sharePrintType].isBlutooth)  {
                 
                 if (self.aprint == 1) {
                 
                     NSString * printStr = [self getPrintStringWithNewOrder:self.nOrdermodel];
                     
                     NSMutableArray * printAry = [NSMutableArray array];
                     int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                     for (int j = 0; j < num; j++) {
                         [printAry addObject:printStr];
                         
                         //                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithArray:printAry];
                         [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                         
                         if ([self.nOrdermodel.PayMath intValue] == 3) {
                             //                            UIImage * image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId] imageSize:200];
                             
                             
                             //                         UIImage * image = [[QRCode shareQRCode] createQRCodeForString:
                             //                                            [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", self.nOrdermodel.orderId, [UserInfo shareUserInfo].userId]];
                             //                         NSData * inageData = UIImageJPEGRepresentation(image, 1.0);
                             //                         UIImage * image1 = [UIImage imageWithData:inageData];
                             
                             NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", self.nOrdermodel.orderId, [UserInfo shareUserInfo].userId];
                             [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                             
                             
                         }
                         
                     }
                     self.aprint = 0;
                 }

             }
             
             
         }else if (command == 10069)
         {
//             if ([PrintType sharePrintType].isGPRSenable ) {
//                 
//             }
             if ([PrintType sharePrintType].isBlutooth)
             {
                 if (self.aprint == 1) {
                     NSString * printStr = [self getPrintStringWithTangshiOrder:self.nOrdermodel];
                     
                     NSMutableArray * printAry = [NSMutableArray array];
                     int num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"] intValue];
                     for (int j = 0; j < num; j++) {
                         [printAry addObject:printStr];
                         
                         //                        [[GeneralBlueTooth shareGeneralBlueTooth] printWithArray:printAry];
                         [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
                         
                         if (self.nOrdermodel.pays == 0) {
                             //                            UIImage * image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", order.orderId, [UserInfo shareUserInfo].userId] imageSize:200];
                             
                             
                             //                         UIImage * image = [[QRCode shareQRCode] createQRCodeForString:
                             //                                            [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", self.nOrdermodel.orderId, [UserInfo shareUserInfo].userId]];
                             //                         NSData * inageData = UIImageJPEGRepresentation(image, 1.0);
                             //                         UIImage * image1 = [UIImage imageWithData:inageData];
                             
                             NSString * str = [NSString stringWithFormat:@"http://wap.vlifee.com/eat/ScanCodeChangeMoney.aspx?ordersn=%@&busiid=%@&from=app", self.nOrdermodel.orderId, [UserInfo shareUserInfo].userId];
                             [[GeneralBlueTooth shareGeneralBlueTooth] printPng:str];
                             
                             
                         }
                         
                     }
                     self.aprint = 0;
                 }

                 
             }

         }else if (command == 10068)
         {
            
             if ([PrintType sharePrintType].isGPRSenable) {
                 if ([PrintType sharePrintType].isBlutooth && [GeneralSwitch shareGeneralSwitch].bluetoothSwitch.on) {
                     // gprs蓝牙都有
                     if (self.isRequest == 1) {
                         NSArray * array = [data objectForKey:@"OrderList"];
                         NewOrderModel *model = [[NewOrderModel alloc]initWithDictionary:[array firstObject]];
                         self.nOrdermodel = model;
                         
                         [self printTest:model];
                         self.isRequest = 0;
                     }
                 }else
                 {
                     // 仅有gprs
                     NSArray * array = [data objectForKey:@"OrderList"];
                     NewOrderModel *model = [[NewOrderModel alloc]initWithDictionary:[array firstObject]];
                     self.nOrdermodel = model;
                     
                     [self printTest:model];
                 }

             }else
             {
                 // 仅有蓝牙
                 NSArray * array = [data objectForKey:@"OrderList"] ;
                 NewOrderModel *model = [[NewOrderModel alloc]initWithDictionary:[array firstObject]];
                 self.nOrdermodel = model;
                 
                 [self printTest:model];
                 self.isRequest = 0;
             }
         
             
         }else if (command == 10075 || command == 10076)
         {
             NSDictionary * dic = [data objectForKey:@"OrderObject"];
             NewOrderModel * model = [[NewOrderModel alloc]initWithDictionary:dic];
             self.nOrdermodel = model;
             [self printTest:model];
         }
         
     }else
     {
         UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
         [alertV show];
         [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];//单线程方法,也就是说只有当前调用此方法的函数执行完毕后，selector方法才会被调用.可能会因为某些原因,不被调用,而导致不会执行dismiss方法
         //        alertV performSelectorOnMainThread:<#(SEL)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>//多线程方法,可以正常执行延迟方法
     }
}

- (void)printTest:(id )model
{

        NewOrderModel *newmodel = model;
    
//    if ([PrintType sharePrintType].isGPRSenable) {
//
//        
////        NSLog(@"********GPRS打印");
//        NSNumber *num = nil;
////        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gprsPrintNum"]) {
////            num = [[NSUserDefaults standardUserDefaults] objectForKey:@"gprsPrintNum"];
////        }else{
////            num = @(1);
////        }
//        
////        num = @([PrintType sharePrintType].gprsPrintCount);
//        if (self.isWaimaiOrTangshi == 1) {
//            NSDictionary * jsonDic = @{
//                                       @"UserId":[UserInfo shareUserInfo].userId,
//                                       @"Command":@15,
//                                       @"OrderId":newmodel.orderId,
//                                       @"PrintType":@3
//                                       };
//            
//            [self playPostWithDictionary:jsonDic];
//        }else if(self.isWaimaiOrTangshi == 2)
//        {
//            NSDictionary * jsonDic = @{
//                                       @"UserId":[UserInfo shareUserInfo].userId,
//                                       @"Command":@69,
//                                       @"OrderId":newmodel.orderId,
//                                       @"PrintType":@3
//                                       };
//            
//            [self playPostWithDictionary:jsonDic];
//
//        }
//    }
    if ([PrintType sharePrintType].isBlutooth)
    {
        self.aprint = 1;
        if (self.isWaimaiOrTangshi == 1) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@15,
                                       @"OrderId":newmodel.orderId,
                                       @"PrintType":@2
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (self.isWaimaiOrTangshi == 2)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@69,
                                       @"OrderId":newmodel.orderId,
                                       @"PrintType":@2
                                       };
            
            [self playPostWithDictionary:jsonDic];

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
    if (alertView.tag == 1234) {
        ;
    }else
    {
        
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        
        if (buttonIndex == 0) {
            
            [nav dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            
        }
    }
    
    
    
}



-(void) playSound

{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"caf"];
    if (path) {
        //注册声音到系统
        NSURL *url = [NSURL fileURLWithPath:path];
        CFURLRef inFileURL = (__bridge CFURLRef)url;
        AudioServicesCreateSystemSoundID(inFileURL,&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
//        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    
    
}

- (void)autoPrint
{
    // 收到推送消息以后判断是否自动打印
    int gprsnumber = 0;
    int blutoothNumber = 0;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"gprsPrintNum"]) {
//        NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"gprsPrintNum"];
//        gprsnumber = [num intValue];
//        
//        
//    }else
//    {
//        gprsnumber = 1;
//    }
    
//    gprsnumber = [PrintType sharePrintType].gprsPrintCount;

    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"]) {
        NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"printNum"];
        blutoothNumber = [num intValue];
    }else
    {
        blutoothNumber = 1;
    }
    
//    if ([PrintType sharePrintType].isGPRSenable) {
//        if (self.isWaimaiOrTangshi == 2) {
//            NSDictionary * jsonDic = @{
//                                       @"UserId":[UserInfo shareUserInfo].userId,
//                                       @"CurPage":@1,
//                                       @"TangshiType":@1,
//                                       @"Command":@68,
//                                       @"CurCount":@(COUNT)
//                                       };
//            [self playPostWithDictionary:jsonDic];
//
//        }else if (self.isWaimaiOrTangshi == 1)
//        {
//            NSDictionary * jsonDic = @{
//                                       @"UserId":[UserInfo shareUserInfo].userId,
//                                       @"CurPage":@1,
//                                       @"Command":@3,
//                                       @"CurCount":@(COUNT)
//                                       };
//            [self playPostWithDictionary:jsonDic];
//        }
//        
//    }
    if (blutoothNumber != 0 && [PrintType sharePrintType].isBlutooth && [GeneralSwitch shareGeneralSwitch].bluetoothSwitch.on)
    {
        self.isRequest = 1;
        if (self.isWaimaiOrTangshi == 2) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@76,
                                       @"OrderId":self.orderID
                                       };
            [self playPostWithDictionary:jsonDic];
            
        }else if (self.isWaimaiOrTangshi == 1)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@75,
                                       @"OrderId":self.orderID
                                       };
            [self playPostWithDictionary:jsonDic];
        }
   
    }
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
    
    self.aprint = 0;
    self.isRequest = 0;
    
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
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    [APService setupWithOption:launchOptions];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [application setApplicationIconBadgeNumber:0];
    self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController * loginNav = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    loginNav.navigationBar.translucent = NO;
    self.window.rootViewController = loginNav;
    
    [NSDictionary jr_swizzleMethod:@selector(description) withMethod:@selector(my_description) error:nil];
    
    
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

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
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
    static UIBackgroundTaskIdentifier task;
    task = [application beginBackgroundTaskWithExpirationHandler:^{
        task = UIBackgroundTaskInvalid;
    }];
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
//    NSLog(@"2323--%@", [APService registrationID]);
    [APService registerDeviceToken:deviceToken];
    
//    NSLog(@"*&*&*&*^*&^*^&---deviceToken = %@", deviceToken);
    
    NSString *str = [APService registrationID];
//    NSLog(@"************str = %@", str);
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
    NSLog(@"********userInfo = %@*******************",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] );
    if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微生活提醒你，你的帐号在别的设备登录，您已被退出"]) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账户在另一台设备登录了..." delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:nil, nil];
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

    }else
    {
//        NSString * str1 = [userInfo JSONString];
//        
//                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str1 delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertView.tag = 1234;
//                [alertView show];
        NSString * str = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if ([str containsString:@"您收到了一个新的订单"]) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                            [alertView show];
        //  [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微外卖提醒您,您收到了一个新的堂食订单(餐到付款),请注意处理"] || [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微外卖提醒您,您收到了一个新的堂食订单(已支付),请注意处理"]
//        }
        if ([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isEqualToString:@"微外卖提醒您，您收到了一个新的订单(餐到付款),请注意处理"]) {
            self.isWaimaiOrTangshi = 1;
            self.orderID = [userInfo objectForKey:@"ordersn"];
            [self autoPrint];
            [self playSound];
        }else if ([str containsString:@"您收到了一个新的堂食订单(餐到付款)" ] || [str containsString:@"您收到了一个新的堂食订单(已支付)" ] )
        {
            self.isWaimaiOrTangshi = 2;
            self.orderID = [userInfo objectForKey:@"ordersn"];
            [self autoPrint];
            [self playSound];
        }else if ([str containsString:@"您收到了一个新的订单"])
        {
            self.isWaimaiOrTangshi = 1;
            self.orderID = [userInfo objectForKey:@"ordersn"];
            [self autoPrint];
            [self playSound];
        }
        
        //    self.notificationDic = userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
        NSLog(@"11%@, %@", userInfo, [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
        //    BOOL i = [_avPlayer play];
        //    NSLog(@"bool = %d", i);
        // IOS 7 Support Required
        [APService handleRemoteNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
        
        
    }
    
    application.applicationIconBadgeNumber = 0;
}

#pragma mark - 自动打印
- (NSString *)getPrintStringWithNewOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r", order.orderNum, [UserInfo shareUserInfo].StroeName];
    [str appendFormat:@"店铺:%@\r%@", [UserInfo shareUserInfo].userName, lineStr];
    [str appendFormat:@"下单时间:%@\r", order.orderTime];
    [str appendFormat:@"送达时间:%@\r%@", order.hopeTime, lineStr];
    [str appendFormat:@"订单号:%@\r", order.orderId];
    [str appendFormat:@"地址:%@\r", order.address];
    [str appendFormat:@"联系人:%@\r", order.contect];
    [str appendString:[self dataString]];
    [str appendFormat:@"电话:%@\r%@", order.tel, lineStr];
    [str appendString:[self normalString]];
    if (order.remark.length != 0) {
        [str appendFormat:@"备注:%@\r%@", order.remark, lineStr];
    }
    
    if (order.gift.length != 0) {
        [str appendFormat:@"奖品:%@\r%@", order.remark, lineStr];
    }
    
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@份  %@元\r", meal.name, space, meal.count, meal.money];
    }
    [str appendString:lineStr];
    if ([order.delivery doubleValue] != 0) {
        [str appendFormat:@"配送费           +%@元\r", order.delivery];
    }
    if ([order.foodBox doubleValue] != 0) {
        [str appendFormat:@"餐盒费           +%@元\r", order.foodBox];
    }
    
    if ([order.firstReduce doubleValue] != 0) {
        [str appendFormat:@"首单立减           -%@元\r", order.firstReduce];
    }
    if ([order.fullReduce doubleValue] != 0) {
        [str appendFormat:@"满减优惠           -%@元\r", order.fullReduce];
    }
    if ([order.reduceCard doubleValue] != 0) {
        [str appendFormat:@"优惠券           -%@元\r%@", order.reduceCard, lineStr];
    }
    
    if ([order.internal intValue] != 0) {
        double integral = order.internal.doubleValue / 100;
        [str appendFormat:@"积分           -%.2f元\r%@", integral, lineStr];
    }
    if (order.discount != 0) {
        
        [str appendFormat:@"打折           %.1f折\r%@", order.discount, lineStr];
    }
    if (order.tablewareFee != 0) {
        [str appendFormat:@"餐具费           +%f元\r%@", order.tablewareFee, lineStr];
    }
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    
    if ([order.PayMath isEqualToNumber:@3]) {
        [str appendFormat:@"总计     %@元      现金支付\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if ([order.PayMath intValue] == 3) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        NSLog(@"********%@", order.PayMath);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n"];
    return [str copy];
}

- (NSString *)dataString
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x16;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}

- (NSString *)normalString
{
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x00;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * str = [[NSString alloc] initWithBytes:caPrintFmt length:5 encoding:enc];
    return  str;
}

- (NSString *)getPrintStringWithTangshiOrder:(NewOrderModel *)order
{
    NSString * spaceString = @"                           ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    [str appendFormat:@"%d号    %@\r%@", order.orderNum, [UserInfo shareUserInfo].StroeName, lineStr];
    [str appendFormat:@"下单时间:%@\r%@", order.orderTime, lineStr];
    [str appendFormat:@"订单号:%@\r", order.orderId];
    [str appendFormat:@"用餐位置:%@\r", order.eatLocation];
    [str appendFormat:@"用餐人数:%d\r%@", order.customerCount, lineStr];
    if (order.remark.length != 0) {
        [str appendFormat:@"备注:%@\r%@", order.remark, lineStr];
    }
    
    if (order.gift.length != 0) {
        [str appendFormat:@"奖品:%@\r%@", order.remark, lineStr];
    }
    
    for (Meal * meal in order.mealArray) {
        NSInteger length = 16 - meal.name.length;
        NSString * space = [spaceString substringWithRange:NSMakeRange(0, length)];
        [str appendFormat:@"%@%@%@份  %@元\r", meal.name, space, meal.count, meal.money];
    }
    [str appendString:lineStr];
    if ([order.delivery doubleValue] != 0) {
        [str appendFormat:@"配送费           +%@元\r", order.delivery];
    }
    if ([order.foodBox doubleValue] != 0) {
        [str appendFormat:@"餐盒费           +%@元\r", order.foodBox];
    }
    
    if ([order.firstReduce doubleValue] != 0) {
        [str appendFormat:@"首单立减           -%@元\r", order.firstReduce];
    }
    if ([order.fullReduce doubleValue] != 0) {
        [str appendFormat:@"满减优惠           -%@元\r", order.fullReduce];
    }
    if ([order.reduceCard doubleValue] != 0) {
        [str appendFormat:@"优惠券           -%@元\r%@", order.reduceCard, lineStr];
    }
    if ([order.internal intValue] != 0) {
        double integral = order.internal.doubleValue / 100;
        [str appendFormat:@"积分           -%.2f元\r%@", integral, lineStr];
    }
    if (order.discount != 0) {
        
        [str appendFormat:@"打折           %.1f折\r%@", order.discount, lineStr];
    }
    if (order.tablewareFee != 0) {
        [str appendFormat:@"餐具费           +%f元\r%@", order.tablewareFee, lineStr];
    }
    if ([order.otherMoney doubleValue] != 0) {
        [str appendFormat:@"其他费用           +%@元\r%@", order.otherMoney, lineStr];
    }
    if (order.pays == 0) {
        [str appendFormat:@"总计     %@元      未付款\r%@", order.allMoney, lineStr];
    }else
    {
        [str appendFormat:@"总计     %@元          已付款\r%@", order.allMoney, lineStr];
    }
    if (order.pays == 0) {
        //        NSString * string = @"扫描下方二维码完成订单支付";
        NSLog(@"********%@", order.PayMath);
        [str appendFormat:@"扫描下方二维码完成订单支付"];
    }
    [str appendFormat:@"\n"];
    return [str copy];
    
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









//
//#pragma mark - JLPush成功注册后的回调方法
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//    // Required
//    [APService registerDeviceToken:deviceToken];
//    
//    NSString *str = [APService registrationID];
//    
//    // 设置别名
//    [APService setTags:nil alias:[NSString stringWithFormat:@"alias%@", str] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//}
//#pragma mark - tagsAliasCallback 向JPush注册alias 成功的回调方法
//-(void)tagsAliasCallback:(int)iResCode
//                    tags:(NSSet*)tags
//                   alias:(NSString*)alias
//{
//    NSLog(@"注册alias 成功的回调 ********** rescode: %d ---- tags: %@ ---- alias: %@", iResCode, tags , alias);
//    
//    NSLog(@"注册alias 成功的回调 ********** token = %@", [KDUserInfoModel shareUserInfoMode].owner.token);
//    
//    self.alias = alias;
//    
//    // 成功后进入判断（多次注册alias，iResCode的值只会有一次为0--成功）
//    if (iResCode == 0) {
//        // 获取用户token
//        NSString *userToken = [KDUserInfoModel shareUserInfoMode].owner.token;
//        
//        // 记录alias
//        [KDUserInfoModel shareUserInfoMode].owner.alias = alias;
//        
//        // 判断用户token是否存在，长度是否不为0
//        if (userToken != nil && userToken.length != 0 && ![KDUserInfoModel shareUserInfoMode].owner.isLogin) {
//            // 如果已经存在并且有值，直接执行向自己服务器发送有关推送数据的方法
//            if (!uploadToken) {
//                // 发送的前提是没有成功上传过token
//                [self uploadJPushInfoAndUserTokenWithAlias:alias andToken:userToken];
//                // 标记上传状态为成功（不考虑服务器故障）
//                uploadToken = YES;
//            }
//        }
//        
//        
//        // 添加监听
//        // 如果用户还未登录，登录后调用回调方法完成向服务器发送token的方法
//        // 如果用户已经登录，检测是否会多次注销再登录，再登录时依然要向服务器发送token
//        [[KDUserInfoModel shareUserInfoMode] addObserver:self forKeyPath:@"owner.token" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
//    }
//}
//
//#pragma mark - KVO 的回调方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"owner.token"]) {
//        NSString *oldToken = [change valueForKey:@"old"];
//        NSString *newToken = [change valueForKey:@"new"];
//        NSString *alias = [NSString stringWithFormat:@"alias%@", [APService registrationID]];
//        
//        if (newToken.length != 0 && ![KDUserInfoModel shareUserInfoMode].owner.isLogin) {
//            // 如果刚开始没有登录过，后来成功登录
//            if (!uploadToken) {
//                // 如股还没有上传过token，那么上传，否则，不再上传
//                [self uploadJPushInfoAndUserTokenWithAlias:alias andToken:newToken];
//                uploadToken = YES;
//            }
//        } else if (newToken.length == 0 && oldToken.length != 0 && [KDUserInfoModel shareUserInfoMode].owner.isLogin) {
//            // 如过已经登录过，后来又注销了，token的上传状态要标记为NO
//            uploadToken = NO;
//        }
//    }
//}
//
//
//#pragma mark - 向服务器发送有关推送数据的方法
//- (void)uploadJPushInfoAndUserTokenWithAlias:(NSString *)alias andToken:(NSString *)token
//{
//    // 上传信息
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    NSDictionary *parameters = @{@"token":token, @"pushAlias":alias, @"deviceType":@"4", @"apiKey":@"35c2dbef04c3376805a936d6"};
//    
//    NSString *urlStr = @"http://www.ovopark.com/service/registerPushInfo.action";
//    
//    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"数据请求成功 -- responseObject -- %@", responseObject);
//        
//        if ([responseObject[@"result"] isEqualToString:@"ok"]) {
//            // 如果服务器成功获得token并且返回了ok，那么标记状态为已经上传了token
//            uploadToken = YES;
//            [KDUserInfoModel shareUserInfoMode].owner.alias = alias;
//        } else if ([responseObject[@"result"] isEqualToString:@"INVALID_TOKEN"]) {
//            // 如果服务器未能成功获得token，那么标记状态为未上传了token
//            uploadToken = NO;
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"数据请求失败 -- %@", error);
//    }];
//}
//
//#pragma mark - 收到推送后的回调方法
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    // 收到消息后调用此方法
//    // IOS 7 Support Required
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//    NSLog(@"%@", userInfo);
//    // 处理收到的推送消息
//    [self configureJPushUserInfo:userInfo];
//}
//
//#pragma mark - configureJPushUserInfo 处理收到的推送消息
//- (void)configureJPushUserInfo:(NSDictionary *)userInfo
//{
//    // 拿到包含处理信息的字典
//    NSDictionary *contentDic = userInfo[@"content"];
//    NSLog(@"%@", contentDic);
//    // 拿到 type
//    NSInteger type = [contentDic[@"type"] integerValue];
//    // 任务id
//    //    NSString *taskID = [userInfo valueForKey:@"id"];
//    
//    // 根据type分别处理事件
//    if (type == 1) {
//        
//    } else if (type == 2) {
//        // 需要管理
//        self.rDVTabBarController.selectedIndex = 1;
//    } else if (type == 3) {
//        // 需要管理
//        self.rDVTabBarController.selectedIndex = 1;
//    } else if (type == 4) {
//        // 需要管理
//        self.rDVTabBarController.selectedIndex = 1;
//    } else if (type == 5) {
//        // 需要管理
//        self.rDVTabBarController.selectedIndex = 1;
//    } else if (type == 6) {
//        // 重复登录
//        if ([KDUserInfoModel shareUserInfoMode].owner.isLogin) {
//            // 退出登录
//            [[KDUserInfoModel shareUserInfoMode].owner userLogout];
//            
//            // 上传token状态也要置为NO
//            uploadToken = NO;
//            [[KDUserInfoModel shareUserInfoMode].owner userLogout];
//            
//            // 提醒用户
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"重复登录" message:@"您的账号在另一台手机登录！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } else if (type == 7) {
//        
//    } else if (type == 8) {
//        // 需要管理
//        self.rDVTabBarController.selectedIndex = 1;
//    }
//}


@end
