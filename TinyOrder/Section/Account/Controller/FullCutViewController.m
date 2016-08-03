//
//  FullCutViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/21.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "FullCutViewController.h"
#import "MenuActivityMD.h"
#import "TimeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NoActionFoodView.h"

#import "SetTimeView.h"

#define BUTTON_WIDHT ((_allMenusV.width - 4 * LEFT_SPACE) / 3)
#define BUTTON_HEIGHT 30
#define TOP_SPACE 15
#define LEFT_SPACE 15


@interface FullCutViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView *myScroView;

@property (nonatomic, strong)UITextField * mPriceTF;
@property (nonatomic, strong)UITextField * jPriceTF;
//@property (nonatomic, strong)UIImageView * isSeleteIMV;

@property (nonatomic, strong)UIScrollView * menusView;

@property (nonatomic, strong)UIView * allMenusV;
//@property (nonatomic, strong)UIView * selectMenuV;

// 所有菜品
@property (nonatomic, strong)NSMutableArray * dataArray;
// 选中菜品数组
@property (nonatomic, strong)NSMutableArray * selectArray;

// 选中菜品view数组
@property (nonatomic, strong)NSMutableArray *noActionFoodArray;

@property (nonatomic, strong)NSMutableDictionary * dateDic;

@property (nonatomic, strong)UIView *changeView;

@property (nonatomic, strong)SetTimeView *setTimeView;
@property (nonatomic, strong)UIView *timeModelView;
@property (nonatomic, strong)UIView *weekdayOrEndView;

@property (nonatomic, strong)UIDatePicker * datePicker;
@property (nonatomic, strong)UIView *pickerView;

@property (nonatomic, strong)NSNumber * hours;
@property (nonatomic, strong)UIScrollView * hoursView;

@property (nonatomic, strong)UILabel * tipLabel;
@property (nonatomic, strong)UILabel *tipLB;

@property (nonatomic, strong)UIButton *dateButton;
@property (nonatomic, strong)NSDate * startDate;
@property (nonatomic, strong)NSDate * stopDate;

@property (nonatomic, strong)NSNumber *tlimitType;
@property (nonatomic, strong)NSNumber *zoneTimeType;

@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIView * helpView;


@end

@implementation FullCutViewController


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        self.selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)noActionFoodArray
{
    if (!_noActionFoodArray) {
        self.noActionFoodArray = [NSMutableArray array];
    }
    return _noActionFoodArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.navigationItem.title = @"创建活动";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.myScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
    [self.view addSubview:_myScroView];
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    view1.backgroundColor = [UIColor whiteColor];
    [_myScroView addSubview:view1];
    
    UILabel * titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 25, 30)];
    titleLB.text = @"满";
    titleLB.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:titleLB];
    self.mPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(titleLB.right, titleLB.top, view1.width / 2 - 2 * LEFT_SPACE - 50, titleLB.height)];
    _mPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    _mPriceTF.borderStyle = UITextBorderStyleNone;
    _mPriceTF.textAlignment = NSTextAlignmentCenter;
    _mPriceTF.layer.borderColor = [[UIColor whiteColor]CGColor];
    [view1 addSubview:_mPriceTF];
    UILabel * mPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_mPriceTF.right, 15, 25, 30)];
    mPriceLB.text = @"元";
    mPriceLB.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:mPriceLB];
    
    UIView * mPline = [[UIView alloc]initWithFrame:CGRectMake(_mPriceTF.left, _mPriceTF.bottom, _mPriceTF.width, 1)];
    mPline.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [view1 addSubview:mPline];
    
    UIView *separateLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.width / 2, 0, 1, view1.height)];
    separateLine.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
    [view1 addSubview:separateLine];
    
    
    UILabel * jtitleLB = [[UILabel alloc] initWithFrame:CGRectMake(separateLine.right + 20, 15, 25, 30)];
    jtitleLB.text = @"减";
    jtitleLB.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:jtitleLB];
    self.jPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(jtitleLB.right, titleLB.top, _mPriceTF.width, titleLB.height)];
    _jPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    _jPriceTF.borderStyle = UITextBorderStyleNone;
    _jPriceTF.textAlignment = NSTextAlignmentCenter;
    _jPriceTF.layer.borderColor = [[UIColor whiteColor]CGColor];
    [view1 addSubview:_jPriceTF];
    UILabel * jPriceLB = [[UILabel alloc] initWithFrame:CGRectMake(_jPriceTF.right, 15, 25, 30)];
    jPriceLB.text = @"元";
    jPriceLB.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:jPriceLB];
    
    UIView * jPline = [[UIView alloc]initWithFrame:CGRectMake(_jPriceTF.left, _jPriceTF.bottom, _jPriceTF.width, 1)];
    jPline.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [view1 addSubview:jPline];
    
//    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, view1.height - 1, view1.width, 1)];
//    line.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
//    [view1 addSubview:line];
    
    
    self.changeView = [[UIView alloc]initWithFrame:CGRectMake(0, view1.bottom + 30, view1.width, view1.height)];
    _changeView.backgroundColor = [UIColor whiteColor];
    [_myScroView addSubview:_changeView];
    
    UIButton * changeMBT = [UIButton buttonWithType:UIButtonTypeCustom];
    changeMBT.frame = CGRectMake(0, 0, view1.width, view1.height);
    changeMBT.backgroundColor = [UIColor whiteColor];
    [changeMBT addTarget:self action:@selector(createMenusView:) forControlEvents:UIControlEventTouchUpInside];
    changeMBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    changeMBT.imageEdgeInsets = UIEdgeInsetsMake(0, changeMBT.width - 48, 0, 0);
    changeMBT.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [changeMBT setImage:[UIImage imageNamed:@"arrowDown.png"] forState:UIControlStateNormal];
    [changeMBT setTitle:@"选择不享受活动的菜" forState:UIControlStateNormal];
    changeMBT.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [changeMBT setImage:[UIImage imageNamed:@"arrowUp.png"] forState:UIControlStateSelected];
    [changeMBT setTitle:@"选择不享受活动的菜" forState:UIControlStateNormal];
    [changeMBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    changeMBT.titleEdgeInsets = UIEdgeInsetsMake(0, -28, 0, 0);
    [_changeView addSubview:changeMBT];
    
    UIButton * timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.tag = 12345;
    timeButton.frame = CGRectMake(0, _changeView.bottom + 30, changeMBT.width, changeMBT.height);
    timeButton.backgroundColor = [UIColor whiteColor];
    [timeButton setTitle:@"活动时间" forState:UIControlStateNormal];
    [timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    timeButton.titleLabel.numberOfLines = 0;
    timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    timeButton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [timeButton addTarget:self action:@selector(changeActivityTime:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.setTimeView = [[SetTimeView alloc]initWithFrame:CGRectMake(0, _changeView.bottom + 30, changeMBT.width, 60)];
    [_myScroView addSubview:_setTimeView];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _setTimeView.bottom + 60, self.view.width, 25)];
    _tipLabel.text = @"温馨 提示:";
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.textColor = [UIColor grayColor];
    _tipLabel.font = [UIFont systemFontOfSize:18];
    [_myScroView addSubview:_tipLabel];
    
    self.tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0, _tipLabel.bottom, self.view.width, 80)];
    _tipLB.backgroundColor = [UIColor clearColor];
    _tipLB.numberOfLines = 0;
    _tipLB.textColor = [UIColor blackColor];
    _tipLB.text = @"1.按区间设置活动时间,设置好区间后活动自动生成,超出时间后自动取消.\n2.按时段设置活动时间,设置好时段后,在时段活动内自动生效,超出该时段则不生效.";
    _tipLB.font = [UIFont systemFontOfSize:15];
    [_myScroView addSubview:_tipLB];
    
    
    [_setTimeView.modelButton addTarget:self action:@selector(activeModelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeModelView = [[UIView alloc]initWithFrame:CGRectMake(0, _setTimeView.top + _setTimeView.modelButton.height, _setTimeView.modelButton.width, _setTimeView.modelButton.height * 2)];
    _timeModelView.hidden = YES;
    self.timeModelView.backgroundColor = [UIColor whiteColor];
    
    UIView * linemodel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _timeModelView.width, 1)];
    linemodel.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_timeModelView addSubview:linemodel];
    UIButton * intervalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    intervalButton.frame = CGRectMake(0, linemodel.bottom, _timeModelView.width, 60);
    [intervalButton setTitle:@"按区间" forState:UIControlStateNormal];
    [intervalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [intervalButton addTarget:self action:@selector(intervalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_timeModelView addSubview:intervalButton];
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, intervalButton.bottom, intervalButton.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_timeModelView addSubview:line];
    UIButton * periodButton = [UIButton buttonWithType:UIButtonTypeSystem];
    periodButton.frame = CGRectMake(0, line.bottom, intervalButton.width, intervalButton.height);
    [periodButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [periodButton setTitle:@"按时段" forState:UIControlStateNormal];
    [periodButton addTarget:self action:@selector(periodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_timeModelView addSubview:periodButton];
    
    [_myScroView addSubview:_timeModelView];
    
    
    [self.setTimeView.starButton addTarget:self action:@selector(setStartOrStopTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    _setTimeView.starButton.tag = 10001;
    [self.setTimeView.stopButton addTarget:self action:@selector(setStartOrStopTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    _setTimeView.stopButton.tag = 10002;
    
    
    [_setTimeView.weekButton addTarget:self action:@selector(weekdayOrEndAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weekdayOrEndView = [[UIView alloc]initWithFrame:CGRectMake(_setTimeView.modelButton.right + 1, _setTimeView.top + _setTimeView.modelButton.height, self.view.width - _setTimeView.modelButton.width - 1, _setTimeView.modelButton.height * 2)];
    _weekdayOrEndView.hidden = YES;
    _weekdayOrEndView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineweek = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _weekdayOrEndView.width, 1)];
    lineweek.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_weekdayOrEndView addSubview:lineweek];
    UIButton * weekday = [UIButton buttonWithType:UIButtonTypeSystem];
    weekday.frame = CGRectMake(0, lineweek.bottom, _weekdayOrEndView.width, 60);
    [weekday setTitle:@"周一到周五" forState:UIControlStateNormal];
    [weekday setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weekday addTarget:self action:@selector(weekdayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_weekdayOrEndView addSubview:weekday];
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, weekday.bottom, weekday.width, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_weekdayOrEndView addSubview:line1];
    UIButton * weekend = [UIButton buttonWithType:UIButtonTypeSystem];
    weekend.frame = CGRectMake(0, line1.bottom, weekday.width, weekday.height);
    [weekend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weekend setTitle:@"周六,周日" forState:UIControlStateNormal];
    [weekend addTarget:self action:@selector(weekendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_weekdayOrEndView addSubview:weekend];
    
    [_myScroView addSubview:_weekdayOrEndView];
    
    [self.setTimeView.weekTimeButton addTarget:self action:@selector(setWeekTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    createButton.frame = CGRectMake(15, timeButton.bottom + 40, self.view.width - 30, 40);
//    createButton.backgroundColor = [UIColor orangeColor];
//    createButton.layer.cornerRadius = 5;
//    [createButton setTitle:@"生产活动" forState:UIControlStateNormal];
//    [createButton addTarget:self action:@selector(createActivity:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:createButton];
    
    
    self.menusView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _changeView.bottom, self.view.width, 120)];
    
    _menusView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];

    
//    self.selectMenuV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menusView.width, 1)];
//    _selectMenuV.backgroundColor = [UIColor whiteColor];
//    [_menusView addSubview:_selectMenuV];
    
    
    self.allMenusV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _menusView.width, 10)];
    _allMenusV.backgroundColor = [UIColor whiteColor];
    [_menusView addSubview:_allMenusV];
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@31,
                               @"Type":@(self.actionSort),
                               };
    [self playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"更新数据..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    
    
    self.hoursView = [[UIScrollView alloc] initWithFrame:CGRectMake(_setTimeView.left, 0, _setTimeView.width, 30)];
    _hoursView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _hoursView.layer.borderWidth = 1;
    _hoursView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 1; i < 25; i++) {
        UIButton * hoursBT = [UIButton buttonWithType:UIButtonTypeCustom];
        hoursBT.frame = CGRectMake((i - 1) * 30, 0, 30, 30);
        hoursBT.tag = 9000 + i;
        [hoursBT addTarget:self action:@selector(selectHours:) forControlEvents:UIControlEventTouchUpInside];
        if (i < 10) {
            [hoursBT setTitle:[NSString stringWithFormat:@"0%d", i] forState:UIControlStateNormal];
        }else
        {
            [hoursBT setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        }
        [hoursBT setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
        [_hoursView addSubview:hoursBT];
        _hoursView.contentSize = CGSizeMake(hoursBT.right, _hoursView.height);
    }
    
    [self createDatePickerView];
    self.tlimitType = @1;
    self.zoneTimeType = @1;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOusideRemoveHoursView)];
    [self.view addGestureRecognizer:tapGesture];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(createActivity:)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    self.myScroView.contentSize = CGSizeMake(self.view.width, _tipLB.bottom);
    
    self.helpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 60)];
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createMenusView:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [self.myScroView addSubview:_menusView];
    }else
    {
        [_menusView removeFromSuperview];
    }
//    NSLog(@"加载商品列表");
}

#pragma mark - 废弃方法
- (void)changeActivityTime:(UIButton *)button
{
    NSLog(@"设置时间");
    __weak FullCutViewController * fullCutVC = self;
    TimeViewController * timeVC = [[TimeViewController alloc] init];
    [timeVC returnDate:^(NSDictionary *dateDic) {
        NSLog(@"%@", dateDic);
        fullCutVC.dateDic = dateDic;
        if ([[dateDic objectForKey:@"TlimitType"] isEqualToNumber:@1]) {
            NSString * string = [NSString stringWithFormat:@"%@ \n开始时间%@   结束时间%@", button.currentTitle, [dateDic objectForKey:@"StartDate"], [dateDic objectForKey:@"EndDate"]];
//            [button setTitle:string forState:UIControlStateNormal];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, str.length - 4)];
            [button setAttributedTitle:str forState:UIControlStateNormal];
        }else if ([[dateDic objectForKey:@"TlimitType"] isEqualToNumber:@2])
        {
            NSMutableString * string = [NSMutableString stringWithFormat:@"%@ \n", button.currentTitle];
            if ([[dateDic objectForKey:@"ZoneTimeType"] isEqualToNumber:@1]) {
                [string appendFormat:@"周一到周五 %@点前", [dateDic objectForKey:@"Time"]];
            }else
            {
                [string appendFormat:@"周六、周日 %@点前", [dateDic objectForKey:@"Time"]];
            }
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, str.length - 4)];
            [button setAttributedTitle:str forState:UIControlStateNormal];
        }
    }];
    [self.navigationController pushViewController:timeVC animated:YES];
}

#pragma mark - 生产活动
- (void)createActivity:(UIButton *)button
{
    NSLog(@"生产活动");
    
    if (self.jPriceTF.text.length != 0 && self.mPriceTF.text.length != 0 ) {
        NSDictionary * jsonDic = nil;
        NSMutableArray * menusArray = [NSMutableArray array];
        for (MenuActivityMD * menu in self.selectArray) {
            [menusArray addObject:menu.mealId];
        }
        
        NSMutableArray * arrar2 = [NSMutableArray array];
        
        NSComparisonResult (^compareBlock)(id, id) = ^NSComparisonResult(id obj1, id obj2){
            
            return [obj1 compare:obj2];
        };
        
        arrar2 = [[menusArray sortedArrayUsingComparator:compareBlock] mutableCopy];
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * startString = [dateFormatter stringFromDate:self.startDate];
        NSString * stopString = [dateFormatter stringFromDate:self.stopDate];
        if ([self.tlimitType isEqualToNumber:@1]) {
            
            if (startString.length == 0) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择活动开始时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }else if (stopString.length == 0)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择活动结束时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }else
            {
                
                jsonDic = @{
                            @"Command":@30,
                            @"UserId":[UserInfo shareUserInfo].userId,
                            @"ActionSort":@(self.actionSort),
                            @"ActionType":@1,
                            @"ReduceMoney":[NSNumber numberWithDouble:[self.jPriceTF.text doubleValue]],
                            @"FullMoney":[NSNumber numberWithDouble:[self.mPriceTF.text doubleValue]],
                            @"TlimitType":self.tlimitType,
                            @"StartDate":startString,
                            @"EndDate":stopString,
                            @"ZoneTimeType":@0,
                            @"Time":@0,
                            @"FoodList":arrar2
                            };
                [self playPostWithDictionary:jsonDic];
                
            }
            
        }else if ([self.tlimitType isEqualToNumber:@2])
        {

            if (!self.hours) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择活动时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }else
            {
            
            jsonDic = @{
                        @"Command":@30,
                        @"UserId":[UserInfo shareUserInfo].userId,
                        @"ActionSort":@(self.actionSort),
                        @"ActionType":@1,
                        @"ReduceMoney":[NSNumber numberWithDouble:[self.jPriceTF.text doubleValue]],
                        @"FullMoney":[NSNumber numberWithDouble:[self.mPriceTF.text doubleValue]],
                        @"TlimitType":self.tlimitType,
                        @"StartDate":@"",
                        @"EndDate":@"",
                        @"ZoneTimeType":self.zoneTimeType,
                        @"Time":self.hours,
                        @"FoodList":arrar2
                        };
            [self playPostWithDictionary:jsonDic];
            }

        }

    }else if(self.jPriceTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入减免价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }else if (self.mPriceTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入满价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
    
}


#pragma mark - 数据请求


- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"--%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",  POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    NSLog(@"%@", data);
    if ([[data objectForKey:@"Result"] isEqualToNumber:@1]) {
        NSNumber * command = [data objectForKey:@"Command"];
        if ([command isEqualToNumber:@10031])
        {
            NSArray * array = [data objectForKey:@"FoodList"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary * dic in array) {
                    MenuActivityMD * menu = [[MenuActivityMD alloc] initWithDictionary:dic];
                    [self.dataArray addObject:menu];
                }
                [self addmenuButtonFromAllMenuView];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"暂无数据"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
            }
            
//            NSLog(@"array = %@", self.dataArray);
        }else if ([command isEqualToNumber:@10030])
        {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    //    AccountViewCell * cell = (AccountViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    cell.isBusinessSW.on = !cell.isBusinessSW.isOn;
    //    [self.tableView headerEndRefreshing];
//    if (error.code == -1009) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"网络不给力,请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }else
//    {
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
//    }
}

#pragma mark - 添加所有菜品view

- (void)addmenuButtonFromAllMenuView
{
    for (int i = 0; i < self.dataArray.count; i++) {
        CGFloat height = BUTTON_HEIGHT;
        MenuActivityMD * menu = [self.dataArray objectAtIndex:i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        int j = i % 3;
        int k = i / 3;
        button.frame = CGRectMake(LEFT_SPACE + j * (BUTTON_WIDHT + LEFT_SPACE), TOP_SPACE + (TOP_SPACE + BUTTON_HEIGHT) * k, BUTTON_WIDHT, height);
        button.tag = 1000 + i;
        button.layer.cornerRadius = 3;
        button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [button setTitle:menu.name forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(didchangeMenu:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [menu.name boundingRectWithSize:CGSizeMake(BUTTON_WIDHT, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] context:nil].size;
        if (size.height > button.height && size.height < button.height + TOP_SPACE) {
            button.height = size.height;
            height = size.height;
        }
        if (size.height > button.height + TOP_SPACE) {
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.height = button.height + 12;
        }
        [_allMenusV addSubview:button];
        _allMenusV.height = button.bottom + TOP_SPACE;
    }
    self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, 200);
    _menusView.contentSize = CGSizeMake(_menusView.width, _allMenusV.height );
}

#pragma mark - 加减不参加活动菜品
- (void)didchangeMenu:(UIButton *)button
{
    MenuActivityMD * menu = [self.dataArray objectAtIndex:button.tag - 1000];
//    NSLog(@"%@", menu.name);
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        [self.selectArray addObject:menu];
//        UIButton * selectBT = [UIButton buttonWithType:UIButtonTypeCustom];
//        int j = (self.selectArray.count - 1) % 3;
//        int k = (self.selectArray.count - 1) / 3;
//        selectBT.frame = CGRectMake(LEFT_SPACE + j * (BUTTON_WIDHT + LEFT_SPACE), TOP_SPACE + (TOP_SPACE + BUTTON_HEIGHT) * k, BUTTON_WIDHT, BUTTON_HEIGHT);
//        selectBT.tag = 2000 + (self.selectArray.count - 1);
//        selectBT.layer.cornerRadius = 3;
//        selectBT.backgroundColor = [UIColor orangeColor];
//        [selectBT setTitle:menu.foodName forState:UIControlStateNormal];
//        selectBT.titleLabel.numberOfLines = 0;
//        selectBT.titleLabel.font = [UIFont systemFontOfSize:14];
//        [self.selectMenuV addSubview:selectBT];
//        self.selectMenuV.height = selectBT.bottom + TOP_SPACE;
//        self.allMenusV.top = self.selectMenuV.bottom + 1;
//        self.menusView.contentSize = CGSizeMake(_menusView.width, _allMenusV.bottom);
        
        int i = -1;
        i = (_helpView.bottom - 60 ) / 40;
        
        
        NoActionFoodView * view = [[NoActionFoodView alloc]initWithFrame:CGRectMake(_helpView.right + LEFT_SPACE, 60, button.width, 30)];
        [view.deleteButton addTarget:self action:@selector(deleteNoActionFood:) forControlEvents:UIControlEventTouchUpInside];
        
        for (int j = 0; j<1000; j++) {
            if (j == i) {
                view.frame =CGRectMake(_helpView.right + LEFT_SPACE, 60 + 40 * j, button.width, 30);
            }
        }
        view.tag = button.tag;
        self.helpView.frame = view.frame;
        
        view.nameLabel.text = button.titleLabel.text;
        
        if (_helpView.right > self.view.width) {
            view.frame = CGRectMake(5 + LEFT_SPACE, _helpView.bottom + 10, button.width, 30);
            
            
            self.helpView.frame = view.frame;
            
        }
        
        view.transform = CGAffineTransformMakeScale(.1, .1);
        view.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            view.alpha = 1;
            view.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
        self.changeView.frame = CGRectMake(0, 91, self.view.width, _helpView.bottom + 10);
        
        [self.changeView addSubview:view];
        [self.noActionFoodArray addObject:view];
        
        self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, self.view.height - _changeView.bottom - self.navigationController.navigationBar.bottom);
        self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, 200);
        self.allMenusV.frame = CGRectMake(_menusView.frame.origin.x, 0, _menusView.width, self.allMenusV.height);
        
        self.setTimeView.frame = CGRectMake(0, _changeView.bottom + 30, _changeView.width, _setTimeView.height);
        
        self.timeModelView.frame = CGRectMake(0, _setTimeView.top + _setTimeView.modelButton.height, _setTimeView.modelButton.width, _setTimeView.modelButton.height * 2);
        
        self.weekdayOrEndView.frame = CGRectMake(_setTimeView.modelButton.right + 1, _setTimeView.top + _setTimeView.modelButton.height, self.view.width - _setTimeView.modelButton.width - 1, _setTimeView.modelButton.height * 2);
        
        self.tipLabel.frame = CGRectMake(0, _setTimeView.bottom + 60, self.view.width, 25);
        
        self.tipLB.frame = CGRectMake(0, _tipLabel.bottom, self.view.width, 80);
        
        self.myScroView.contentSize = CGSizeMake(self.view.width, _tipLB.bottom + 20);
        
        button.enabled = NO;
        
    }else
    {
        button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        UIButton * selectBT = (UIButton *)[self.selectMenuV viewWithTag:2000 + [self.selectArray indexOfObject:menu]];
//        [selectBT removeFromSuperview];
        [self.selectArray removeObject:menu];
        NSLog(@"*****");
    }
}

- (void)deleteNoActionFood:(UIButton *)button
{
    UIView *view = [button superview];
    
    UIButton *view2 = (UIButton *)[_allMenusV viewWithTag:view.tag];
    
    view2.enabled = YES;
    view2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    int i = -1;
    for (int j = 0;j < self.noActionFoodArray.count; j++) {
        NoActionFoodView *viewi = [self.noActionFoodArray objectAtIndex:j];
        if ([view isEqual:viewi]) {
            i = j;
            break;
        }
    }
    
    
    for (int k = self.noActionFoodArray.count - 1; k > i; k--) {
        NoActionFoodView *view1 = [self.noActionFoodArray objectAtIndex:k];
        NoActionFoodView * view2 = [self.noActionFoodArray objectAtIndex:k - 1];
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationDuration:1];
        view1.frame = view2.frame;
        [UIView commitAnimations];
    }
    [view removeFromSuperview];
    [self.noActionFoodArray removeObjectAtIndex:i];
    [self.selectArray removeObjectAtIndex:i];
    
    if (self.noActionFoodArray.count == 0) {
        _helpView.frame = CGRectMake(0, 0, 5, 60);
    }else
    {
        UIView *lastView = [self.noActionFoodArray lastObject];
        _helpView.frame = lastView.frame;

    }
    
    
    self.changeView.frame = CGRectMake(0, 91, self.view.width, _helpView.bottom + 10);
    
    self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, self.view.height - _changeView.bottom - self.navigationController.navigationBar.bottom);
    self.menusView.frame = CGRectMake(0, _changeView.bottom, self.view.width, 200);
    self.allMenusV.frame = CGRectMake(_menusView.frame.origin.x, 0, _menusView.width, self.allMenusV.height);
    
    
    self.setTimeView.frame = CGRectMake(0, _changeView.bottom + 30, _changeView.width, _setTimeView.height);
    self.timeModelView.frame = CGRectMake(0, _setTimeView.top + _setTimeView.modelButton.height, _setTimeView.modelButton.width, _setTimeView.modelButton.height * 2);
    self.weekdayOrEndView.frame = CGRectMake(_setTimeView.modelButton.right + 1, _setTimeView.top + _setTimeView.modelButton.height , self.view.width - _setTimeView.modelButton.width - 1, _setTimeView.modelButton.height * 2);
    self.tipLabel.frame = CGRectMake(0, _setTimeView.bottom + 60, self.view.width, 25);
    
    self.tipLB.frame = CGRectMake(0, _tipLabel.bottom, self.view.width, 60);

    
    self.myScroView.contentSize = CGSizeMake(self.view.width, _tipLB.bottom);

    
    
}

#pragma mark - 设置活动时间
- (void)activeModelAction:(UIButton *)button
{
//    self.timeModelView.hidden = NO;
//    [_setTimeView.modelButton setImage:[[UIImage imageNamed:@"unfold.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    if ([button.imageView.image isEqual:[UIImage imageNamed:@"unfold.png"]]) {
        self.timeModelView.hidden = YES;
        [_setTimeView.modelButton setImage:[[UIImage imageNamed:@"flod.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else
    {
        self.timeModelView.hidden = NO;
        [_setTimeView.modelButton setImage:[[UIImage imageNamed:@"unfold.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    [self.hoursView removeFromSuperview];
}

- (void)intervalButtonAction:(UIButton *)button
{
    [_setTimeView.modelButton setTitle:@"按区间" forState:UIControlStateNormal];
    [_setTimeView.modelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_setTimeView.modelButton setImage:[[UIImage imageNamed:@"flod.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.timeModelView.hidden = YES;
    self.setTimeView.weekButton.hidden = YES;
    self.setTimeView.weekSeparateLine.hidden = YES;
    self.setTimeView.weekTimeButton.hidden = YES;
    self.setTimeView.starButton.hidden = NO;
    self.setTimeView.separateLine.hidden = NO;
    self.setTimeView.stopButton.hidden = NO;
    
    [self.hoursView removeFromSuperview];
    
    self.tlimitType = @1;
    
    self.setTimeView.frame = CGRectMake(0, _changeView.bottom + 30, _changeView.width, 60);
}

- (void)periodButtonAction:(UIButton *)button
{
    [_setTimeView.modelButton setTitle:@"按时段" forState:UIControlStateNormal];
    [_setTimeView.modelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_setTimeView.modelButton setImage:[[UIImage imageNamed:@"flod.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.timeModelView.hidden = YES;
    self.setTimeView.weekButton.hidden = NO;
    self.setTimeView.weekSeparateLine.hidden = NO;
    self.setTimeView.weekTimeButton.hidden = NO;
    self.setTimeView.starButton.hidden = YES;
    self.setTimeView.separateLine.hidden = YES;
    self.setTimeView.stopButton.hidden = YES;
    
    self.tlimitType = @2;
    
    self.setTimeView.frame = CGRectMake(0, _changeView.bottom + 30, _changeView.width, 121);
}

- (void)createDatePickerView
{
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    self.pickerView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _pickerView.backgroundColor = [UIColor colorWithWhite:.7 alpha:.5];
    [_pickerView addSubview:_datePicker];
    _datePicker.center = _pickerView.center;
    
    UIButton * dateBT = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBT.frame = CGRectMake(0, 5, 80, 30);
    dateBT.centerX = _datePicker.centerX;
    [dateBT setTitle:@"确定" forState:UIControlStateNormal];
    [dateBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateBT addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventTouchUpInside];
    dateBT.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    dateBT.layer.cornerRadius = 3;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, _pickerView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:dateBT];
    [_pickerView addSubview:view];
    
    
}

- (void)getDate:(UIButton *)button
{
    if (self.dateButton.tag == 10001) {
        self.startDate = self.datePicker.date;
    }else if (self.dateButton.tag == 10002)
    {
        self.stopDate = self.datePicker.date;
    }
    
    [self.pickerView removeFromSuperview];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
    [self.dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setStartOrStopTimeAction:(UIButton *)button
{
    
    self.dateButton = button;
    if (button.tag == 10002 & self.startDate != nil) {
        self.datePicker.minimumDate = self.startDate;
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }else if (button.tag == 10002 & self.startDate == nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }else if (button.tag == 10001 & self.stopDate != nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = self.stopDate;
    }else if (button.tag == 10001 & self.stopDate == nil)
    {
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:1000000000];
    }
    [self.view.window addSubview:_pickerView];
    
}


- (void)weekdayOrEndAction:(UIButton *)button
{
    self.weekdayOrEndView.hidden = NO;
    [self.hoursView removeFromSuperview];
    
}

- (void)weekdayButtonAction:(UIButton *)button
{
    [self.setTimeView.weekButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    self.weekdayOrEndView.hidden = YES;
    self.zoneTimeType = @1;
    
}

- (void)weekendButtonAction:(UIButton *)button
{
    [self.setTimeView.weekButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    self.weekdayOrEndView.hidden = YES;
    self.zoneTimeType = @2;
}

- (void)setWeekTimeAction:(UIButton *)button
{
//    button.selected = !button.selected;
//    if (button.selected) {
        SetTimeView * weekV = (SetTimeView *)button.superview;
        _hoursView.top = button.bottom + weekV.top;
        [_myScroView addSubview:_hoursView];
//    }else
//    {
//        [_hoursView removeFromSuperview];
//    }
}

- (void)selectHours:(UIButton *)button
{
    [_hoursView removeFromSuperview];
    self.hours = [NSNumber numberWithInteger:button.tag - 9000];
        [self.setTimeView.weekTimeButton setTitle:[NSString stringWithFormat:@"%d点之前可以参与活动", button.tag - 9000] forState:UIControlStateNormal];
    [self.setTimeView.weekTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

- (void)tapOusideRemoveHoursView
{
    [self.hoursView removeFromSuperview];
    
//    [self.weekdayOrEndView removeFromSuperview];
//    
//    [self.timeModelView removeFromSuperview];
//    [_setTimeView.modelButton setImage:[[UIImage imageNamed:@"flod.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
