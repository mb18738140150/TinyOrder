//
//  TimeViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/7/22.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "TimeViewController.h"
#import "WeekView.h"

@interface TimeViewController ()

@property (nonatomic, copy)ReturnDateDicBlock returnDate;

@property (nonatomic, strong)UILabel * interpretLB;
@property (nonatomic, strong)WeekView * weekdayView;
@property (nonatomic, strong)WeekView * weekendView;

@property (nonatomic, strong)UIDatePicker * datePicker;
@property (nonatomic, strong)UIView * pickerView;

@property (nonatomic, strong)UIScrollView * hoursView;

@property (nonatomic, strong)UIButton * dateButton;

@property (nonatomic, strong)NSDate * startDate;
@property (nonatomic, strong)NSDate * stopDate;

@property (nonatomic, strong)NSNumber * hours;

@property (nonatomic, strong)NSNumber * tlimitType;

@property (nonatomic, strong)NSNumber * zoneTimeType;

@end

@implementation TimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动时间设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray * array = @[[[UIImage imageNamed:@"leftbg_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal], [[UIImage imageNamed:@"rightbg_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.tlimitType = @1;
    self.zoneTimeType = @1;
    UISegmentedControl * segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.frame = CGRectMake(10, 20, 180, 28);
    segment.centerX = self.view.width / 2;
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor colorWithRed:208 / 255.0 green:208 / 255.0 blue:208 / 255.0 alpha:0.7];
    [segment addTarget:self action:@selector(changeTimeType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    
    
    self.interpretLB = [[UILabel alloc] initWithFrame:CGRectMake(10, segment.bottom + 15, segment.width + 60, 60)];
    _interpretLB.centerX = segment.centerX;
    _interpretLB.text = @"设置好区间后活动自动生成, 超出时间活动自动取消。";
    _interpretLB.textAlignment = NSTextAlignmentCenter;
    _interpretLB.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    _interpretLB.font = [UIFont systemFontOfSize:14];
    _interpretLB.numberOfLines = 0;
    [self.view addSubview:_interpretLB];
    
    
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, _interpretLB.bottom + 10, self.view.width, 150)];
    view1.tag = 3000;
    [self.view addSubview:view1];
    
    UILabel * startLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 20)];
    startLB.text = @"开始时间";
    startLB.textAlignment = NSTextAlignmentCenter;
    startLB.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    startLB.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:startLB];
    
    UIButton * startBT = [UIButton buttonWithType:UIButtonTypeCustom];
    startBT.frame = CGRectMake(startLB.right, startLB.top, 80, startLB.height);
    startBT.layer.cornerRadius = 3;
    startBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    startBT.layer.borderWidth = 1;
    startBT.titleLabel.font = [UIFont systemFontOfSize:14];
    startBT.tag = 10001;
    [startBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [startBT setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [view1 addSubview:startBT];
    
    UILabel * stopLB = [[UILabel alloc] initWithFrame:CGRectMake(startBT.right + 10, startLB.top, 60, startLB.height)];
    stopLB.text = @"结束时间";
    stopLB.textAlignment = NSTextAlignmentCenter;
    stopLB.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    stopLB.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:stopLB];
    
    UIButton * stopBT = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBT.frame = CGRectMake(stopLB.right, startLB.top, 80, startLB.height);
    stopBT.layer.cornerRadius = 3;
    stopBT.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    stopBT.layer.borderWidth = 1;
    stopBT.titleLabel.font = [UIFont systemFontOfSize:14];
    stopBT.tag = 10002;
    [stopBT addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [stopBT setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    [view1 addSubview:stopBT];
    
    
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(0, _interpretLB.bottom + 10, self.view.width, 150)];
    view2.tag = 4000;
    view2.hidden = YES;
    [self.view addSubview:view2];
    
    self.weekdayView = [[WeekView alloc] initWithFrame:CGRectMake(0, 0, view2.width, 54)];
    [_weekdayView.changeBT addTarget:self action:@selector(weekChange:) forControlEvents:UIControlEventTouchUpInside];
    [_weekdayView.timeBT addTarget:self action:@selector(changeHours:) forControlEvents:UIControlEventTouchUpInside];
    _weekdayView.changeBT.selected = YES;
    [view2 addSubview:_weekdayView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _weekdayView.bottom, view2.width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [view2 addSubview:line];
    
    self.weekendView = [[WeekView alloc] initWithFrame:CGRectMake(0, line.bottom, view2.width, 54)];
    [_weekendView.changeBT setTitle:@"周六、周日" forState:UIControlStateNormal];
    [_weekendView hidenRightView:YES];
    [_weekendView.changeBT addTarget:self action:@selector(weekChange:) forControlEvents:UIControlEventTouchUpInside];
    [_weekendView.timeBT addTarget:self action:@selector(changeHours:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:_weekendView];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(20, view2.bottom + 20, self.view.width - 40, 40);
    saveButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    saveButton.layer.cornerRadius = 5;
    [saveButton setTitle:@"保存设置" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    
    self.hoursView = [[UIScrollView alloc] initWithFrame:CGRectMake(_weekdayView.timeBT.left, 0, self.weekdayView.timeBT.width, 200)];
    _hoursView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _hoursView.layer.borderWidth = 1;
    _hoursView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 1; i < 25; i++) {
        UIButton * hoursBT = [UIButton buttonWithType:UIButtonTypeCustom];
        hoursBT.frame = CGRectMake(0, (i - 1) * 20, _hoursView.width, 20);
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
        _hoursView.contentSize = CGSizeMake(_hoursView.width, hoursBT.bottom);
    }
    
    
    
    [self createDatePickerView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOusideRemoveHoursView)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    // Do any additional setup after loading the view.
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveDate:(UIButton *)button
{
    if ([self.tlimitType isEqualToNumber:@1]) {
        if (self.startDate != nil && self.stopDate != nil) {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterFullStyle];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString * startString = [dateFormatter stringFromDate:self.startDate];
            NSString * stopString = [dateFormatter stringFromDate:self.stopDate];
            NSDictionary * dateDic = @{
                                       @"TlimitType":self.tlimitType,
                                       @"StartDate":startString,
                                       @"EndDate":stopString
                                       };
            _returnDate(dateDic);
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.startDate == nil)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择开始时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }else if (self.stopDate == nil)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
    }else
    {
        if (self.hours != nil) {
            NSDictionary * dateDic = @{
                                       @"TlimitType":self.tlimitType,
                                       @"ZoneTimeType":self.zoneTimeType,
                                       @"Time":self.hours
                                       };
            _returnDate(dateDic);
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择时段" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:2];
        }
    }
}


- (void)createDatePickerView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+8"]];
    //    [_datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    //    [_datePicker setDate:[NSDate date] animated:YES];
    [_datePicker setMinimumDate:[NSDate date]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    self.pickerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _pickerView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    [_pickerView addSubview:_datePicker];
    _datePicker.center = _pickerView.center;
    
    UIButton * dateBT = [UIButton buttonWithType:UIButtonTypeCustom];
    dateBT.frame = CGRectMake(0, 5, 80, 30);
    dateBT.centerX = _datePicker.centerX;
    [dateBT setTitle:@"确定" forState:UIControlStateNormal];
    [dateBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateBT addTarget:self action:@selector(getDate:) forControlEvents:UIControlEventTouchUpInside];
    dateBT.backgroundColor = [UIColor orangeColor];
    dateBT.layer.cornerRadius = 3;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, _datePicker.bottom, _pickerView.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:dateBT];
    [_pickerView addSubview:view];
}

- (void)changeDate:(UIButton *)button
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
    NSLog(@"时间");
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
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    [self.dateButton setTitle:dateString forState:UIControlStateNormal];
//    [self.dateButton setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
//        NSLog(@"%@", _dateButton);
//        _dateButton.backgroundColor = [UIColor redColor];
    NSLog(@"%@", dateString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTimeType:(UISegmentedControl *)segment
{
    UIView * view1 = [self.view viewWithTag:3000];
    UIView * view2 = [self.view viewWithTag:4000];
    if (segment.selectedSegmentIndex) {
        [segment setImage:[[UIImage imageNamed:@"leftbg_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [segment setImage:[[UIImage imageNamed:@"rightbg_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        _interpretLB.text = @"设置好时段后, 在时段内活动自动生效, 超出该时段不生效。";
        view1.hidden = YES;
        view2.hidden = NO;
        self.tlimitType = @2;
    }else
    {
        [segment setImage:[[UIImage imageNamed:@"leftbg_s.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [segment setImage:[[UIImage imageNamed:@"rightbg_n.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        _interpretLB.text = @"设置好区间后活动自动生成, 超出时间活动自动取消。";
        view2.hidden = YES;
        view1.hidden = NO;
        self.tlimitType = @1;
    }
}


- (void)weekChange:(UIButton *)button
{
    if (!button.selected) {
        button.selected = !button.selected;
        self.hours = nil;
        if ([button isEqual:self.weekdayView.changeBT]) {
            [self.weekdayView hidenRightView:NO];
            [self.weekendView hidenRightView:YES];
            self.zoneTimeType = @1;
//            self.weekendView.changeBT.selected = NO;
        }else
        {
            [self.weekdayView hidenRightView:YES];
            [self.weekendView hidenRightView:NO];
            self.zoneTimeType = @2;
//            self.weekdayView.changeBT.selected = NO;
        }
    }
}


- (void)changeHours:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        WeekView * weekV = (WeekView *)button.superview;
        UIView * view2 = weekV.superview;
        _hoursView.top = view2.top + button.bottom + weekV.top;
        [self.view addSubview:_hoursView];
    }else
    {
        [_hoursView removeFromSuperview];
    }
}


- (void)tapOusideRemoveHoursView
{
    [self.hoursView removeFromSuperview];
}


- (void)selectHours:(UIButton *)button
{
    [_hoursView removeFromSuperview];
    self.hours = [NSNumber numberWithInteger:button.tag - 9000];
    NSLog(@"%d", button.tag - 9000);
    if (self.weekdayView.changeBT.selected) {
        [self.weekdayView.timeBT setTitle:[NSString stringWithFormat:@"%d", button.tag - 9000] forState:UIControlStateNormal];
    }else if (self.weekendView.changeBT.selected)
    {
        [self.weekendView.timeBT setTitle:[NSString stringWithFormat:@"%d", button.tag - 9000] forState:UIControlStateNormal];
    }
}

- (void)returnDate:(ReturnDateDicBlock)dateBlock
{
    _returnDate = dateBlock;
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
