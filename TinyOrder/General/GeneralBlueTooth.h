//
//  GeneralBlueTooth.h
//  TinyOrder
//
//  Created by 仙林 on 15/4/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class UartLib;

@protocol GeneralBlueToothDelegate <NSObject>

- (void)didConnectBluetooth;
- (void)didDiscoverBluetooth;
- (void)didDisconnectBlutooth;

@end


@interface GeneralBlueTooth : NSObject


+ (GeneralBlueTooth *)shareGeneralBlueTooth;
@property (nonatomic, copy)NSString * deviceName;
@property (nonatomic, copy)NSString * deviceID;

@property (nonatomic, strong)CBPeripheral * myPeripheral;
@property (nonatomic, assign)id<GeneralBlueToothDelegate>delegate;

- (void)starScanBluetooth;
- (void)stopScanBluetooth;
- (void)connectBluetooth;
- (void)disConnectBluetooth;
- (void)printWithString:(NSString *)string;
- (void)printWithArray:(NSMutableArray *)array;
- (void)printPng:(id)sender;
@end
