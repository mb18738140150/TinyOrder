//
//  BatchoperationView.h
//  TinyOrder
//
//  Created by 仙林 on 16/12/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AllOperationBlock)(int selectType);
typedef void(^DetailOperationBlock)(int detaileOperationType);

@interface BatchoperationView : UIView

@property (nonatomic, strong)UIButton * operationBT;
@property (nonatomic, strong)UIImageView * allSelectImageView;
@property (nonatomic, assign)int selectType;// 1.全选 0.不全选
- (instancetype)initWithFrame:(CGRect)frame batchOperationType:(int )operationType;
- (void)allOperationAction:(AllOperationBlock)block;
- (void)detaileOperation:(DetailOperationBlock)block;
@end
