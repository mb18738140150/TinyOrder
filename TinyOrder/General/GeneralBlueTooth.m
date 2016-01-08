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
//    NSLog(@"******自动打印****%@*******", string);
    [self PrintWithFormat:string];
}

- (void)printWithArray:(NSMutableArray *)array
{
    
    NSString * str = [array firstObject];
//    NSLog(@"******自动打印****%@*******", array);
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

#pragma mark - 打印图片
- (void)printPng:(id)sender{
//    UIImage *printPng = (UIImage *)sender;
    
//    [self png2GrayscaleImage:printPng];
    
    NSString * printContent = (NSString *)sender;
    
        Byte caPrintCmd[500];
        
        caPrintCmd[0] = 0x1b;
        caPrintCmd[1] = 0x40;
        
        //设置二维码到宽度
        caPrintCmd[2] = 0x1d;
        caPrintCmd[3] = 0x77;
        caPrintCmd[4] = 5;
        NSData *cmdData =[[NSData alloc] initWithBytes:caPrintCmd length:5];
        NSLog(@"QR width:%@", cmdData);
        
        [self.uartLib sendValue:self.myPeripheral sendData:cmdData type:CBCharacteristicWriteWithResponse];
        
        NSInteger nLength = [printContent length];
        
        caPrintCmd[0] = 0x1d;
        caPrintCmd[1] = 0x6b;
        caPrintCmd[2] = 97;
        caPrintCmd[3] = 0x00;
        caPrintCmd[4] = 0x02;
        caPrintCmd[5] = nLength & 0xFF;;
        caPrintCmd[6] = (nLength >> 8) & 0xFF;
        
        
//        NSData *printData = [printContent dataUsingEncoding: NSASCIIStringEncoding];
//        Byte *printByte = (Byte *)[printData bytes];
        Byte * printByte = [printContent UTF8String];
//        NSLog(@"nLength = %d", nLength);
    
        for (int  i = 0; i<nLength; i++) {
//            NSLog(@"*****%d\n", printByte);
            caPrintCmd[7+i] = *(printByte+i);
        }
        
        
        cmdData =[[NSData alloc] initWithBytes:caPrintCmd length:7+nLength];
        NSLog(@"QR data:%@", cmdData);
        
        [self.uartLib sendValue:self.myPeripheral sendData:cmdData type:CBCharacteristicWriteWithResponse];
    
    
    
}

- (UIImage *) png2GrayscaleImage:(UIImage *) oriImage {
    //const int ALPHA = 0;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    int width = 192;//imageRect.size.width;
    int height =151;
    int imgSize = width * height;
    int x_origin = 0;
    int y_to = height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(imgSize * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, imgSize * sizeof(uint32_t));
    
    NSInteger nWidthByteSize = (width+7)/8;
    
    NSInteger nBinaryImgDataSize = nWidthByteSize * y_to;
    Byte *binaryImgData = (Byte *)malloc(nBinaryImgDataSize);
    
    memset(binaryImgData, 0, nBinaryImgDataSize);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [oriImage CGImage]);
    
    
    Byte controlData[8];
    controlData[0] = 0x1d;
    controlData[1] = 0x76;//'v';
    controlData[2] = 0x30;
    controlData[3] = 0;
    controlData[4] = nWidthByteSize & 0xff;
    controlData[5] = (nWidthByteSize>>8) & 0xff;
    controlData[6] = y_to & 0xff;
    controlData[7] = (y_to>>8) & 0xff;
    NSData *printData = [[NSData alloc] initWithBytes:controlData length:8];
    [self printData:printData];
    
    for(int y = 0; y < y_to; y++) {
        for(int x = x_origin; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            /*
             rgbaPixel[RED] = gray;
             rgbaPixel[GREEN] = gray;
             rgbaPixel[BLUE] = gray;
             */
            if (gray > 228) {
                rgbaPixel[RED] = 255;
                rgbaPixel[GREEN] = 255;
                rgbaPixel[BLUE] = 255;
                
            }else{
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
                binaryImgData[(y*width+x)/8] |= (0x80>>(x%8));
            }
        }
        
        
    }
    
    printData = [[NSData alloc] initWithBytes:binaryImgData length:nBinaryImgDataSize];
    [self printData:printData];
    
    memset(controlData, '\n', 8);
    printData = [[NSData alloc] initWithBytes:controlData length:3];
    [self printData:printData];
    
    
    return 0;
}


- (void) printData:(NSData *)dataPrinted {
#define MAX_CHARACTERISTIC_VALUE_SIZE 20
    NSData  *data	= nil;
    NSUInteger i;
    NSUInteger strLength;
    NSUInteger cellCount;
    NSUInteger cellMin;
    NSUInteger cellLen;
    
    NSLog(@"print data:%@", dataPrinted);
    
    
    strLength = [dataPrinted length];
    cellCount = (strLength%MAX_CHARACTERISTIC_VALUE_SIZE)?(strLength/MAX_CHARACTERISTIC_VALUE_SIZE + 1):(strLength/MAX_CHARACTERISTIC_VALUE_SIZE);
    
    for (i=0; i<cellCount; i++) {
        cellMin = i*MAX_CHARACTERISTIC_VALUE_SIZE;
        if (cellMin + MAX_CHARACTERISTIC_VALUE_SIZE > strLength) {
            cellLen = strLength-cellMin;
        }
        else {
            cellLen = MAX_CHARACTERISTIC_VALUE_SIZE;
        }
        
        NSLog(@"print:%lu,%lu,%lu,%lu", (unsigned long)strLength,(unsigned long)cellCount, (unsigned long)cellMin, (unsigned long)cellLen);
        NSRange rang = NSMakeRange(cellMin, cellLen);
        
        data = [dataPrinted subdataWithRange:rang];
        NSLog(@"print:%@", data);
        
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
    
    NSLog(@"发现数组%@", foundPeripherals);
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
    NSLog(@"%ld", self.myPeripheral.state);
}
- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"断开蓝牙");
    self.myPeripheral = nil;
//    NSLog(@"*********myPeripheral.state = %d", self.myPeripheral.state);
    self.deviceName = nil;
    [self.delegate didDisconnectBlutooth];
}

- (void) didReceiveData:(CBPeripheral *)peripheral recvData:(NSData *)recvData
{
    NSLog(@"接收数据%@", recvData);
}

- (void) didWriteData:(CBPeripheral *)peripheral error:(NSError *)error
{
//    NSLog(@"已经写入数据%@", error);
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
    if (peripheral) {
        self.myPeripheral = peripheral;
        if (RSSI) {
            self.deviceID = [RSSI stringValue];
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

- (void)didrecvCustom:(CBPeripheral *)peripheral CustomerRight:(bool)bRight
{
    
}

@end
