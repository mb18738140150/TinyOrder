//
//  StatisticalReportsView.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/13.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "StatisticalReportsView.h"
#import "FMTagsView.h"
#import "MenuActivityMD.h"
#import "PayTypeCollectionViewCell.h"
#import "AppDelegate.h"
#import "WHUCalendarPopView.h"

#define ViewWidth [UIScreen mainScreen].bounds.size.width
#define ViewHeight [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kPayTypeCellID @"PayTypeCellID"
@interface StatisticalReportsView ()<FMTagsViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
{
    WHUCalendarPopView * _pop;
}

@property (nonatomic, strong)UIView * backView;

@property (strong, nonatomic) FMTagsView *tagsView;
@property (nonatomic, strong)UICollectionView * collectView;
@property (nonatomic, strong)UITextField * startDateTF;
@property (nonatomic, strong)UITextField * endDateTf;

@property (nonatomic, strong)NSArray * imageArray;
@property (nonatomic, strong)NSArray * nameArray;

@property (nonatomic, strong)NSMutableArray * payTypeArr;

@property (nonatomic, copy)ScreenValueBlock myScreenBlock;

@end

@implementation StatisticalReportsView
//- (void)setDataArray:(NSMutableArray *)dataArray
//{
//    self.dataArray = [dataArray mutableCopy];
//    for (MenuActivityMD * model in dataArray) {
//        [self.dataArray addObject:model];
//    }
//}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)selectsdArr
{
    if (!_selectsdArr) {
        self.selectsdArr = [NSMutableArray array];
    }
    return _selectsdArr;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self commonInit];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame DataArray:(NSMutableArray *)arr
{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = arr;
        [self commonInit];
    }
    return self;
}
- (void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    self.backView.backgroundColor = [UIColor colorWithWhite:.2 alpha:.4];
    [self addSubview:self.backView];
    
    UITapGestureRecognizer * removeViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissfromSuperView)];
    [self.backView addGestureRecognizer:removeViewTap];
    
    self.payTypeArr = [NSMutableArray array];
    
    self.imageArray = @[@"desIcon.png", @"desIcon.png", @"desIcon.png", @"desIcon.png", @"desIcon.png", @"desIcon.png", @"desIcon.png"];
    self.nameArray = @[@"微信", @"百度钱包", @"现金", @"优惠券", @"积分", @"优惠券积分", @"支付宝"];
    
    self.dataView = [[UIScrollView alloc]initWithFrame:CGRectMake(ViewWidth / 4, 0, ViewWidth - ViewWidth / 4, ViewHeight)];
    self.dataView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.dataView];
    
    UILabel * screenLB = [[UILabel alloc]initWithFrame:CGRectMake(16, 17, 34, 17)];
    screenLB.backgroundColor = [UIColor whiteColor];
    screenLB.text = @"筛选";
    screenLB.textColor = RGBCOLOR(50, 50, 50);
    [_dataView addSubview:screenLB];
    
    UILabel * statisticalTypeLB = [[UILabel alloc]initWithFrame:CGRectMake(16, 69, 60, 15)];
    statisticalTypeLB.backgroundColor = [UIColor whiteColor];
    statisticalTypeLB.textColor = RGBCOLOR(102, 102, 102);
    statisticalTypeLB.text = @"统计类型";
    statisticalTypeLB.font = [UIFont systemFontOfSize:15];
    [_dataView addSubview:statisticalTypeLB];
    
    self.tagsView = [[FMTagsView alloc]initWithFrame:CGRectMake(10, 90, _dataView.width - 20, 200)];
    [_dataView addSubview:self.tagsView];
    
    _tagsView.contentInserts = UIEdgeInsetsZero;
    _tagsView.tagInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _tagsView.tagBorderWidth = 1;
    _tagsView.tagcornerRadius = 2;
    _tagsView.tagBorderColor = [UIColor lightGrayColor];
    _tagsView.tagSelectedBorderColor = BACKGROUNDCOLOR;
    _tagsView.tagBackgroundColor = [UIColor whiteColor];
    _tagsView.lineSpacing = 10;
    _tagsView.interitemSpacing = 10;
    _tagsView.tagFont = [UIFont systemFontOfSize:14];
    _tagsView.tagTextColor = [UIColor grayColor];
    _tagsView.tagSelectedBackgroundColor = BACKGROUNDCOLOR;
    _tagsView.tagSelectedTextColor = [UIColor whiteColor];
    _tagsView.delegate = self;
    _tagsView.tagsArray = self.dataArray;
    
    UILabel * payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, _tagsView.bottom + 20, 60, 15)];
    payTypeLabel.backgroundColor = [UIColor whiteColor];
    payTypeLabel.textColor = RGBCOLOR(102, 102, 102);
    payTypeLabel.text = @"支付方式";
    payTypeLabel.font = [UIFont systemFontOfSize:15];
    [_dataView addSubview:payTypeLabel];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(_dataView.width / 3, _dataView.width / 3);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 设置item之间的最小距离
    layout.minimumInteritemSpacing = 0;
    
    // 设置行之间的最小间距
    layout.minimumLineSpacing = 0;
    // 设置分区页眉（header）大小
    layout.headerReferenceSize = CGSizeMake(_dataView.width, 0);
    
    // 设置分区页脚（footer）大小
    layout.footerReferenceSize = CGSizeMake(_dataView.width, 0);
    
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, payTypeLabel.bottom + 1, _dataView.width, _dataView.width) collectionViewLayout:layout];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.collectView registerClass:[PayTypeCollectionViewCell class] forCellWithReuseIdentifier:kPayTypeCellID];
    [_dataView addSubview:self.collectView];
    
    
    UILabel * timeScreenLB = [[UILabel alloc]initWithFrame:CGRectMake(16, _collectView.bottom + 20, 60, 15)];
    timeScreenLB.backgroundColor = [UIColor whiteColor];
    timeScreenLB.textColor = RGBCOLOR(102, 102, 102);
    timeScreenLB.text = @"时间筛选";
    timeScreenLB.font = [UIFont systemFontOfSize:15];
    [_dataView addSubview:timeScreenLB];
    
    self.startDateTF = [[UITextField alloc]initWithFrame:CGRectMake(10, timeScreenLB.bottom + 10, (_dataView.width - 40 )/ 2, 30)];
    _startDateTF.textAlignment = NSTextAlignmentCenter;
    _startDateTF.placeholder = @"开始日期";
    _startDateTF.font = [UIFont systemFontOfSize:13];
    _startDateTF.textColor = RGBCOLOR(204, 204, 204);
    _startDateTF.borderStyle = UITextBorderStyleNone;
    _startDateTF.layer.cornerRadius = 5;
    _startDateTF.layer.borderWidth = 1;
    _startDateTF.layer.borderColor = (RGBCOLOR(230, 230, 230)).CGColor;
    [_dataView addSubview:_startDateTF];
    _startDateTF.delegate = self;
    
    UIView * linView = [[UIView alloc]initWithFrame:CGRectMake(_startDateTF.right + 5, _startDateTF.top + 15, 10, 1)];
    linView.backgroundColor = RGBCOLOR(230, 230, 230);
    [_dataView addSubview:linView];
    
    self.endDateTf = [[UITextField alloc]initWithFrame:CGRectMake(linView.right + 5, timeScreenLB.bottom + 10, (_dataView.width - 40 )/ 2, 30)];
    _endDateTf.textAlignment = NSTextAlignmentCenter;
    _endDateTf.placeholder = @"结束日期";
    _endDateTf.font = [UIFont systemFontOfSize:13];
    _endDateTf.textColor = RGBCOLOR(204, 204, 204);
    _endDateTf.borderStyle = UITextBorderStyleNone;
    _endDateTf.layer.cornerRadius = 5;
    _endDateTf.layer.borderWidth = 1;
    _endDateTf.layer.borderColor = (RGBCOLOR(230, 230, 230)).CGColor;
    [_dataView addSubview:_endDateTf];
    _endDateTf.delegate = self;
    
    
    self.searchBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBT.frame = CGRectMake((_dataView.width - 100) / 2, timeScreenLB.bottom + 90, 100, 36);
    _searchBT.backgroundColor = BACKGROUNDCOLOR;
    _searchBT.layer.cornerRadius = 5;
    _searchBT.layer.masksToBounds = YES;
    [_searchBT setTitle:@"查询" forState:UIControlStateNormal];
    [_searchBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dataView addSubview:_searchBT];
    [_searchBT addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchUpInside];
    _dataView.contentSize = CGSizeMake(_dataView.width, _searchBT.bottom + 30);
    
}

#pragma mark - FMTagsViewDelegate

- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
    [self.selectsdArr addObject:[self.dataArray objectAtIndex:index]];
    
//    for (MenuActivityMD * model in self.selectsdArr) {
//        NSLog(@"**name = %@", model.mealId);
//    }
}

- (void)tagsView:(FMTagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index
{
    for (NSInteger idx = 0; idx < self.selectsdArr.count; idx++) {
        MenuActivityMD * selModel = [self.selectsdArr objectAtIndex:idx];
        MenuActivityMD * model = [self.dataArray objectAtIndex:index];
        
        if ([selModel.mealId isEqualToNumber:model.mealId]) {
            [self.selectsdArr removeObject:selModel];
            break;
        }
        
    }
    
//    for (MenuActivityMD * model in self.selectsdArr) {
//        NSLog(@"**name = %@", model.mealId);
//    }
}

#pragma mark - uicollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PayTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPayTypeCellID forIndexPath:indexPath];
    [cell createSubview];
    cell.backImageview.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    cell.nameLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PayTypeCollectionViewCell * cell = (PayTypeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell.backView.hidden) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.backImageview.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.backgroundColor = [UIColor whiteColor];;
        cell.backView.hidden = YES;
        cell.selected = NO;
//        for (int i = 0; i < self.payTypeArr.count; i++) {
//            if ([[self.payTypeArr objectAtIndex:i] isEqualToString:cell.nameLabel.text]) {
                if (indexPath.row == 6) {
                    [self.payTypeArr removeObject:@(20)];
                }else
                {
                    [self.payTypeArr removeObject:@(indexPath.row + 1)];
                }
        
    }else
    {
        cell.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
        cell.backImageview.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
        cell.nameLabel.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];;
        cell.backView.hidden = NO;
        cell.selected = YES;
        if (indexPath.row == 6) {
            [self.payTypeArr addObject:@(20)];
        }else
        {
            [self.payTypeArr addObject:@(indexPath.row + 1)];
        }
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_dataView.width / 3, _dataView.width / 3);
}

#pragma mark - UItextfiled Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"显示日历");
    _pop = [[WHUCalendarPopView alloc]init];
    _pop.frame = CGRectMake(0, 0, self.width, self.height);
    
    
    [self addSubview:_pop];
    [_pop show];
    
    __weak StatisticalReportsView * printVC = self;
    _pop.onDateSelectBlk = ^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [format stringFromDate:date];
        textField.text = dateString;
//        NSLog(@"%@",dateString);
    };
    return NO;
}

#pragma mark - 查询
- (void)screenAction:(UIButton *)button
{
    if (self.startDateTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择开始日期" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    }else if (self.endDateTf.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束日期" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
    }else
    {
    
        NSMutableArray * mealidsArr = [NSMutableArray array];
        for (MenuActivityMD * model in self.selectsdArr) {
            [mealidsArr addObject:model.mealId];
        }
        
        NSDictionary * dic = @{
                               @"Mealids":mealidsArr,
                               @"PayTypes":self.payTypeArr,
                               @"StartDate":self.startDateTF.text,
                               @"EndDate":self.endDateTf.text
                               };
        _myScreenBlock(dic);
        [self dismissfromSuperView];
    }
    
}

- (void)showinSuperView
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    self.dataView.frame = CGRectMake(ViewWidth, 0, ViewWidth - ViewWidth / 4, ViewHeight);
    
    [delegate.window addSubview:self];
    
    __block StatisticalReportsView * staView = self;
    [UIView animateWithDuration:.5 animations:^{
        staView.dataView.frame = CGRectMake(ViewWidth / 4, 0, ViewWidth - ViewWidth / 4, ViewHeight);
    }];
    
}
- (void)dismissfromSuperView
{
    [self removeFromSuperview];
}

- (void)screenWithDic:(ScreenValueBlock)screenBlock
{
    self.myScreenBlock = [screenBlock copy];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
