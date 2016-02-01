//
//  PrintRevenueController.m
//  TinyOrder
//
//  Created by 仙林 on 15/12/30.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "PrintRevenueController.h"
#import "WHUCalendarPopView.h"
#import "GeneralBlueTooth.h"
#import "PrintTypeViewController.h"
#import "FlowListModel.h"

#define TOP_SPACE 10
#define LABEL_HEIGHT 30
@interface PrintRevenueController ()<UITextFieldDelegate, HTTPPostDelegate>
{
    WHUCalendarPopView * _pop;
}
@property (nonatomic, strong)UIButton * todayButton;
@property (nonatomic, strong)UIButton * threedayButton;
@property (nonatomic, strong)UIButton * weekButton;
@property (nonatomic, strong)UIButton * monthButton;
@property (nonatomic, strong)UITextField * startTF;
@property (nonatomic, strong)UITextField * endTF;

@property (nonatomic, strong)UITextField * TF;

@property (nonatomic, strong)NSMutableArray * flowListArray;
@property (nonatomic, strong)PrintTypeViewController *printTypeVC;
@end

@implementation PrintRevenueController

- (NSMutableArray *)flowListArray
{
    if (!_flowListArray) {
        self.flowListArray = [NSMutableArray array];
    }
    return _flowListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.title = @"打印";
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.todayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _todayButton.frame = CGRectMake(0, 0, self.view.width / 4, 40);
    _todayButton.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1];
    [_todayButton setTitle:@"今日" forState:UIControlStateNormal];
    [_todayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_todayButton setTintColor:[UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1]];
    [_todayButton addTarget:self action:@selector(changeTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_todayButton];
    
    self.threedayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _threedayButton.frame = CGRectMake(_todayButton.right, 0, self.view.width / 4, 40);
    _threedayButton.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1];
    [_threedayButton setTitle:@"最近三天" forState:UIControlStateNormal];
    [_threedayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_threedayButton setTintColor:[UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1]];
    [_threedayButton addTarget:self action:@selector(changeTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_threedayButton];
    
    self.weekButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _weekButton.frame = CGRectMake(_threedayButton.right, 0, self.view.width / 4, 40);
    _weekButton.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1];
    [_weekButton setTitle:@"最近一周" forState:UIControlStateNormal];
    [_weekButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_weekButton setTintColor:[UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1]];
    [_weekButton addTarget:self action:@selector(changeTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_weekButton];
    
    self.monthButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _monthButton.frame = CGRectMake(_weekButton.right, 0, self.view.width / 4, 40);
    _monthButton.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1];
    [_monthButton setTitle:@"最近一月" forState:UIControlStateNormal];
    [_monthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_monthButton setTintColor:[UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1]];
    [_monthButton addTarget:self action:@selector(changeTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_monthButton];
    
    UIView * startView = [[UIView alloc]initWithFrame:CGRectMake(0, _todayButton.bottom + TOP_SPACE, self.view.width, 50)];
    startView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:startView];
    UILabel * startLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, TOP_SPACE, 100, LABEL_HEIGHT)];
    startLB.text = @"开始时间:";
    startLB.backgroundColor = [UIColor clearColor];
    [startView addSubview:startLB];
    
    self.startTF = [[UITextField alloc]initWithFrame:CGRectMake(startLB.right, startLB.top, startView.width - startLB.width, startLB.height)];
    _startTF.placeholder = @"点击选择时间";
    _startTF.backgroundColor = [UIColor clearColor];
    _startTF.enabled = YES;
    _startTF.delegate = self;
    [startView addSubview:_startTF];
    
    UIView * endView = [[UIView alloc]initWithFrame:CGRectMake(0, startView.bottom + 1 , self.view.width, 50)];
    endView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:endView];
    UILabel * endLB = [[UILabel alloc]initWithFrame:CGRectMake(TOP_SPACE, TOP_SPACE, 100, LABEL_HEIGHT)];
    endLB.text = @"结束时间:";
    endLB.backgroundColor = [UIColor clearColor];
    [endView addSubview:endLB];
    
    self.endTF = [[UITextField alloc]initWithFrame:CGRectMake(endLB.right, endLB.top, endView.width - endLB.width, endLB.height)];
    _endTF.placeholder = @"点击选择时间";
    _endTF.backgroundColor = [UIColor clearColor];
    _endTF.enabled = YES;
    _endTF.delegate = self;
    [endView addSubview:_endTF];
    
    UIButton * printBT = [UIButton buttonWithType:UIButtonTypeSystem];
    printBT.frame = CGRectMake(5 * TOP_SPACE, endView.bottom + 5 * TOP_SPACE, self.view.width - 10 * TOP_SPACE, 50);
    printBT.backgroundColor = [UIColor whiteColor];
    printBT.layer.cornerRadius = 5;
    printBT.layer.masksToBounds = YES;
    printBT.layer.borderWidth = 1;
    printBT.layer.borderColor = [UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1].CGColor;
    [printBT setTitle:@"开始打印" forState:UIControlStateNormal];
    [printBT setTitleColor:[UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1] forState:UIControlStateNormal];
    [printBT addTarget:self action:@selector(printRevenueAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printBT];
    
//    UITapGestureRecognizer * startTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeStartTime:)];
//    [_startTF addGestureRecognizer:startTap];
//    
//    UITapGestureRecognizer * endTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeEndTime:)];
//    [_endTF addGestureRecognizer:endTap];
    
//    _pop = [[WHUCalendarPopView alloc]init];
//    _pop.frame = [UIScreen mainScreen].bounds;
    self.printTypeVC = [[PrintTypeViewController alloc]init];
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeTimeAction:(UIButton *)button
{
    NSDate * nowDate = [NSDate date];
    nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter * nowFomatter = [[NSDateFormatter alloc]init];
    nowFomatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowString = [nowFomatter stringFromDate:nowDate];
    
    
    
    if ([button isEqual:_todayButton]) {
        self.startTF.text = nowString;
        self.endTF.text = nowString;
        NSLog(@"点击了今天");
    }else if ([button isEqual:_threedayButton])
    {
        NSDate * threeDate = [NSDate date];
        threeDate = [NSDate dateWithTimeIntervalSinceNow:0 - 3600 * 24 * 2];
        
        NSDateFormatter * threeFomatter = [[NSDateFormatter alloc]init];
        threeFomatter.dateFormat = @"yyyy-MM-dd";
        NSString *threeString = [threeFomatter stringFromDate:threeDate];
        
        self.startTF.text = threeString;
        self.endTF.text = nowString;
        
        NSLog(@"点击了三天按钮");
    }else if ([button isEqual:_weekButton])
    {
        NSDate * weekDate = [NSDate date];
        weekDate = [NSDate dateWithTimeIntervalSinceNow:0 - 3600 * 24 * 6];
        
        NSDateFormatter * weekFomatter = [[NSDateFormatter alloc]init];
        weekFomatter.dateFormat = @"yyyy-MM-dd";
        NSString *weekString = [weekFomatter stringFromDate:weekDate];
        
        self.startTF.text = weekString;
        self.endTF.text = nowString;
        
        NSLog(@"点击了最近一周");
    }else if ([button isEqual:_monthButton])
    {
        NSDate * monthDate = [NSDate date];
        monthDate = [NSDate dateWithTimeIntervalSinceNow:0 - 3600 * 24 * 30];
        
        NSDateFormatter * monthFomatter = [[NSDateFormatter alloc]init];
        monthFomatter.dateFormat = @"yyyy-MM-dd";
        NSString *monthString = [monthFomatter stringFromDate:monthDate];
        
        self.startTF.text = monthString;
        self.endTF.text = nowString;
        
        NSLog(@"点击了最近一个月");
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"显示日历");
    _pop = [[WHUCalendarPopView alloc]init];
    _pop.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    
    [self.view addSubview:_pop];
    [_pop show];
    
    __weak PrintRevenueController * printVC = self;
    _pop.onDateSelectBlk = ^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [format stringFromDate:date];
        textField.text = dateString;
        NSLog(@"%@",dateString);
    };
    return NO;
}

- (void)printRevenueAction:(UIButton *)sender
{
    
    
    
    if (self.startTF.text.length == 0) {
        self.startTF.text = @"";
    }else if (self.endTF.text.length == 0)
    {
        self.endTF.text = @"";
    }
    
    if (self.startTF.text.length != 0 && self.endTF.text.length == 0) {
        // 不可以只选择开始时间
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入结束时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (self.endTF.text.length != 0 && self.startTF.text.length == 0)
    {
        // 只选择结束时间的话，默认打印最近三个月
        NSDate * monthDate = [NSDate date];
        monthDate = [NSDate dateWithTimeIntervalSinceNow:0 - 3600 * 24 * 90];
        
        NSDateFormatter * monthFomatter = [[NSDateFormatter alloc]init];
        monthFomatter.dateFormat = @"yyyy-MM-dd";
        NSString *monthString = [monthFomatter stringFromDate:monthDate];
        
        self.startTF.text = monthString;
    }
    else
    {
        // 开始时间结束时间都有的话，判断时间间隔是否超过了三个月
        
        NSDateFormatter * monthFomatter = [[NSDateFormatter alloc]init];
        monthFomatter.dateFormat = @"yyyy-MM-dd";
        NSDate *endDate = [monthFomatter dateFromString:self.endTF.text];
        NSDate *startDate = [monthFomatter dateFromString:self.startTF.text];
        
        NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
        
        double timejiange = time / 3600 / 24 ;
        if (timejiange > 90) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"打印订单时间间隔不得超过三个月" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            
            NSLog(@"开始打印 %@ 号到 %@ 号的订单",self.startTF.text, self.endTF.text );
            [self print];
//            NSDictionary * dic = @{
//                                   @"UserId":[UserInfo shareUserInfo].userId,
//                                   @"Command":@(71),
//                                   @"StartDate":self.startTF.text,
//                                   @"EndDate":self.endTF.text
//                                   };
//            [self playPostWithDictionary:dic];
        }
        
    }
    
}

- (void)print
{
    if ([PrintType sharePrintType].isGPRSenable) {
        NSDictionary * dic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@(71),
                               @"StartDate":self.startTF.text,
                               @"EndDate":self.endTF.text,
                               @"PrintType":@(2)
                               };
        [self playPostWithDictionary:dic];
        
        
    }
    if ( [PrintType sharePrintType].isBlutooth)
    {
        if ([GeneralBlueTooth shareGeneralBlueTooth].myPeripheral.state) {
            NSDictionary * dic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@(71),
                                   @"StartDate":self.startTF.text,
                                   @"EndDate":self.endTF.text,
                                   @"PrintType":@(1)
                                   };
            [self playPostWithDictionary:dic];
            
            [SVProgressHUD showWithStatus:@"正在处理..." maskType:SVProgressHUDMaskTypeBlack];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"蓝牙打印机未连接" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
//            NSDictionary * dic = @{
//                                   @"UserId":[UserInfo shareUserInfo].userId,
//                                   @"Command":@(71),
//                                   @"StartDate":self.startTF.text,
//                                   @"EndDate":self.endTF.text,
//                                   @"PrintType":@(1)
//                                   };
//            [self playPostWithDictionary:dic];
//            
//            [SVProgressHUD showWithStatus:@"正在处理..." maskType:SVProgressHUDMaskTypeBlack];
        }
        
    } else
    {
        _printTypeVC.fromWitchController = 2;
        [self.navigationController pushViewController:_printTypeVC animated:YES];
        
    }
    
}

- (void)playPostWithDictionary:(NSDictionary *)dic
{
    
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}

- (void)refresh:(id)data
{
    [SVProgressHUD dismiss];
    
    NSLog(@"%@", [data description]);
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        
        if (self.flowListArray.count != 0) {
            [self.flowListArray removeAllObjects];
        }
        
        NSArray * array = [data objectForKey:@"FlowList"];
        
        for (NSDictionary * dic in array) {
            FlowListModel * flowListModel = [[FlowListModel alloc]initWithDictionary:dic];
            [self.flowListArray addObject:flowListModel];
        }
        
        
        if ([PrintType sharePrintType].isGPRSenable) {
            
        }
        if ([PrintType sharePrintType].isBlutooth)
        {
            NSString * printStr = [self getPrintStringWithNewOrder:self.flowListArray];
            
            [[GeneralBlueTooth shareGeneralBlueTooth] printWithString:printStr];
            
        }

    }else
    {
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alerV show];
                [alerV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    
}

- (NSString *)getPrintStringWithNewOrder:(NSMutableArray *)array
{
    NSString * spaceString = @"                           ";
    NSString * shortspaceString = @"            ";
    NSString * lineStr = @"--------------------------------\r";
    NSMutableString * str = [NSMutableString string];
    for (FlowListModel * model in array) {
        [str appendFormat:@"%@\r", model.date];
        [str appendFormat:@"订单号:%@\r", model.actionName];
        
        NSString * str1 = nil;
        if (model.type == 0) {
            str1 = @"转到银行卡:";
        }else if (model.type == 1)
        {
            str1 = @"订单收入:";
        }else
        {
            str1 = @"支出金额:";
        }
        
        NSInteger length = 8 - str1.length;
        NSString * shortspace = [shortspaceString substringWithRange:NSMakeRange(0, length)];
        NSString * addTypeStr = [NSString stringWithFormat:@"%@%@%g", str1, shortspace, model.money];
        NSLog(@"length = %ld", length);
        NSString * stateStr = nil;
        if (model.state == 0) {
            stateStr = @"未到账";
        }else if (model.state == 1)
        {
            stateStr = @"已到账";
        }else if (model.state == 2)
        {
            stateStr = @"失败";
        }
        
        NSInteger length1 = 20 - addTypeStr.length;
        NSString * longSpace = [spaceString substringWithRange:NSMakeRange(0, length1)];
        NSString * addStateStr = [NSString stringWithFormat:@"%@%@%@",addTypeStr, longSpace, stateStr];
        NSLog(@"length1 = %ld", length1);
        [str appendFormat:@"%@\r", addStateStr];
        
        [str appendFormat:@"%@", lineStr];
//        [str appendFormat:@"\n"];
    }
    return [str copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
