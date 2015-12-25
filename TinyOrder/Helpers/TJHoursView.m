//
//  TJHoursView.m
//  picker
//
//  Created by 仙林 on 15/8/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TJHoursView.h"
#import "UIViewAdditions.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


@interface TJHoursView ()<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong)UIPickerView * pickerView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * minArray;
@property (nonatomic, copy)SelectComplete selectBlock;

@end


@implementation TJHoursView

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)minArray
{
    if (!_minArray) {
        self.minArray = [NSMutableArray array];
    }
    return _minArray;
}

- (instancetype)initWithDataArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
        [self addGestureRecognizer:tapGesture];
        
        self.minArray = [NSMutableArray arrayWithObjects:@"00", @"15", @"30", @"45", nil];
        self.dataArray = [array mutableCopy];
        
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 300, self.width, 300)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, 40)];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.text = @"请选择时间";
        titleLB.backgroundColor = RGBCOLOR(21, 112, 182);
        [bottomView addSubview:titleLB];
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, titleLB.bottom, titleLB.width, 150)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [bottomView addSubview:_pickerView];
        
        UIButton * cancelBT = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBT.frame = CGRectMake(20, _pickerView.bottom, 100, 30);
        cancelBT.backgroundColor = RGBCOLOR(21, 112, 182);
        [cancelBT setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBT addTarget:self action:@selector(cancelChangeDate:) forControlEvents:UIControlEventTouchUpInside];
        cancelBT.layer.cornerRadius = 3;
        [bottomView addSubview:cancelBT];
        
        
        UIButton * finishBT = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBT.frame = CGRectMake(bottomView.width - 120, _pickerView.bottom, 100, 30);
        finishBT.backgroundColor = RGBCOLOR(21, 112, 182);
        [finishBT setTitle:@"确定" forState:UIControlStateNormal];
        [finishBT addTarget:self action:@selector(finishChangeDate:) forControlEvents:UIControlEventTouchUpInside];
        finishBT.layer.cornerRadius = 3;
        [bottomView addSubview:finishBT];
        
        bottomView.height = finishBT.bottom + 20;
        bottomView.top = self.height - bottomView.height;
        
    }
    return self;
}

- (void)finishChangeDate:(UIButton *)button
{
    NSString * date = [self.dataArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
    date = [NSString stringWithFormat:@"%@:%@", [self.dataArray objectAtIndex:[_pickerView selectedRowInComponent:0]], [self.minArray objectAtIndex:[_pickerView selectedRowInComponent:1]]];
    _selectBlock(date);
    [self removeFromSuperview];
}

- (void)cancelChangeDate:(UIButton *)button
{
    [self removeFromSuperview];
}

- (void)tapView
{
    [self removeFromSuperview];
}


- (void)finishSelectComplete:(SelectComplete)selectBlock
{
    _selectBlock = selectBlock;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 1) {
        return self.minArray.count;
    }
    return self.dataArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@点", [self.dataArray objectAtIndex:row]];
    }else
    {
        return [NSString stringWithFormat:@"%@分", [self.minArray objectAtIndex:row]];
    }
}


- (void)dealloc
{
    NSLog(@"销毁");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
