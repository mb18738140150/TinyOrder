//
//  AppDelegate.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias;
@property (nonatomic, copy)NSDictionary * notificationDic;
- (void)autoPrint;

@end

