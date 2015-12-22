//
//  QRCode.h
//  TinyOrder
//
//  Created by 仙林 on 15/12/4.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCode : NSObject

+ (QRCode *)shareQRCode;
- (UIImage *)createQRCodeForString:(NSString *)qrString;

@end
