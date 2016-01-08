//
//  DishDetailViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/11/7.
//  Copyright © 2015年 仙林. All rights reserved.
//

#import "DishDetailViewController.h"
#import "AddMenuViewController.h"
#import <UIImageView+WebCache.h>
#import "Tool.h"
#import "MealPropertyViewController.h"
#import "TasteDetailModel.h"
#import "TasteDetailsCell.h"

#define LABEL_HEIGHT 30
#define LEFT_SPACE 20
#define TOP_SPACE 10

#define CLEARALERT_TAH 6000
#define DELETEALERT_TAG 5000
#define EDITALERT_TAG 4000
#define CLEARBUTTON_TAG 3000
#define DELETEBUTTON_TAG 2000
#define EDITBUTTON_TAG 1000

#define LABEL_COLOR [UIColor clearColor]

#define CELLIDENTIFIRE @"cell"


@interface DishDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, HTTPPostDelegate>

@property (nonatomic, strong)UIScrollView * scrollView;

@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UITableView * dishPropertyTableView;
@property (nonatomic, strong)UILabel * saleCountLabel;
@property (nonatomic, strong)UILabel * priceLabel;
@property (nonatomic, strong)UILabel * foodBoxMoneyLabel;
@property (nonatomic, strong)UILabel * integralLabel;

@property (nonatomic, strong)UIButton * clearButton;
@property (nonatomic, strong)UIButton * editButton;
@property (nonatomic, strong)UIButton * deleteButton;

@property (nonatomic, strong)UILabel * unitTF;
@property (nonatomic, strong)UILabel * markTF;
@property (nonatomic, strong)UILabel * describeTFview;

@property (nonatomic, strong)UILabel * unitLabel;
@property (nonatomic, strong)UILabel * markTLabel;
@property (nonatomic, strong)UILabel * describeLabel;


@property (nonatomic, strong)NSMutableArray * tasteDetaileArray;

@property (nonatomic, copy)ReturnValueBlock returnValueBlock;

@end

@implementation DishDetailViewController

- (NSMutableArray *)tasteDetaileArray
{
    if (!_tasteDetaileArray) {
        self.tasteDetaileArray = [NSMutableArray array];
    }
    return _tasteDetaileArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品详情";
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    self.scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    _scrollView.backgroundColor = [UIColor redColor];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, self.view.width, self.view.height * 0.4)];
    CIContext * context = [CIContext contextWithOptions:nil];
    
    __weak DishDetailViewController * weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.detailMD.icon] placeholderImage:[UIImage imageNamed:@"PHOTO.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        // 使用 Core Image 进行模糊
//        CIImage * inputImage = [CIImage imageWithCGImage:image.CGImage];
//        CIFilter * filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(2.0), nil];
//        CIImage * outputImage = filter.outputImage;
//        CGImageRef outImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
//        weakSelf.imageView.image = [UIImage imageWithCGImage:outImage];
        
        // 高斯模糊
        if (image) {
            [weakSelf.imageView setImage:[Tool blurryImage:image withBlurLevel:0.4]];
        }
        
    }];
    
    [_scrollView addSubview:_imageView];
    
    UIView * backView = [[UIView alloc]init];
    backView.frame = _imageView.frame;
    backView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    [_scrollView addSubview:backView];
    
    UILabel * saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width / 2 - 40, _imageView.top + _imageView.height / 2 + 40, 40, LABEL_HEIGHT)];
    saleLabel.text = @"已售";
    saleLabel.textColor = [UIColor whiteColor];
    saleLabel.font = [UIFont systemFontOfSize:18];
    saleLabel.textAlignment = NSTextAlignmentCenter ;
    [_scrollView addSubview:saleLabel];
    
    self.saleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(saleLabel.right, saleLabel.bottom - 80, self.view.width / 2, 80)];
    self.saleCountLabel.text = @"33";
    _saleCountLabel.textColor = [UIColor whiteColor];
    self.saleCountLabel.font = [UIFont systemFontOfSize:65];
//    self.saleCountLabel.font = [UIFont boldSystemFontOfSize:30];
    
    [_scrollView addSubview:_saleCountLabel];
    
    
    UILabel * priceLB = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width / 2 - 151, _saleCountLabel.bottom + TOP_SPACE, 40, LABEL_HEIGHT)];
    priceLB.text = @"价格:";
    priceLB.textColor = [UIColor whiteColor];
    [_scrollView addSubview:priceLB];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLB.right, priceLB.top, 60, LABEL_HEIGHT)];
    _priceLabel.text = @"30元";
    _priceLabel.textColor = [UIColor whiteColor];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_priceLabel];
    
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(_priceLabel.right, _priceLabel.top + 5, 1, _priceLabel.height - 10)];
    lineview.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:lineview];
    
    UILabel * foodBoxLB = [[UILabel alloc]initWithFrame:CGRectMake(lineview.right, lineview.top - 5, 60, LABEL_HEIGHT)];
    foodBoxLB.text = @"餐盒费:";
    foodBoxLB.textColor = [UIColor whiteColor];
    [_scrollView addSubview:foodBoxLB];
    
    self.foodBoxMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(foodBoxLB.right, foodBoxLB.top, 50, LABEL_HEIGHT)];
    _foodBoxMoneyLabel.text = @"2.0元";
    _foodBoxMoneyLabel.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_foodBoxMoneyLabel];
    
    UIView * lineview1 = [[UIView alloc]initWithFrame:CGRectMake(_foodBoxMoneyLabel.right, _foodBoxMoneyLabel.top + 5, 1, _priceLabel.height - 10)];
    lineview1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:lineview1];
    
    UILabel * integralLB = [[UILabel alloc]initWithFrame:CGRectMake(lineview1.right, lineview1.top - 5, 40, LABEL_HEIGHT)];
    integralLB.text = @"积分:";
    integralLB.textColor = [UIColor whiteColor];
    [_scrollView addSubview:integralLB];
    
    self.integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(integralLB.right, integralLB.top, 50, LABEL_HEIGHT)];
    _integralLabel.text = @"2.0元";
    _integralLabel.textColor = [UIColor whiteColor];
    [_scrollView addSubview:_integralLabel];
    
    
    UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(0, _imageView.bottom, self.view.width, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:nameView];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 80, LABEL_HEIGHT)];
    nameLB.text = @"商品名称:";
    nameLB.textAlignment = NSTextAlignmentCenter;
    [nameView addSubview:nameLB];
    
//    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(nameLB.right, nameLB.top, 1, LABEL_HEIGHT)];
//    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
//    [lineview addSubview:line];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLB.right, TOP_SPACE, self.view.width - 81 - 2 * LEFT_SPACE, LABEL_HEIGHT)];
    self.nameLabel.text = @"我是商品名称_嘎嘎嘎";
    [nameView addSubview:_nameLabel];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, nameView.bottom , _scrollView.width, 1)];
    line4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line4];
    
    UIView * unitView = [[UIView alloc] initWithFrame:CGRectMake(0, line4.bottom , _scrollView.width, 50)];
    unitView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:unitView];
    
    self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, unitView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    _unitLabel.text = @"商品单位:";
    _unitLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_unitLabel];
    
    
    self.unitTF = [[UILabel alloc] initWithFrame:CGRectMake(_unitLabel.right, _unitLabel.top, _scrollView.width - 2 * LEFT_SPACE - _unitLabel.width , LABEL_HEIGHT)];
    [_scrollView addSubview:_unitTF];
    
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, unitView.bottom , _scrollView.width, 1)];
    line5.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [_scrollView addSubview:line5];
    
    UIView * markView = [[UIView alloc] initWithFrame:CGRectMake(0, line5.bottom , _scrollView.width, 50)];
    markView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:markView];
    
    self.markTLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, markView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    _markTLabel.text = @"商品标签:";
    _markTLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_markTLabel];
    
    
    self.markTF = [[UILabel alloc] initWithFrame:CGRectMake(_markTLabel.right, _markTLabel.top, _scrollView.width - 2 * LEFT_SPACE - _markTLabel.width , LABEL_HEIGHT)];
    [_scrollView addSubview:_markTF];
    
    
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(0, markView.bottom , _scrollView.width, 1)];
    line6.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    line6.tag = 2999;
    [_scrollView addSubview:line6];
    
    UIView * describeView = [[UIView alloc] initWithFrame:CGRectMake(0, line6.bottom , _scrollView.width, 70)];
    describeView.backgroundColor = [UIColor whiteColor];
    describeView.tag = 3000;
    [_scrollView addSubview:describeView];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, describeView.top + TOP_SPACE, 80, LABEL_HEIGHT)];
    _describeLabel.text = @"商品描述:";
    _describeLabel.backgroundColor = LABEL_COLOR;
    [_scrollView addSubview:_describeLabel];
    
    
    self.describeTFview = [[UILabel alloc] initWithFrame:CGRectMake(_describeLabel.right, _describeLabel.top, _scrollView.width -  LEFT_SPACE * 2 - _markTLabel.width , LABEL_HEIGHT + 20)];
    _describeTFview.textColor = [UIColor blackColor];
    _describeTFview.font = [UIFont systemFontOfSize:17];
//    _describeTFview.layer.cornerRadius = 5;
//    _describeTFview.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
//    _describeTFview.layer.borderWidth = .7;
    _describeTFview.numberOfLines = 0;
    [_scrollView addSubview:_describeTFview];
    
    
    UIView * separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, describeView.bottom, self.view.width, 1)];
    separatorView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    separatorView.tag = 3001;
    [_scrollView addSubview:separatorView];
    
    self.dishPropertyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, describeView.bottom + 1, self.view.width, 200)];
    _dishPropertyTableView.dataSource = self;
    _dishPropertyTableView.delegate = self;
    [_scrollView addSubview:_dishPropertyTableView];
    [self.dishPropertyTableView registerClass:[TasteDetailsCell class] forCellReuseIdentifier:CELLIDENTIFIRE];
    self.dishPropertyTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    self.dishPropertyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    UIView * buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, _dishPropertyTableView.bottom, self.view.width, 50)];
    buttonView.backgroundColor = [UIColor whiteColor];
    buttonView.tag = 3002;
    [_scrollView addSubview:buttonView];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _clearButton.frame = CGRectMake(0, 0, self.view.width / 3, 50);
    [_clearButton setImage:[[UIImage imageNamed:@"icon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    if ([self.detailMD.mealState isEqual:@1]) {
        [_clearButton setTitle:@"上架" forState:UIControlStateNormal];
    }else if ([self.detailMD.mealState isEqual:@2])
    {
        [_clearButton setTitle:@"沽清" forState:UIControlStateNormal];
    }
    [_clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonView addSubview:_clearButton];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(_clearButton.right, 0, 1, 50)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [buttonView addSubview:line1];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _editButton.frame = CGRectMake(line1.right, 0, self.view.width / 3, 50);
    [_editButton setImage:[[UIImage imageNamed:@"icon2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonView addSubview:_editButton];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_editButton.right, 0, 1, 50)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [buttonView addSubview:line2];
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _deleteButton.frame = CGRectMake(line2.right, 0, self.view.width / 3, 50);
    [_deleteButton setImage:[[UIImage imageNamed:@"icon3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonView addSubview:_deleteButton];

    UIView * BTseparatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    BTseparatorView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [buttonView addSubview:BTseparatorView];
    
    [_deleteButton addTarget:self action:@selector(deleteMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_clearButton addTarget:self action:@selector(clearMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editButton addTarget:self action:@selector(editMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView.contentSize = CGSizeMake(self.view.width, buttonView.bottom);
}

- (void)backLastVC:(id)sender
{
//    self.navigationController.navigationBar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar * bar = self.navigationController.navigationBar;
    [bar setBackgroundImage:[UIImage imageNamed:@"tm.png"] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage imageNamed:@"tm.png"]];
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@63,
                               @"FoodId":@(self.foodId)
                               };
    [self playPostWithDictionary:jsonDic];
    
    NSDictionary * jsonDic1 = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"Command":@60,
                               @"FoodId":@(self.foodId)
                               };
    [self playPostWithDictionary:jsonDic1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    if (_returnValueBlock) {
        _returnValueBlock();
    }
}

#pragma mark - dishPropertyTableView  Datasource And Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, (self.view.width - 40) / 2, 40)];
    titleLabel.text = @"商品属性";
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, self.view.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:titleLabel];
    [view addSubview:line];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasteDetaileArray.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TasteDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIRE forIndexPath:indexPath];
    
    [cell creatSubviews:self.dishPropertyTableView.bounds];
    
    TasteDetailModel * tasteModel = [self.tasteDetaileArray objectAtIndex:indexPath.row];
    
    cell.tasteDetailsView.nameLabel.text = tasteModel.attName;
    cell.tasteDetailsView.integralLabel.text = [NSString stringWithFormat:@"%d", tasteModel.attIntegral];
    cell.tasteDetailsView.priceLabel.text = [NSString stringWithFormat:@"%.2f", tasteModel.attPrice];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)editProperty:(UIButton * )button
{
    MealPropertyViewController * mealVC = [[MealPropertyViewController alloc]init];
    mealVC.foodId = self.foodId;
    [self.navigationController pushViewController:mealVC animated:YES];
}

#pragma mark - 估清,编辑,删除

- (void)deleteMenuAction:(UIButton *)button
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"删除" message:@"确定要删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = DELETEALERT_TAG;
    [alert show];
}

- (void)clearMenuAction:(UIButton *)button
{
    if ([self.detailMD.mealState isEqual:@1]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"上架" message:@"确定要上架?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = CLEARALERT_TAH;
        [alert show];
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"沽清" message:@"确定要沽清?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = CLEARALERT_TAH;
        [alert show];
    }
    
}

- (void)editMenuAction:(UIButton *)button
{
    AddMenuViewController * addMenuVC = [[AddMenuViewController alloc] init];
    addMenuVC.navigationItem.title = @"编辑";
//    addMenuVC.detailMD = self.detailMD;
    addMenuVC.isFromeWaimaiOrTangshi = self.isFromeWaimaiOrTangshi;
    addMenuVC.foodId = self.foodId;
    [self.navigationController pushViewController:addMenuVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DetailModel * detaiMD = self.detailMD;
    if (buttonIndex == 1) {
        //        self.seleteIndex = nil;
        if (alertView.tag == DELETEALERT_TAG) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@13,
                                       @"MealId":detaiMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"正在删除..." maskType:SVProgressHUDMaskTypeBlack];
        }else if (alertView.tag == CLEARALERT_TAH) {
            NSNumber * state = nil;
            if ([detaiMD.mealState isEqual:@1]) {
                state = @2;
            }else if ([detaiMD.mealState isEqual:@2])
            {
                state = @1;
            }
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@14,
                                       @"MealId":detaiMD.mealId,
                                       @"MealState":state
                                       };
            [self playPostWithDictionary:jsonDic];
            if ([state isEqualToNumber:@1]) {
                [SVProgressHUD showWithStatus:@"正在沽清..." maskType:SVProgressHUDMaskTypeBlack];
            }else if ([state isEqualToNumber:@2])
            {
                [SVProgressHUD showWithStatus:@"正在上架..." maskType:SVProgressHUDMaskTypeBlack];
            }
        }
    }
}

#pragma mark - HTTP 
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
    NSLog(@"%@, error = %@", data, [data objectForKey:@"ErrorMsg"]);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        [SVProgressHUD dismiss];
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10014)
        {
            if ([self.detailMD.mealState isEqual:@1]) {
                [_clearButton setTitle:@"沽清" forState:UIControlStateNormal];
            }else if ([self.detailMD.mealState isEqual:@2])
            {
                [_clearButton setTitle:@"上架" forState:UIControlStateNormal];
            }
            
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@63,
                                       @"FoodId":@(self.foodId)
                                       };
            [self playPostWithDictionary:jsonDic];
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"操作成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }else if (command == 10013) {
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
        }else if (command == 10063) {
            
            DetailModel * model = [[DetailModel alloc]initWithDictionary:data];
            
            [self setValueWithMidel:model];
            
        }else if ([[data objectForKey:@"Command"] isEqual:@10060])
        {
            
            if (self.tasteDetaileArray.count != 0) {
                [self.tasteDetaileArray removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"AttList"];
            for (NSDictionary * dic in array) {
                TasteDetailModel * model = [[TasteDetailModel alloc]initWithDiationary:dic];
                [self.tasteDetaileArray addObject:model];
            }
            
            [self.dishPropertyTableView reloadData];
        }
        
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
}

- (void)setValueWithMidel:(DetailModel *)model
{
    
    __weak DishDetailViewController * weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"PHOTO.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
               // 高斯模糊
        if (image) {
            [weakSelf.imageView setImage:[Tool blurryImage:image withBlurLevel:0.4]];
        }
        
    }];
    
    self.saleCountLabel.text = [NSString stringWithFormat:@"%@", model.soldCount];
    _priceLabel.text = [NSString stringWithFormat:@"%@", model.money];

    _foodBoxMoneyLabel.text = [NSString stringWithFormat:@"%@", model.foodBoxMoney];

    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    self.integralLabel.text = [NSString stringWithFormat:@"%d", model.integral];
    self.unitTF.text = [NSString stringWithFormat:@"%@", model.unit];
    self.markTF.text = [NSString stringWithFormat:@"%@", model.mark];
    if ([model.describe isEqualToString:@"请填入商品描述(选填)"] || model.describe.length == 0) {
        self.describeTFview.text = @"暂无描述";
        
    }else
    {
        self.describeTFview.text = [NSString stringWithFormat:@"%@", model.describe];
    }
//    NSLog(@"self.describeTFview.text = %@", [NSString stringWithFormat:@"%@", model.describe]);
    
    // 计算字符串高度

    NSString * str = model.describe;
    CGSize maxsize = CGSizeMake(_describeTFview.width, 1000);
    CGRect textRect = [str boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    if (textRect.size.height >= LABEL_HEIGHT) {
        _describeTFview.frame = CGRectMake(_describeLabel.right, _describeLabel.top, _scrollView.width -  LEFT_SPACE * 2 - _markTLabel.width , textRect.size.height);
    }else
    {
        _describeTFview.frame = CGRectMake(_describeLabel.right, _describeLabel.top, _scrollView.width -  LEFT_SPACE * 2 - _markTLabel.width , LABEL_HEIGHT);
    }
    
    UIView * line6 = [_scrollView viewWithTag:2999];
    
    UIView * describeView = [_scrollView viewWithTag:3000];
    describeView.frame = CGRectMake(0, line6.bottom , _scrollView.width, _describeTFview.height + 20);
    
    UIView * separateLine = [_scrollView viewWithTag:3001];
    separateLine.frame = CGRectMake(0, describeView.bottom, self.view.width, 1);
    
    self.dishPropertyTableView.frame = CGRectMake(0, describeView.bottom + 1, self.view.width, 200);
    
    UIView * buttonView = [_scrollView viewWithTag:3002];
    buttonView.frame = CGRectMake(0, _dishPropertyTableView.bottom, self.view.width, 50);
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width, buttonView.bottom);
}

- (void)returnPropertyValue:(ReturnValueBlock)valueBlock
{
    _returnValueBlock = valueBlock;
}


@end
