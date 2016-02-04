//
//  ChooseTimeViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/2/2.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "ChooseTimeViewController.h"
#import "WHUCalendarPopView.h"
#import "VerifyListViewController.h"


#define TOP_SPACE 10
#define LABEL_HEIGHT 30
@interface ChooseTimeViewController ()<UITextFieldDelegate>
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


@end


@implementation ChooseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    self.navigationItem.title = @"记录查询";
    
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
    [printBT setTitle:@"查询" forState:UIControlStateNormal];
    [printBT setTitleColor:[UIColor colorWithRed:253 / 255.0 green:91 / 255.0 blue:52 / 255.0 alpha:1] forState:UIControlStateNormal];
    [printBT addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printBT];
    
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择时间
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
    
    __weak ChooseTimeViewController * printVC = self;
    _pop.onDateSelectBlk = ^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [format stringFromDate:date];
        textField.text = dateString;
        NSLog(@"%@",dateString);
    };
    return NO;
}

- (void)queryAction:(UIButton *)button
{
    VerifyListViewController * verifyLiseVC = [[VerifyListViewController alloc]init];
    verifyLiseVC.startDate = self.startTF.text;
    verifyLiseVC.endDate = self.endTF.text;
    
    [self.navigationController pushViewController:verifyLiseVC animated:YES];
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
