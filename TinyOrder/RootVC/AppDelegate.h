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

static NSString *JPappKey = @"67bb79497a72001464037430";
static NSString *JPchannel = @"App Store";
static BOOL isProductionJP = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias;
@property (nonatomic, copy)NSDictionary * notificationDic;
- (void)autoPrint;

@end

