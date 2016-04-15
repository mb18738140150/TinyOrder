//
//  EquipmentInformationViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/9/9.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "EquipmentInformationViewController.h"
#import "ItemCollectionViewCell.h"
#import "MenuModel.h"
#define LEFT_SPACE 10
#define TOP_SPACE 10
#define LB_WIDTH 100
#define LB_HEIGHT 30

#define kImageCellID @"imageCellID"

#define WAIMAI_BT_TAG 100000
#define TANGSHI_NT_TAG 200000
#define NO_CHOCE_BT_TAG 300000

#define MAINFONT [UIFont systemFontOfSize:14];

#define LINE_COLOR [UIColor colorWithWhite:0.9 alpha:1]

@interface EquipmentInformationViewController ()<HTTPPostDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *printNumLB;
@property (nonatomic, strong) UILabel *printSecretLB;
@property (nonatomic, strong) UILabel *printNameLB;
@property (nonatomic, strong) UILabel *phoneLB;

@property (nonatomic, strong) UITextField *printNumTF;
@property (nonatomic, strong) UITextField *printSecretTF;
@property (nonatomic, strong) UITextField *printNameTF;
@property (nonatomic, strong) UITextField *phoneTF;

@property (nonatomic, strong) UILabel * printNumberLabel;
@property (nonatomic, strong) UITextField * printNumberTF;

// 分类打印
@property (nonatomic, strong)UIButton * waimaiBT;
@property (nonatomic, strong)UIButton * tangshiBT;
@property (nonatomic, strong)UIButton * nochoceBT;

@property (nonatomic, strong)UICollectionView * collectView;
@property (strong, nonatomic)NSMutableArray * dataArray;
@property (strong, nonatomic)NSMutableArray * selectArr;


// 点餐app打印
@property (nonatomic, strong)UIView * diancanview;
@property (nonatomic, strong)UIButton * pleaseSelectBT;
@property (nonatomic, strong)UIButton * guadanBT;
@property (nonatomic, strong)UIButton * totalBT;

// 保存
@property (nonatomic, strong) UIButton *saveButton;

// 上传参数
@property (nonatomic, assign)int  ClassificationPrint;
@property (nonatomic, assign)int  OrderPrint;
@property (nonatomic, strong)NSString *  ClassificationID;

// ClassificationIDs
@property (nonatomic, strong)NSMutableArray * classificationArr;

@end

@implementation EquipmentInformationViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        self.selectArr = [NSMutableArray array];
    }
    return _selectArr;
}
- (NSMutableArray *)classificationArr
{
    if (!_classificationArr) {
        self.classificationArr = [NSMutableArray array];
    }
    return _classificationArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    
    self.navigationItem.title = @"设备信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    [self createSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.printID.intValue != 0) {
        NSDictionary *jsondic = @{
                                  @"Command":@86,
                                  @"UserId":[UserInfo shareUserInfo].userId,
                                  @"PrintId":self.printID
                                  };
        [self playPostWithDictionary:jsondic];
        [SVProgressHUD showInfoWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)backLastVC:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubviews
{
    self.ClassificationID = @"";
    self.ClassificationPrint = 0;
    self.OrderPrint = 0;
    
    UIScrollView *scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
    
    UIView * printNumView = [[UIView alloc]initWithFrame:CGRectMake(0, TOP_SPACE, self.view.width, 50)];
    printNumView.backgroundColor = [UIColor whiteColor];
    scroller.tag = 1000;
    [scroller addSubview:printNumView];
    
    self.printNumLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
    _printNumLB.text = @"设备编号:";
    _printNumLB.font = MAINFONT
    _printNumLB.textAlignment = NSTextAlignmentRight;
    [printNumView addSubview:_printNumLB];
    
    self.printNumTF = [[UITextField alloc]initWithFrame:CGRectMake(_printNumLB.right + LEFT_SPACE, _printNumLB.top, self.view.width - _printNumLB.width - 3 * LEFT_SPACE, _printNumLB.height)];
    [printNumView addSubview:_printNumTF];
    
    UIView * printSecretView = [[UIView alloc]initWithFrame:CGRectMake(0, 1 + printNumView.bottom, self.view.width, 50)];
    printSecretView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:printSecretView];
    
    self.printSecretLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
    _printSecretLB.text = @"设备密钥:";
    _printSecretLB.font = MAINFONT
    _printSecretLB.textAlignment = NSTextAlignmentRight;
    [printSecretView addSubview:_printSecretLB];
    
    self.printSecretTF = [[UITextField alloc]initWithFrame:CGRectMake(_printSecretLB.right + LEFT_SPACE, _printSecretLB.top, self.view.width - _printSecretLB.width - 3 * LEFT_SPACE, _printSecretLB.height)];
    [printSecretView addSubview:_printSecretTF];
    
    if (self.printID.intValue != 0) {
        self.printNumTF.enabled = NO;
        self.printSecretTF.enabled = NO;
    }
    
    
    UIView * printNumberView = [[UIView alloc]initWithFrame:CGRectMake(0, 1 + printSecretView.bottom, self.view.width, 50)];
    printNumberView.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:printNumberView];

    if (self.addOnlineprintType == addGPRSPrint) {
    }else
    {
        printSecretView.hidden = YES;
        printNumberView.top = printNumView.bottom + 1;
    }
    self.printNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
    _printNumberLabel.text = @"打印份数:";
    _printNumberLabel.font = MAINFONT
    _printNumberLabel.textAlignment = NSTextAlignmentRight;
    [printNumberView addSubview:_printNumberLabel];
    
    self.printNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(_printNumberLabel.right + LEFT_SPACE, _printNumberLabel.top, self.view.width - _printNumberLabel.width - 3 * LEFT_SPACE, _printNumberLabel.height)];
    _printNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    [printNumberView addSubview:_printNumberTF];
    
    
    
    /*
//    self.printNameLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE,line2.bottom + TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
//    _printNameLB.text = @"终端名称:";
//    _printNameLB.textAlignment = NSTextAlignmentRight;
//    [scroller addSubview:_printNameLB];
//    
//    self.printNameTF = [[UITextField alloc]initWithFrame:CGRectMake(_printNameLB.right + LEFT_SPACE, _printNameLB.top, self.view.width - _printNameLB.width - 3 * LEFT_SPACE, _printNameLB.height)];
//    [scroller addSubview:_printNameTF];
//    
//    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _printNameLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
//    line3.backgroundColor = LINE_COLOR;
//    [scroller addSubview:line3];
    
//
//    self.phoneLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE,line3.bottom + TOP_SPACE, LB_WIDTH, LB_HEIGHT)];
//    _phoneLB.text = @"手机号:";
//    _phoneLB.textAlignment = NSTextAlignmentRight;
//    [scroller addSubview:_phoneLB];
//    
//    self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(_phoneLB.right + LEFT_SPACE, _phoneLB.top, self.view.width - _phoneLB.width - 3 * LEFT_SPACE, _phoneLB.height)];
//    [scroller addSubview:_phoneTF];
//    
//    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(LEFT_SPACE, _phoneLB.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, 0.6)];
//    line4.backgroundColor = LINE_COLOR;
//    [scroller addSubview:line4];
    */
    
    UIView * printTypeview = [[UIView alloc]initWithFrame:CGRectMake(0, printNumberView.bottom + 20, scroller.width, 50)];
    printTypeview.backgroundColor = [UIColor whiteColor];
    printTypeview.tag = 2000;
    [scroller addSubview:printTypeview];
    
    UILabel * printTypelabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 80, 30)];
    printTypelabel.text = @"分类打印";
    printTypelabel.font = MAINFONT
    printTypelabel.backgroundColor = [UIColor whiteColor];
    [printTypeview addSubview:printTypelabel];
    
    self.waimaiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _waimaiBT.backgroundColor = [UIColor whiteColor];
    [_waimaiBT setTitle:@"外卖" forState:UIControlStateNormal];
    _waimaiBT.titleLabel.font = MAINFONT
    [_waimaiBT setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_waimaiBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _waimaiBT.frame = CGRectMake(printTypeview.width - 210, 0, 70, printTypeview.height);
    [printTypeview addSubview:_waimaiBT];
    
    self.tangshiBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _tangshiBT.backgroundColor = [UIColor whiteColor];
    [_tangshiBT setTitle:@"堂食" forState:UIControlStateNormal];
    _tangshiBT.titleLabel.font = MAINFONT
    [_tangshiBT setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_tangshiBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _tangshiBT.frame = CGRectMake(_waimaiBT.right, 0, 70, printTypeview.height);
    [printTypeview addSubview:_tangshiBT];
    
    self.nochoceBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _nochoceBT.backgroundColor = [UIColor whiteColor];
    [_nochoceBT setTitle:@"全部" forState:UIControlStateNormal];
    _nochoceBT.titleLabel.font = MAINFONT
    [_nochoceBT setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_nochoceBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _nochoceBT.frame = CGRectMake(_tangshiBT.right, 0, 70, printTypeview.height);
    [printTypeview addSubview:_nochoceBT];
    
    [_waimaiBT addTarget:self action:@selector(choceTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tangshiBT addTarget:self action:@selector(choceTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_nochoceBT addTarget:self action:@selector(choceTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(self.view.width / 4, 70);
    // 设置边界缩进
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 设置item之间的最小距离
    layout.minimumInteritemSpacing = 0;
    
    // 设置行之间的最小间距
    layout.minimumLineSpacing = 0;
    // 设置分区页眉（header）大小
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    
    // 设置分区页脚（footer）大小
    layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
    
    self.collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, printTypeview.bottom + 1, self.view.width, 20) collectionViewLayout:layout];
    self.collectView.delegate = self;
    self.collectView.dataSource = self;
    self.collectView.backgroundColor = [UIColor whiteColor];
    [self.collectView registerClass:[ItemCollectionViewCell class] forCellWithReuseIdentifier:kImageCellID];
    self.collectView.hidden = YES;
    [scroller addSubview:self.collectView];
    
    
    
    
    self.diancanview = [[UIView alloc]initWithFrame:CGRectMake(0, printTypeview.bottom + 20, scroller.width, 50)];
    _diancanview.backgroundColor = [UIColor whiteColor];
    [scroller addSubview:_diancanview];
    
    UILabel * diancanTypelabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 90, 30)];
    diancanTypelabel.text = @"点餐app打印";
    diancanTypelabel.font = MAINFONT;
    diancanTypelabel.backgroundColor = [UIColor whiteColor];
    [_diancanview addSubview:diancanTypelabel];
    
    self.guadanBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _guadanBT.backgroundColor = [UIColor whiteColor];
    [_guadanBT setTitle:@"挂单(堂食)" forState:UIControlStateNormal];
    _guadanBT.titleLabel.font = MAINFONT
    [_guadanBT setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_guadanBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _guadanBT.frame = CGRectMake(_diancanview.width - 210, 0, 70, _diancanview.height);
    [_diancanview addSubview:_guadanBT];
    
    self.totalBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _totalBT.backgroundColor = [UIColor whiteColor];
    [_totalBT setTitle:@"总订单(堂食)" forState:UIControlStateNormal];
    _totalBT.titleLabel.font = MAINFONT
    [_totalBT setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_totalBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _totalBT.frame = CGRectMake(_guadanBT.right, 0, 90, _diancanview.height);
    [_diancanview addSubview:_totalBT];
    
    self.pleaseSelectBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _pleaseSelectBT.backgroundColor = [UIColor whiteColor];
    [_pleaseSelectBT setTitle:@"选择" forState:UIControlStateNormal];
    _pleaseSelectBT.titleLabel.font = MAINFONT
    [_pleaseSelectBT setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_pleaseSelectBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _pleaseSelectBT.frame = CGRectMake(_totalBT.right, 0, 50, _diancanview.height);
    [_diancanview addSubview:_pleaseSelectBT];
    
    [_guadanBT addTarget:self action:@selector(diancanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_totalBT addTarget:self action:@selector(diancanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pleaseSelectBT addTarget:self action:@selector(diancanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _saveButton.frame = CGRectMake(LEFT_SPACE, self.diancanview.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, LB_HEIGHT + 10);
    _saveButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveButton.layer.cornerRadius = 5;
    _saveButton.layer.masksToBounds = YES;
    _saveButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [_saveButton addTarget:self action:@selector(saveEquipmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [scroller addSubview:_saveButton];
    
    scroller.contentSize =  CGSizeMake(self.view.width, _saveButton.bottom + TOP_SPACE);
    
    [self.view addSubview:scroller];
}

- (void)saveEquipmentAction:(UIButton *)button
{
    for (int i = 0; i < self.selectArr.count; i++) {
        MenuModel * model = [self.selectArr objectAtIndex:i];
        
        if (i == 0) {
            self.ClassificationID = [NSString stringWithFormat:@"%@", model.classifyId];
        }else
        {
            self.ClassificationID = [self.ClassificationID stringByAppendingFormat:@",%@", model.classifyId];
        }
    }
    
    if (self.addOnlineprintType == addGPRSPrint) {
        if ([self.printNumberTF.text intValue] < 0) {
            self.printNumberTF.text = @"0";
        }
        
        if (self.printNumTF.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备编号不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else if (self.printSecretTF.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备密匙不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            NSDictionary *jsondic = @{
                                      @"Command":@51,
                                      @"UserId":[UserInfo shareUserInfo].userId,
                                      @"PrintNum":self.printNumTF.text,
                                      @"PrintSecret":self.printSecretTF.text,
                                      @"PrintCount":@([self.printNumberTF.text intValue]),
                                      @"ClassificationPrint":@(self.ClassificationPrint),
                                      @"OrderPrint":@(self.OrderPrint),
                                      @"ClassificationID":self.ClassificationID,
                                      @"PrintId":@0
                                      };
            [self playPostWithDictionary:jsondic];
            [SVProgressHUD showInfoWithStatus:@"正在添加" maskType:SVProgressHUDMaskTypeBlack];
        }

    }else
    {
        
        if ([self.printNumberTF.text intValue] < 0) {
            self.printNumberTF.text = @"0";
        }
        
        if (self.printNumTF.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备编号不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        else
        {
            NSDictionary *jsondic = @{
                                      @"Command":@84,
                                      @"UserId":[UserInfo shareUserInfo].userId,
                                      @"PrintNum":self.printNumTF.text,
                                      @"PrintCount":@([self.printNumberTF.text intValue]),
                                      @"ClassificationPrint":@(self.ClassificationPrint),
                                      @"OrderPrint":@(self.OrderPrint),
                                      @"ClassificationID":self.ClassificationID,
                                      @"PrintId":@0
                                      };
            
            
            [self playPostWithDictionary:jsondic];
            [SVProgressHUD showInfoWithStatus:@"正在添加" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    
}

#pragma mark - 数据请求
- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
    NSLog(@"%@", jsonStr);
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
        if ([[data objectForKey:@"Command"] isEqualToNumber:@10051]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10001])
        {
            if (self.dataArray.count != 0) {
                [self.dataArray removeAllObjects];
            }
            if (self.selectArr.count != 0) {
                [self.selectArr removeAllObjects];
            }
            NSArray * menuArray = [data objectForKey:@"ClassifyList"];
            for (NSDictionary * dic in menuArray) {
                MenuModel * menuMD = [[MenuModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:menuMD];
            }
            if (self.dataArray.count%4 == 0) {
                self.collectView.height = 50 * (self.dataArray.count / 4);
            }else
            {
                self.collectView.height = 50 * (self.dataArray.count / 4 + 1);
            }
            [self againLayout];
            [self.collectView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10084])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else if ([[data objectForKey:@"Command"] isEqualToNumber:@10086])
        {
            [self creatDataWithData:data];
        }
        
    }else
    {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"失败" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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

- (void)creatDataWithData:(NSDictionary *)dic
{
#warning donot finish
    
    self.printNumTF.text = [dic objectForKey:@"PrintNum"];
    if ([[dic objectForKey:@"PrintType"] intValue] == 1) {
        self.printSecretTF.text = [dic objectForKey:@"PrintSecret"];
    }
    self.printNumberTF.text = [dic objectForKey:@"PrintCount"];
    if ([[dic objectForKey:@"ClassificationPrint"] intValue] == 1) {
        self.ClassificationPrint = 1;
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":@1,
                                   @"Command":@1,
                                   @"CurCount":@(MAX_CANON),
                                   @"ObtainAll":@1,
                                   @"ClassifyType":@(1)
                                   };
        [self playPostWithDictionary:jsonDic];
        _waimaiBT.backgroundColor = BACKGROUNDCOLOR;
        [_waimaiBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([[dic objectForKey:@"ClassificationPrint"] intValue] == 2)
    {
        self.ClassificationPrint = 2;
        NSDictionary * jsonDic = @{
                                @"UserId":[UserInfo shareUserInfo].userId,
                                @"CurPage":@1,
                                @"Command":@1,
                                @"CurCount":@(MAX_CANON),
                                @"ObtainAll":@1,
                                @"ClassifyType":@(2)
                                };
        [self playPostWithDictionary:jsonDic];
        _tangshiBT.backgroundColor = BACKGROUNDCOLOR;
        [_tangshiBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else
    {
        self.ClassificationPrint = 0;
        _nochoceBT.backgroundColor = BACKGROUNDCOLOR;
        [_nochoceBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if ([[dic objectForKey:@"OrderPrint"] intValue] == 1) {
        self.OrderPrint = 1;
        _guadanBT.backgroundColor = BACKGROUNDCOLOR;
        [_guadanBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([[dic objectForKey:@"OrderPrint"] intValue] == 2)
    {
        self.OrderPrint = 2;
        _totalBT.backgroundColor = BACKGROUNDCOLOR;
        [_totalBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else
    {
        self.OrderPrint = 0;
        _pleaseSelectBT.backgroundColor = BACKGROUNDCOLOR;
        [_pleaseSelectBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    NSString * idStr = [dic objectForKey:@"ClassificationID"];
    if (idStr.length != 0) {
        if ([idStr containsString:@","]) {
            NSArray * arr = [idStr componentsSeparatedByString:@","];
            for (NSString * ids in arr) {
                [self.classificationArr addObject:ids];
            }
        }else
        {
            [self.classificationArr addObject:idStr];
        }
    }
}
#pragma mark - 选择打印分类
- (void)choceTypeAction:(UIButton *)button
{
    self.collectView.hidden = NO;
    if ([button isEqual:self.waimaiBT]) {
        self.ClassificationPrint = 1;
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":@1,
                                   @"Command":@1,
                                   @"CurCount":@(MAX_CANON),
                                   @"ObtainAll":@1,
                                   @"ClassifyType":@(1)
                                   };
        [self playPostWithDictionary:jsonDic];
        
        button.backgroundColor = BACKGROUNDCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.tangshiBT.backgroundColor = [UIColor whiteColor];
        [self.tangshiBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.nochoceBT.backgroundColor = [UIColor whiteColor];
        [self.nochoceBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }else if([button isEqual:self.tangshiBT])
    {
        self.ClassificationPrint = 2;
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"CurPage":@1,
                                   @"Command":@1,
                                   @"CurCount":@(MAX_CANON),
                                   @"ObtainAll":@1,
                                   @"ClassifyType":@(2)
                                   };
        [self playPostWithDictionary:jsonDic];
        button.backgroundColor = BACKGROUNDCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.waimaiBT.backgroundColor = [UIColor whiteColor];
        [self.waimaiBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.nochoceBT.backgroundColor = [UIColor whiteColor];
        [self.nochoceBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if ([button isEqual:self.nochoceBT])
    {
        self.ClassificationPrint = 0;
        self.collectView.hidden = YES;
        [self againLayout];
        button.backgroundColor = BACKGROUNDCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (self.selectArr.count != 0) {
            [self.selectArr removeAllObjects];
        }
        self.tangshiBT.backgroundColor = [UIColor whiteColor];
        [self.tangshiBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.waimaiBT.backgroundColor = [UIColor whiteColor];
        [self.waimaiBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
-(void)diancanAction:(UIButton *)button
{
    if ([button isEqual:self.guadanBT]) {
        self.OrderPrint = 1;
        button.backgroundColor = BACKGROUNDCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.totalBT.backgroundColor = [UIColor whiteColor];
        [self.totalBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.pleaseSelectBT.backgroundColor = [UIColor whiteColor];
        [self.pleaseSelectBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if ([button isEqual:self.totalBT])
    {
        self.OrderPrint = 2;
        button.backgroundColor = BACKGROUNDCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.guadanBT.backgroundColor = [UIColor whiteColor];
        [self.guadanBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.pleaseSelectBT.backgroundColor = [UIColor whiteColor];
        [self.pleaseSelectBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else
    {
        self.OrderPrint = 0;
        button.backgroundColor = BACKGROUNDCOLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.totalBT.backgroundColor = [UIColor whiteColor];
        [self.totalBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.guadanBT.backgroundColor = [UIColor whiteColor];
        [self.guadanBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}


#pragma mark - uicollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellID forIndexPath:indexPath];
    [cell createSubview];
    MenuModel * menuModel = [self.dataArray objectAtIndex:indexPath.item];
//    NSLog(@"%@***%@", menuModel.name, menuModel.classifyId); 
    cell.nameLabel.text = menuModel.name;
    
    if (self.classificationArr.count != 0) {
        for (NSString * idstr in self.classificationArr) {
            if ([menuModel.classifyId isEqualToNumber:[NSNumber numberWithInt:[idstr intValue]]]) {
                cell.backImageview.image = [UIImage imageNamed:@"pos_icon.png"];
                cell.backView.hidden = YES;
                [self.selectArr addObject:menuModel];
            }
        }
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionViewCell * cell = (ItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSData * cellImagedata = UIImagePNGRepresentation(cell.backImageview.image);
    NSData * imageData = UIImagePNGRepresentation([UIImage imageNamed:@"pos_icon.png"]);
    MenuModel * menuModel = [self.dataArray objectAtIndex:indexPath.item];
    if ([cellImagedata isEqualToData:imageData]) {
        cell.backImageview.image = [UIImage imageNamed:@""];
        cell.backView.hidden = NO;
//        cell.backImageview.layer.borderColor = [UIColor grayColor].CGColor;
//        cell.backImageview.layer.borderWidth = 1;
//        cell.backImageview.layer.cornerRadius = 0;
//        cell.backImageview.layer.masksToBounds = NO;
        for (int i = 0; i < self.selectArr.count; i++) {
            MenuModel * model = [self.selectArr objectAtIndex:i];
            if ([menuModel.classifyId isEqualToNumber:model.classifyId]) {
                [self.selectArr removeObject:model];
                break;
            }
        }
        
    }else
    {
        [self.selectArr addObject:menuModel];
        cell.backImageview.image = [UIImage imageNamed:@"pos_icon.png"];
        cell.backView.hidden = YES;
//        cell.backImageview.layer.borderColor = [UIColor whiteColor].CGColor;
//        cell.backImageview.layer.borderWidth = 1;
//        cell.backImageview.layer.cornerRadius = 5;
//        cell.backImageview.layer.masksToBounds = YES;
    }
    
    if (self.selectArr.count != 0) {
        for (MenuModel * model in self.selectArr) {
            NSLog(@"***%@", model.classifyId);
        }
    }
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.width / 4, 50);
}

#pragma mark - 从新布局
- (void)againLayout
{
    UIScrollView * scroller = [self.view viewWithTag:1000];
    UIView * printView = [[self.view viewWithTag:1000] viewWithTag:2000];
    
    if (self.collectView.hidden) {
        self.diancanview.top = printView.bottom + 20;
    }else
    {
        self.diancanview.top = self.collectView.bottom + 20;
    }
    _saveButton.frame = CGRectMake(LEFT_SPACE, self.diancanview.bottom + TOP_SPACE, self.view.width - 2 * LEFT_SPACE, LB_HEIGHT + 10);
    scroller.contentSize =  CGSizeMake(self.view.width, _saveButton.bottom + TOP_SPACE);

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
