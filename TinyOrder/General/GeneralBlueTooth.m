//
//  GeneralBlueTooth.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/20.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "GeneralBlueTooth.h"
#import "UartLib.h"


@interface GeneralBlueTooth ()<UartDelegate>


@property (nonatomic, strong)UartLib * uartLib;
@property (nonatomic, strong)NSMutableArray * printArray;


@end


@implementation GeneralBlueTooth


+ (GeneralBlueTooth *)shareGeneralBlueTooth
{
    static GeneralBlueTooth * generalBT = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generalBT = [[GeneralBlueTooth alloc] init];
        generalBT.uartLib = [[UartLib alloc] init];
        generalBT.uartLib.uartDelegate = generalBT;
    });
    return generalBT;
}

- (void)starScanBluetooth
{
    [self.uartLib scanStart];
}

- (void)stopScanBluetooth
{
    [self.uartLib scanStop];
}

- (void)connectBluetooth
{
    [self.uartLib scanStop];
    [self.uartLib connectPeripheral:self.myPeripheral];
}


- (void)disConnectBluetooth
{
    [self.uartLib scanStop];
    [self.uartLib disconnectPeripheral:self.myPeripheral];
}


- (void)printWithString:(NSString *)string
{
    [self PrintWithFormat:string];
}

- (void)printWithArray:(NSMutableArray *)array
{
    NSString * str = [array firstObject];
    [self PrintWithFormat:str];
    [array removeObjectAtIndex:0];
    self.printArray = array;
}


- (void) PrintWithFormat:(NSString *)printContent{
#define MAX_CHARACTERISTIC_VALUE_SIZE 20
    NSData  *data	= nil;
    NSUInteger i;
    NSUInteger strLength;
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    Byte caPrintFmt[5];
    
    /*初始化命令：ESC @ 即0x1b,0x40*/
    caPrintFmt[0] = 0x1b;
    caPrintFmt[1] = 0x40;
    
    /*字符设置命令：ESC ! n即0x1b,0x21,n*/
    caPrintFmt[2] = 0x1b;
    caPrintFmt[3] = 0x21;
    
    caPrintFmt[4] = 0x00;
    
    
    NSData *cmdData =[[NSData alloc] initWithBytes:caPrintFmt length:5];
    
    [self.uartLib sendValue:self.myPeripheral sendData:cmdData type:CBCharacteristicWriteWithResponse];
    NSLog(@"format:%@", cmdData);
    
    
    
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //NSData *data = [curPrintContent dataUsingEncoding:enc];
    //NSLog(@"dd:%@", data);
    //NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
    //NSLog(@"str:%@", retStr);
    
    strLength = [printContent length];
    if (strLength < 1) {
        return;
    }
    
    cellCount = (strLength%MAX_CHARACTERISTIC_VALUE_SIZE)?(strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        //NSLog(@"print:%d,%d,%d,%d", strLength,cellCount, cellMin, cellLen);
        NSRange rang = NSMakeRange(cellMin, cellLen);
        NSString *strRang = [printContent substringWithRange:rang];
        NSLog(@"print:%@", strRang);
        
        data = [strRang dataUsingEncoding: enc];
        //data = [strRang dataUsingEncoding: NSUTF8StringEncoding];
        NSLog(@"print:%@", data);
        //data = [strRang dataUsingEncoding: NSUTF8StringEncoding];
        //NSLog(@"print:%@", data);
        
        [self.uartLib sendValue:self.myPeripheral sendData:data type:CBCharacteristicWriteWithResponse];
    }
}

- (void) didBluetoothPoweredOff
{
    
}
- (void) didBluetoothPoweredOn
{
    
}
- (void) didScanedPeripherals:(NSMutableArray  *)foundPeripherals
{
    
    NSLog(@"发现数组");
    /*
     if (foundPeripherals.count) {
     self.connectPeripheral = [foundPeripherals firstObject];
     if (self.connectPeripheral.name) {
     self.deviceName.text = self.connectPeripheral.name;
     }else
     {
     self.deviceName.text = @"打印机";
     }
     }else
     {
     self.deviceName.text = nil;
     self.connectPeripheral = nil;
     }
     */
}
- (void) didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.delegate didConnectBluetooth];
    NSLog(@"连接蓝牙%@", peripheral);
    NSLog(@"%d", self.myPeripheral.state);
}
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.deviceName = nil;
}

- (void) didReceiveData:(CBPeripheral *)peripheral recvData:(NSData *)recvData
{
    NSLog(@"接收数据%@", recvData);
}

- (void) didWriteData:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"已经写入数据%@", error);
    if (self.printArray.count) {
        NSString * str = [self.printArray firstObject];
        [self PrintWithFormat:str];
        [self.printArray removeObjectAtIndex:0];
    }
}

- (void) didRecvRSSI:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
    
}

- (void) didRetrievePeripheral:(NSArray *)peripherals
{
    
}

- (void) didDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
    
}

- (void) didDiscoverPeripheralAndName:(CBPeripheral *)peripheral DevName:(NSString *)devName
{
    NSLog(@"发现蓝牙");
    if (peripheral) {
        self.myPeripheral = peripheral;
        if (devName) {
            self.deviceName = devName;
        }else
        {
            self.deviceName = @"打印机";
        }
    }else
    {
        self.deviceName = nil;
        self.myPeripheral = nil;
    }
    if (self.myPeripheral) {
//        [self.uartLib scanStop];
        [self.delegate didDiscoverBluetooth];
    }
}



@end
