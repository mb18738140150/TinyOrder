//
//  CertificationStatueViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/1.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "CertificationStatueViewController.h"

#define LEFT_SPASE 10
#define Top_SPASE 5
#define LEFT_LB_WIDTH 100
#define LABEL_HEIGHT 30


#define LINE_COLOR [UIColor colorWithWhite:0.9 alpha:1]


@interface CertificationStatueViewController ()<HTTPPostDelegate>

@property (nonatomic, strong)UILabel *numNameLB;
@property (nonatomic, strong)UILabel *numCommissionLB;
@property (nonatomic, strong)UILabel *numState;
@property (nonatomic, strong)UILabel *numLB;
@property (nonatomic, strong)UILabel *numTypeLB;
@property (nonatomic, strong)UILabel *autoTypeLB;
@property (nonatomic, strong)UILabel *numInfoLB;
@property (nonatomic, strong)UILabel *reasonLB;

@property (nonatomic, strong)UIButton *againApplyButton;

@end

@implementation CertificationStatueViewController

- (PublicNumModel *)publicNumModel
{
    if (!_publicNumModel) {
        self.publicNumModel = [[PublicNumModel alloc]init];
    }
    return _publicNumModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.publicNumModel);
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.width, 50)];
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    
    UILabel *numNameLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numNameLB.text = @"商家名称:";
    [bigView addSubview:numNameLB];
    
    self.numNameLB = [[UILabel alloc]initWithFrame:CGRectMake(numNameLB.right + LEFT_SPASE, Top_SPASE, bigView.width - LEFT_LB_WIDTH - 3 * LEFT_SPASE, LABEL_HEIGHT)];
    _numNameLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.numName];
    _numNameLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_numNameLB];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, numNameLB.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line1.backgroundColor = LINE_COLOR;
    [bigView addSubview:line1];
    
    UILabel *numCommissionLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line1.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numCommissionLB.text = @"佣金比例:";
    [bigView addSubview:numCommissionLB];
    
    self.numCommissionLB = [[UILabel alloc]initWithFrame:CGRectMake(bigView.width - LEFT_SPASE - 80, numCommissionLB.top, 60, LABEL_HEIGHT)];
    _numCommissionLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.numCommission];
    _numCommissionLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_numCommissionLB];
    
    UILabel *perLabel = [[UILabel alloc]initWithFrame:CGRectMake(bigView.width - LEFT_SPASE - 20, numCommissionLB.top, 20, LABEL_HEIGHT)];
    perLabel.text = @"%";
    [bigView addSubview:perLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, numCommissionLB.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line2.backgroundColor = LINE_COLOR;
    [bigView addSubview:line2];
    
    UILabel * numState = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line2.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numState.text = @"申请状态:";
    [bigView addSubview:numState];
    
    self.numState = [[UILabel alloc]initWithFrame:CGRectMake(numState.right + LEFT_SPASE, numState.top, bigView.width - 3 * LEFT_SPASE - LEFT_LB_WIDTH, LABEL_HEIGHT)];
    
    switch ([self.publicNumModel.numState integerValue]) {
        case 0:
            _numState.text = @"待审核";
            break;
        case 1:
            _numState.text = @"审核成功";
            break;
        case 2:
            _numState.text = @"审核失败";
            break;
        default:
            break;
    }
    _numState.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_numState];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, numState.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line3.backgroundColor = LINE_COLOR;
    [bigView addSubview:line3];
    
    UILabel *numLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line3.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numLB.text= @"公众号:";
    [bigView addSubview:numLB];
    
    self.numLB = [[UILabel alloc]initWithFrame:CGRectMake(numLB.right + LEFT_SPASE, numLB.top, bigView.width - 3 * LEFT_SPASE - LEFT_LB_WIDTH, LABEL_HEIGHT)];
    _numLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.num];
    _numLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_numLB];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, numLB.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line4.backgroundColor = LINE_COLOR;
    [bigView addSubview:line4];
    
    UILabel *numTypeLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line4.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numTypeLB.text = @"账号类型:";
    [bigView addSubview:numTypeLB];
    
    self.numTypeLB = [[UILabel alloc]initWithFrame:CGRectMake(numTypeLB.right + Top_SPASE, numTypeLB.top, bigView.width - 3 * LEFT_SPASE - LEFT_LB_WIDTH, LABEL_HEIGHT)];
    _numTypeLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.numType];
    _numTypeLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_numTypeLB];
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, numTypeLB.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line5.backgroundColor = LINE_COLOR;
    [bigView addSubview:line5];
    
    UILabel *autoTypeLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line5.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    autoTypeLB.text = @"认证类型:";
    [bigView addSubview:autoTypeLB];
    
    self.autoTypeLB = [[UILabel alloc]initWithFrame:CGRectMake(autoTypeLB.right + LEFT_SPASE, autoTypeLB.top, bigView.width - 3 * LEFT_SPASE - LEFT_LB_WIDTH, LABEL_HEIGHT)];
    _autoTypeLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.autoType];
    _autoTypeLB.textAlignment = NSTextAlignmentRight;
    [bigView addSubview:_autoTypeLB];
    
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, autoTypeLB.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line6.backgroundColor = LINE_COLOR;
    [bigView addSubview:line6];
    
    UILabel *numInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line6.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    numInfoLB.text = @"公众号描述:";
    [bigView addSubview:numInfoLB];
    
    self.numInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, numInfoLB.bottom, bigView.width - 2 * LEFT_SPASE, LABEL_HEIGHT)];
    _numInfoLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.numInfo];
    _numInfoLB.textAlignment = NSTextAlignmentLeft;
    [bigView addSubview:_numInfoLB];
    
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPASE, _numInfoLB.bottom + Top_SPASE, bigView.width - 2 * LEFT_SPASE, 0.6)];
    line7.backgroundColor = LINE_COLOR;
    [bigView addSubview:line7];
    
    UILabel *reasonLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, line7.bottom + Top_SPASE, LEFT_LB_WIDTH, LABEL_HEIGHT)];
    reasonLB.text = @"失败原因:";
    [bigView addSubview:reasonLB];
    
    self.reasonLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPASE, reasonLB.bottom, bigView.width - 2 * LEFT_SPASE, LABEL_HEIGHT)];
    _reasonLB.text = [NSString stringWithFormat:@"%@", self.publicNumModel.reason];
    _reasonLB.textAlignment = NSTextAlignmentLeft;
    [bigView addSubview:_reasonLB];
    
    bigView.height = _reasonLB.bottom + 2 * Top_SPASE;
    
    self.againApplyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.againApplyButton setTitle:@"重新申请入驻" forState:UIControlStateNormal];
    self.againApplyButton.frame = CGRectMake(LEFT_SPASE, bigView.bottom + 2 * Top_SPASE, self.view.frame.size.width - 2 * LEFT_SPASE, 40);
    self.againApplyButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    self.againApplyButton.tintColor = [UIColor whiteColor];
    self.againApplyButton.layer.cornerRadius = 5;
    self.againApplyButton.layer.masksToBounds = YES;
    self.againApplyButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.againApplyButton addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.againApplyButton];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)applyAction:(UIButton * )button
{
    NSDictionary *jsonDic = @{
                              @"Command":@47,
                              @"UserId":[UserInfo shareUserInfo].userId,
                              @"NumId":self.publicNumModel.numId,
                              @"NumCommission":self.publicNumModel.numCommission,
                              @"IsCustom":@(0)
                              };
    [self playPostWithDictionary:jsonDic];
}


#pragma mark -- 数据请求
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
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"申请成功"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
//    }
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
