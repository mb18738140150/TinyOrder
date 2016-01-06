//
//  QRCodeScanViewController.h
//  TinyOrder
//
//  Created by 仙林 on 16/1/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^ReturnDataBlock)(NSString * str);
@interface QRCodeScanViewController : UIViewController

- (void)returnData:(ReturnDataBlock)dataBlock;

@end
