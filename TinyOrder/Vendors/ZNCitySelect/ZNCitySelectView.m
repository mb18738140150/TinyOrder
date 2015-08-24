//
//  ZNCitySelectView.m
//  CitySelector
//
//  Created by 开发_赵楠 on 15/6/8.
//  Copyright (c) 2015年 iOSMax. All rights reserved.
//

#import "ZNCitySelectView.h"

//RGB颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
@interface ZNCitySelectView ()<UIPickerViewDelegate, UIPickerViewDataSource>{
    CGFloat mainScreenWidth;
    CGFloat mainScreenHeight;
}

@property (nonatomic, strong) UIView *m_bcView;

@property (nonatomic, strong) NSDictionary *m_dataDic;

@property (nonatomic, strong) UILabel *m_titleLabel;

@property (nonatomic, strong) UIPickerView *m_pickerView;

@property (nonatomic, strong) NSArray *m_provinceArray;

@property (nonatomic, strong) NSArray *m_cityArray;

@property (nonatomic, strong) NSArray *m_areaArray;

@property (nonatomic, strong) NSDictionary *m_provinceDic;

@property (nonatomic, strong) NSDictionary *m_cityDic;

@property (nonatomic, strong) NSDictionary *m_areaDic;

@end

@implementation ZNCitySelectView

- (instancetype)init{
    if (self = [super init]) {
        mainScreenWidth = [[UIScreen mainScreen] bounds].size.width;
        mainScreenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        [self loadData];
    }
    return self;
}

/** 读取本地数据 */
- (void)loadData{
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"CityData.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:pathStr];
    
    self.m_dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (!self.m_dataDic)
        NSLog(@"读取本地数据失败");
    self.m_provinceArray = self.m_dataDic[@"province"];
    self.m_provinceDic = [self.m_provinceArray firstObject];
    
    self.m_cityArray = [self.m_dataDic[@"city"] objectForKey:self.m_provinceDic[@"code"]];
    
    self.m_cityDic = [self.m_cityArray firstObject];
    
    self.m_areaArray = [self.m_dataDic[@"area"] objectForKey:self.m_cityDic[@"code"]];
    
    self.m_areaDic = [self.m_areaArray firstObject];
    
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self initTopView];
    [self initPickerView];
}

- (void)initTopView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 50)];
    topView.backgroundColor = RGBCOLOR(21, 112, 182);
    
    [self addSubview:topView];
    
    self.m_titleLabel = [[UILabel alloc] initWithFrame:topView.bounds];
    self.m_titleLabel.text = @"选择所在区域";
    self.m_titleLabel.textColor = [UIColor whiteColor];
    self.m_titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.m_titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [topView addSubview:self.m_titleLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(CGRectGetWidth(topView.frame)-60, 0, 60, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:cancelBtn];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setFrame:CGRectMake(15, 300, mainScreenWidth-30, 40)];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.layer.cornerRadius = 5;
    completeBtn.layer.masksToBounds = true;
    completeBtn.backgroundColor = RGBCOLOR(21, 112, 182);
    
    [self addSubview:completeBtn];
}

- (void)initPickerView{
    
    self.m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.frame), 216)];
    self.m_pickerView.dataSource = self;
    self.m_pickerView.delegate = self;
    
    [self addSubview:self.m_pickerView];
    
    self.frame = CGRectMake(0, mainScreenHeight, mainScreenWidth, 350);
}

#pragma mark - PickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
        return [self.m_provinceArray count];
    
    if (component == 1)
        return [self.m_cityArray count];
    
    if (component == 2)
        return [self.m_areaArray count];
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0){
        NSDictionary *dic = self.m_provinceArray[row];
        return dic[@"name"];
    }
    
    if (component == 1){
        NSDictionary *dic = self.m_cityArray[row];
        return dic[@"name"];
    }
    
    if (component == 2){
        NSDictionary *dic = self.m_areaArray[row];
        return dic[@"name"];
    }
    
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = view ? (UILabel *)view : [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth/3, 30)];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSDictionary *dic;
    if (component == 0)
        dic = self.m_provinceArray[row];
    
    if (component == 1)
        dic = self.m_cityArray[row];

    if (component == 2)
        dic = self.m_areaArray[row];

    label.text = dic[@"name"];
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0){
        self.m_provinceDic = self.m_provinceArray[row];
        self.m_cityArray = [self.m_dataDic[@"city"] objectForKey:self.m_provinceDic[@"code"]];
        
        self.m_cityDic = [self.m_cityArray firstObject];
        
        self.m_areaArray = [self.m_dataDic[@"area"] objectForKey:self.m_cityDic[@"code"]];
        
        self.m_areaDic = [self.m_areaArray firstObject];
    }
    
    if (component == 1){
        self.m_cityDic = self.m_cityArray[row];
        self.m_areaArray = [self.m_dataDic[@"area"] objectForKey:self.m_cityDic[@"code"]];
        
        self.m_areaDic = [self.m_areaArray firstObject];
    }
    
    if (component == 2){
        self.m_areaDic = self.m_areaArray[row];
    }
    
    [self.m_pickerView reloadAllComponents];
}

#pragma mark - Action
- (void)cancelBtnClicked{//取消选择
    [self close];
}

- (void)completeBtnClicked{//选择完成
    if (self.m_selectComplete)
        self.m_selectComplete (self.m_provinceDic, self.m_cityDic, self.m_areaDic);
    
    [self close];
}

/** 展现 */
- (void)show{
    [self initView];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:true];
    UIViewController *topVC = [self appRootViewController];
    [topVC.view addSubview:self];
}

/** 关闭 */
- (void)close{
    [self removeFromSuperview];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    [self.m_bcView removeFromSuperview];
    self.m_bcView = nil;
    
    [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, mainScreenHeight, mainScreenWidth, 350);
        
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.m_bcView) {
        self.m_bcView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.m_bcView.backgroundColor = [UIColor blackColor];
        self.m_bcView.alpha = 0.6f;
        self.m_bcView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self.m_bcView addGestureRecognizer:tap];
    }
    
    [topVC.view addSubview:self.m_bcView];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, mainScreenHeight-350, mainScreenWidth, 350);
    }];
    
    
    [super willMoveToSuperview:newSuperview];
}


@end
