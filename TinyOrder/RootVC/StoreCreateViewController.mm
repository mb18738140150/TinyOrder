//
//  StoreCreateViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/8/19.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "StoreCreateViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
#import "TJScrollView.h"
#import <AFNetworking.h>
#import "LoginViewController.h"
#import "TJHoursView.h"
#import "UserInfo.h"
#import "OutSendPriceView.h"
#import <UIImageView+WebCache.h>

#define LEFT_SPACE 10
#define TOP_SPACE 10

#define TYPE_BT_SPACE 15
#define BUTTON_WIDTH ((scrollView.width - 5 * TYPE_BT_SPACE) / 4)
#define BUTTON_HEIGHT 25

#define LINE_COLOR [UIColor colorWithWhite:0.7 alpha:1]

#define StartSpace @"StartSpace"
#define EndSpace @"EndSpace"
#define SpaceDelivery @"SpaceDelivery"
#define SpaceSendPrice @"SpaceSendPrice"

@interface StoreCreateViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, HTTPPostDelegate>

{
    /**
     *  店铺类型
     */
    NSInteger _storeType;
}
/**
 *  店铺图标
 */
@property (nonatomic, strong)UIImage * logoImage;
/**
 *  选择店铺图标按钮
 */
@property (nonatomic, strong)UIButton * logoBT;
@property (nonatomic, strong)UIImageView * logoImageview;
/**
 *  二维码
 */
@property (nonatomic, strong)UIImage * barcodeImage;
/**
 *  选择二维码图片按钮
 */
@property (nonatomic, strong)UIButton * barcodeBT;
@property (nonatomic, strong)UIImageView * baImageView;

@property (nonatomic, strong)UIImageView * selectImageBT;
/**
 *  店铺名称输入框
 */
@property (nonatomic, strong)UITextField * nameTF;
/**
 *  联系电话输入框
 */
@property (nonatomic, strong)UITextField * phoneTF;
/**
 *  选择开始时间的按钮
 */
@property (nonatomic, strong)UIButton * startBT;
/**
 *  选择结束时间的按钮
 */
@property (nonatomic, strong)UIButton * endBT;
//@property (nonatomic, strong)UIButton * timeBT;
// 餐具费
@property (nonatomic, strong)UITextField * tablewarefeeTF;
/**
 *  预计送达时间输入框
 */
@property (nonatomic, strong)UITextField * sendTimeTF;
/**
 *  配送范围输入框
 */
@property (nonatomic, strong)UITextField * scopeTF;
/**
 *  地图
 */
@property (nonatomic, strong)BMKMapView * locationView;
@property (nonatomic, strong)BMKLocationService * locService;
@property (nonatomic, strong)BMKGeoCodeSearch * geoSearcher;
@property (nonatomic, assign)id annotation;
@property (nonatomic, assign)id tapAnnotation;
/**
 *  点击设置店铺位置按钮
 */
@property (nonatomic, strong)UIButton * mapBT;
/**
 *  详细地址输入框
 */
@property (nonatomic, copy)NSString * address;
@property (nonatomic, strong)UITextField * storeAddressTF;
/**
 *  起送价输入框
 */
@property (nonatomic, strong)UITextField * sendPriceTF;
/**
 *  配送费输入框
 */
@property (nonatomic, strong)UITextField * outSendPriceTF;
/**
 *  公告输入框
 */
@property (nonatomic, strong)UITextView * noticeTV;
/**
 *  店铺简介输入
 */
@property (nonatomic, strong)UITextView * introTV;
/**
 *  营业开始时间
 */
@property (nonatomic, strong)NSNumber * startDate;
/**
 *  营业结束时间
 */
@property (nonatomic, strong)NSNumber * endDate;
/**
 *  当天日期
 */
@property (nonatomic, copy)NSString * today;

@property (nonatomic)CLLocationCoordinate2D coor;

@property (nonatomic, assign)double lon;
@property (nonatomic, assign)double lat;
@property (nonatomic, assign)int createNum;

@property (nonatomic, strong)UIButton * addsendPriceBT;
@property (nonatomic, strong)UIView * describView;

// 弹出框
@property (nonatomic, strong)UIView * tanchuView;

// 添加不同距离配送费信息视图
@property (nonatomic, strong)UIView * priceForDistanceView;

@property (nonatomic, strong)UITextField * startDistanceTF;
@property (nonatomic, strong)UITextField * endDistanceTF;
@property (nonatomic, strong)UITextField * spaceDeliveryTF;
@property (nonatomic, strong)UITextField * spaceSendPriceTF;

// 不同距离配送费数组
@property (nonatomic, strong)NSMutableArray * priceForDistanceArray;
@property (nonatomic, strong)NSMutableArray * priceForDistanceViewArray;
@property (nonatomic, assign)int number;

@end

@implementation StoreCreateViewController

- (NSMutableArray *)priceForDistanceArray
{
    if (!_priceForDistanceArray) {
        self.priceForDistanceArray = [NSMutableArray array];
    }
    return _priceForDistanceArray;
}

- (NSMutableArray *)priceForDistanceViewArray
{
    if (!_priceForDistanceViewArray) {
        self.priceForDistanceViewArray = [NSMutableArray array];
    }
    return _priceForDistanceViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加店铺";
    self.view.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    
    self.number = 0;
    self.createNum = 0;
    
    TJScrollView * scrollView = [[TJScrollView  alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.bottom)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    scrollView.directionalLockEnabled = YES;
    scrollView.tag = 1001;
//    scrollView.userInteractionEnabled = NO;
    [self.view addSubview:scrollView];
    
    
    UILabel * logoLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE, 100, 20)];
    logoLB.text = @"店铺图标";
    [scrollView addSubview:logoLB];
    
    self.logoBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _logoBT.frame = CGRectMake(scrollView.width - LEFT_SPACE - 75, TOP_SPACE, 75, 75);
    [_logoBT setBackgroundImage:[UIImage imageNamed:@"uploading.png"] forState:UIControlStateNormal];
    [_logoBT addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:_logoBT];
    logoLB.centerY = _logoBT.centerY;
    
    self.logoImageview = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.width - LEFT_SPACE - 75, TOP_SPACE, 75, 75)];
    _logoImageview.image = [UIImage imageNamed:@"uploading.png"];
    _logoImageview.userInteractionEnabled = YES;
    [scrollView addSubview:_logoImageview];
    
//    self.logoImageview = [[UIImageView alloc]init];
//    _logoImageview.frame = _logoBT.frame;
//    _logoImageview.userInteractionEnabled = YES;
//    
    UITapGestureRecognizer * logoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage:)];
    
    [_logoImageview addGestureRecognizer:logoTap];
//    __weak StoreCreateViewController * storVC = self;
//    
//    [_logoImageview addGestureRecognizer:logoTap];
//    [scrollView addSubview:_logoImageview];
//    [_logoImageview sd_setImageWithURL:[NSURL URLWithString:self.logoURL] placeholderImage:[UIImage imageNamed:@"uploading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        storVC.logoImage = image;
//    }];
    
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _logoBT.bottom + TOP_SPACE, scrollView.width, 0.5)];
    line1.backgroundColor = LINE_COLOR;
    [scrollView addSubview:line1];
    
    
    UILabel * barcodeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line1.bottom, 100, 20)];
    barcodeLB.text = @"店铺二维码";
    [scrollView addSubview:barcodeLB];
    
    self.barcodeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _barcodeBT.frame = CGRectMake(scrollView.width - LEFT_SPACE - 75, TOP_SPACE + line1.bottom, 75, 75);
    [_barcodeBT setBackgroundImage:[UIImage imageNamed:@"uploading.png"] forState:UIControlStateNormal];
    [_barcodeBT addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:_barcodeBT];
    barcodeLB.centerY = _barcodeBT.centerY;
    
    self.baImageView = [[UIImageView alloc]initWithFrame:CGRectMake(scrollView.width - LEFT_SPACE - 75, TOP_SPACE + line1.bottom, 75, 75)];
    _baImageView.image = [UIImage imageNamed:@"uploading.png"];
    _baImageView.userInteractionEnabled = YES;
    [scrollView addSubview:_baImageView];
    UITapGestureRecognizer * baTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage:)];
    [_baImageView addGestureRecognizer:baTap];
    
    

    
//    self.baImageView = [[UIImageView alloc]init];
//    _baImageView.frame = _logoBT.frame;
//    _baImageView.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer * baTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage:)];
//    
//    [_logoImageview addGestureRecognizer:baTap];
//    [scrollView addSubview:_baImageView];
//    [_logoImageview sd_setImageWithURL:[NSURL URLWithString:self.barcodeURL] placeholderImage:[UIImage imageNamed:@"uploading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        storVC.barcodeImage = image;
//    }];
    
    
//    __weak StoreCreateViewController * storeVC = self;
//    
//    UIImageView * logoview = [[UIImageView alloc]init];
//    logoview.frame = self.logoBT.frame;
//    [logoview sd_setImageWithURL:[NSURL URLWithString:self.logoURL] placeholderImage:[UIImage imageNamed:@"uploading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            storeVC.logoImage = image;
//            [storeVC.logoBT setBackgroundImage:image forState:UIControlStateNormal];
//        }
//    }];
//    
//    
//    UIImageView * barcodeImageView = [[UIImageView alloc]init];
//    barcodeImageView.frame = _barcodeBT.frame;
//    
//    [barcodeImageView sd_setImageWithURL:[NSURL URLWithString:self.barcodeURL] placeholderImage:[UIImage imageNamed:@"uploading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
////        NSLog(@"************^^^^^^^^^^^^^^^^^^^******************");
//        if (image) {
//            storeVC.barcodeImage = image;
//            [storeVC.barcodeBT setBackgroundImage:image forState:UIControlStateNormal];
////            NSLog(@"******************************");
//        }
//        
//    }];
    
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, _barcodeBT.bottom + TOP_SPACE, scrollView.width, 0.5)];
    line2.backgroundColor = LINE_COLOR;
    [scrollView addSubview:line2];
    
    UILabel * typeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line2.bottom, 100, 30)];
    typeLB.text = @"选择分类";
    [scrollView addSubview:typeLB];
    
    NSArray * array = @[@"美食", @"甜点饮品", @"水果", @"超市", @"零食小吃", @"鲜花蛋糕", @"送药上门", @"蔬菜"];
    for (int i = 0; i < array.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        int x = i % 4;
        int y = i / 4;
        button.frame = CGRectMake(TYPE_BT_SPACE + (TYPE_BT_SPACE + BUTTON_WIDTH) * x, typeLB.bottom + y * (BUTTON_HEIGHT + TOP_SPACE) + TOP_SPACE, BUTTON_WIDTH, BUTTON_HEIGHT);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 20001 + i;
        button.layer.cornerRadius = 2;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.3 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(storeTypeChange:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0, typeLB.bottom + BUTTON_HEIGHT * 2 + TOP_SPACE * 3, scrollView.width, 0.5)];
    line3.backgroundColor = LINE_COLOR;
    [scrollView addSubview:line3];
    
    
    UILabel * nameLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + line3.bottom, 100, 30)];
    nameLB.text = @"店铺名称";
    [scrollView addSubview:nameLB];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE, nameLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    _nameTF.placeholder = @"请输入店铺名称";
    _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_nameTF];
    
    
    UILabel * phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _nameTF.bottom, 100, 30)];
    phoneLB.text = @"联系电话";
    [scrollView addSubview:phoneLB];
    
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE, phoneLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    _phoneTF.placeholder = @"请输入联系电话";
    _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
    _phoneTF.keyboardType = UIKeyboardTypePhonePad;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_phoneTF];
    
    
    UILabel * timeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _phoneTF.bottom, 100, 30)];
    timeLB.text = @"营业时间";
    [scrollView addSubview:timeLB];
    
    self.startBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBT.frame = CGRectMake(LEFT_SPACE, timeLB.bottom, (scrollView.width - 2 * LEFT_SPACE - 45) / 2, 30);
    _startBT.backgroundColor = [UIColor whiteColor];
    _startBT.layer.cornerRadius = 5;
    _startBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _startBT.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [_startBT setTitle:@"开始时间" forState:UIControlStateNormal];
    [_startBT setTitleColor:[UIColor colorWithWhite:0.75 alpha:1] forState:UIControlStateNormal];
    [_startBT addTarget:self action:@selector(changeOpenTime:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_startBT];
    
    UILabel * centerXLB = [[UILabel alloc] initWithFrame:CGRectMake(_startBT.right, _startBT.top, 45, _startBT.height)];
    centerXLB.text = @"至";
    centerXLB.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:centerXLB];
    
    self.endBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _endBT.frame = CGRectMake(centerXLB.right, _startBT.top, _startBT.width, _startBT.height);
    _endBT.backgroundColor = [UIColor whiteColor];
    _endBT.layer.cornerRadius = 5;
    _endBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _endBT.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [_endBT setTitle:@"结束时间" forState:UIControlStateNormal];
    [_endBT setTitleColor:[UIColor colorWithWhite:0.75 alpha:1] forState:UIControlStateNormal];
    [_endBT addTarget:self action:@selector(changeOpenTime:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_endBT];
    
    UILabel * tablewarefeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _endBT.bottom, 180, 30)];
    tablewarefeeLabel.text = @"餐具费（堂食专用）";
    [scrollView addSubview:tablewarefeeLabel];
    
    UIView * tablewarefeeView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, tablewarefeeLabel.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    tablewarefeeView.backgroundColor = [UIColor whiteColor];
    tablewarefeeView.layer.cornerRadius = 5;
    tablewarefeeView.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    tablewarefeeView.layer.borderWidth = 0.6;
    [scrollView addSubview:tablewarefeeView];
    
    self.tablewarefeeTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE / 2, 0, tablewarefeeView.width - LEFT_SPACE - 45, tablewarefeeView.height)];
    _tablewarefeeTF.placeholder = @"送达时间";
    _tablewarefeeTF.borderStyle = UITextBorderStyleNone;
    _tablewarefeeTF.keyboardType = UIKeyboardTypeNumberPad;
    _tablewarefeeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tablewarefeeTF.delegate = self;
    [tablewarefeeView addSubview:_tablewarefeeTF];
    
    UILabel * tablewarefeeLB = [[UILabel alloc] initWithFrame:CGRectMake(_tablewarefeeTF.right , 0, 45, _tablewarefeeTF.height)];
    tablewarefeeLB.text = @"元/人";
    tablewarefeeLB.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [tablewarefeeView addSubview:tablewarefeeLB];
    
    UILabel * sendTimeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + tablewarefeeView.bottom, 120, 30)];
    sendTimeLB.text = @"预计送达时间";
    [scrollView addSubview:sendTimeLB];
    
    UIView * sendTimeView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, sendTimeLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    sendTimeView.backgroundColor = [UIColor whiteColor];
    sendTimeView.layer.cornerRadius = 5;
    sendTimeView.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    sendTimeView.layer.borderWidth = 0.6;
    [scrollView addSubview:sendTimeView];
    
    self.sendTimeTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE / 2, 0, sendTimeView.width - LEFT_SPACE - 45, sendTimeView.height)];
    _sendTimeTF.placeholder = @"送达时间";
    _sendTimeTF.borderStyle = UITextBorderStyleNone;
    _sendTimeTF.keyboardType = UIKeyboardTypeNumberPad;
    _sendTimeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sendTimeTF.delegate = self;
    [sendTimeView addSubview:_sendTimeTF];
    
    UILabel * timeUnitLB = [[UILabel alloc] initWithFrame:CGRectMake(_sendTimeTF.right + LEFT_SPACE / 2, 0, 40, _sendTimeTF.height)];
    timeUnitLB.text = @"分钟";
    timeUnitLB.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [sendTimeView addSubview:timeUnitLB];
    
    
    UILabel * scopeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + sendTimeView.bottom, 100, 30)];
    scopeLB.text = @"配送范围";
    [scrollView addSubview:scopeLB];
    
    UIView * scopeView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, scopeLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    scopeView.backgroundColor = [UIColor whiteColor];
    scopeView.layer.cornerRadius = 5;
    scopeView.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    scopeView.layer.borderWidth = 0.6;
    [scrollView addSubview:scopeView];
    
    self.scopeTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE / 2, 0, scopeView.width - LEFT_SPACE - 35, scopeView.height)];
    _scopeTF.placeholder = @"配送范围";
    _scopeTF.borderStyle = UITextBorderStyleNone;
    _scopeTF.keyboardType = UIKeyboardTypeNumberPad;
    _scopeTF.delegate = self;
    _scopeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scopeView addSubview:_scopeTF];
    
    UILabel * unitLB = [[UILabel alloc] initWithFrame:CGRectMake(_scopeTF.right + LEFT_SPACE / 2, 0, 30, _scopeTF.height)];
    unitLB.text = @"KM";
    unitLB.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [scopeView addSubview:unitLB];
    
    UILabel * locationLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + scopeView.bottom, 100, 30)];
    locationLB.text = @"地图位置";
    [scrollView addSubview:locationLB];
    
    UIButton * locationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBT.frame = CGRectMake(LEFT_SPACE + 5, locationLB.bottom, 180, 20);
    [locationBT setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [locationBT setTitle:@"点击设置店铺地图位置" forState:UIControlStateNormal];
    [locationBT setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    locationBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [locationBT addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    locationBT.titleLabel.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:locationBT];
    
    self.locationView = [[BMKMapView alloc] initWithFrame:CGRectMake(LEFT_SPACE, locationBT.bottom + TOP_SPACE, scrollView.width - 2 * LEFT_SPACE, 200)];
    _locationView.backgroundColor = [UIColor whiteColor];
    _locationView.layer.cornerRadius = 5;
    _locationView.delegate = self;
    _locationView.userTrackingMode = BMKUserTrackingModeFollow;
    _locationView.zoomLevel = 17.f;
    _locationView.showsUserLocation = YES;
    [scrollView addSubview:_locationView];
    
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //初始化BMKLocationService
    self.locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    self.geoSearcher =[[BMKGeoCodeSearch alloc]init];
    _geoSearcher.delegate = self;
    
    
    UILabel * addressLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _locationView.bottom, 100, 30)];
    addressLB.text = @"详细地址";
    [scrollView addSubview:addressLB];
    /*
    self.addressTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE, addressLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    _addressTF.placeholder = @"请输入详细地址";
    _addressTF.borderStyle = UITextBorderStyleRoundedRect;
//    _addressTF.keyboardType = UIKeyboardTypePhonePad;
    _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addressTF.font = [UIFont systemFontOfSize:14];
    _addressTF.enabled = NO;
    [scrollView addSubview:_addressTF];
    */
    self.storeAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE, addressLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    _storeAddressTF.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _storeAddressTF.layer.cornerRadius = 6;
    _storeAddressTF.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    _storeAddressTF.layer.borderWidth = 0.6f;
    _storeAddressTF.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:_storeAddressTF];
    
    
    UILabel * sendLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _storeAddressTF.bottom, 100, 30)];
    sendLB.text = @"起送价";
    [scrollView addSubview:sendLB];
    
    UIView * sendView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, sendLB.bottom, scrollView.width - 2 * LEFT_SPACE, 40)];
    sendView.backgroundColor = [UIColor whiteColor];
    sendView.layer.cornerRadius = 5;
    sendView.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    sendView.layer.borderWidth = 0.6;
    [scrollView addSubview:sendView];
    
    self.sendPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE / 2, 0, sendView.width - LEFT_SPACE - 35, sendView.height)];
    _sendPriceTF.placeholder = @"请输入起送价";
    _sendPriceTF.borderStyle = UITextBorderStyleNone;
    _sendPriceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _sendPriceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sendPriceTF.delegate = self;
    [sendView addSubview:_sendPriceTF];
    
    UILabel * unitLB1 = [[UILabel alloc] initWithFrame:CGRectMake(_sendPriceTF.right + LEFT_SPACE / 2, 0, 30, _sendPriceTF.height)];
    unitLB1.text = @"元";
    unitLB1.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [sendView addSubview:unitLB1];
    
    UILabel * outSendLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + sendView.bottom, 100, 30)];
    outSendLB.text = @"配送费";
    [scrollView addSubview:outSendLB];
    
    UIView * outSendView = [[UIView alloc] initWithFrame:CGRectMake(LEFT_SPACE, outSendLB.bottom, scrollView.width - 2 * LEFT_SPACE , 40)];
    outSendView.backgroundColor = [UIColor whiteColor];
    outSendView.layer.cornerRadius = 5;
    outSendView.layer.borderColor = [UIColor colorWithWhite:0.75 alpha:1].CGColor;
    outSendView.layer.borderWidth = 0.6;
    outSendView.tag = 2000;
    [scrollView addSubview:outSendView];
    
    self.outSendPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_SPACE / 2, 0, outSendView.width - LEFT_SPACE - 35, outSendView.height)];
    _outSendPriceTF.placeholder = @"请输入配送费";
    _outSendPriceTF.borderStyle = UITextBorderStyleNone;
    _outSendPriceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _outSendPriceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _outSendPriceTF.delegate = self;
    [outSendView addSubview:_outSendPriceTF];
    
    UILabel * unitLB2 = [[UILabel alloc] initWithFrame:CGRectMake(_outSendPriceTF.right + LEFT_SPACE / 2, 0, 30, _outSendPriceTF.height)];
    unitLB2.text = @"元";
    unitLB2.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    [outSendView addSubview:unitLB2];
    
    self.addsendPriceBT = [UIButton buttonWithType:UIButtonTypeSystem];
    _addsendPriceBT.frame = CGRectMake(outSendView.left, outSendView.bottom + TOP_SPACE, outSendView.width, outSendView.height);
    _addsendPriceBT.backgroundColor = [UIColor whiteColor];
    [_addsendPriceBT setTitle:@"按距离添加配送费起送价" forState:UIControlStateNormal];
    [_addsendPriceBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addsendPriceBT addTarget:self action:@selector(choceTasteAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:_addsendPriceBT];
    
    self.describView = [[UIView alloc]initWithFrame:CGRectMake(0, _addsendPriceBT.bottom + TOP_SPACE, self.view.width, 0)];
    [scrollView addSubview:_describView];
    _describView.hidden = YES;
    
    UILabel * distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(LEFT_SPACE, 0, (self.view.width - 5 * LEFT_SPACE) / 3, 30)];
    distanceLabel.text = @"距离";
    [_describView addSubview:distanceLabel];
    
    UILabel * sendpriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(distanceLabel.right, 0, distanceLabel.width, distanceLabel.height)];
    sendpriceLabel.text = @"配送费";
    [_describView addSubview:sendpriceLabel];
    
    UILabel * startsendprice = [[UILabel alloc]initWithFrame:CGRectMake(sendpriceLabel.right, 0, sendpriceLabel.width, sendpriceLabel.height)];
    startsendprice.text = @"起送价";
    [_describView addSubview:startsendprice];
    
    
    UILabel * noticeLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _describView.bottom, 100, 30)];
    noticeLB.text = @"店铺公告";
    noticeLB.tag = 2001;
    [scrollView addSubview:noticeLB];
    
    self.noticeTV = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_SPACE, noticeLB.bottom, scrollView.width - 2 * LEFT_SPACE, 70)];
    _noticeTV.tag = 2002;
    _noticeTV.textColor = [UIColor colorWithWhite:0.75 alpha:1];
    _noticeTV.text = @"请填入店铺公告";
    _noticeTV.font = [UIFont systemFontOfSize:14];
    _noticeTV.layer.cornerRadius = 5;
    _noticeTV.delegate = self;
    [scrollView addSubview:_noticeTV];
    
    
    UILabel * introLB = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_SPACE, TOP_SPACE + _noticeTV.bottom, 100, 30)];
    introLB.text = @"店铺简介";
    introLB.tag = 2003;
    [scrollView addSubview:introLB];
    
    self.introTV = [[UITextView alloc] initWithFrame:CGRectMake(LEFT_SPACE, introLB.bottom, scrollView.width - 2 * LEFT_SPACE, 70)];
    _introTV.textColor = [UIColor colorWithWhite:0.75 alpha:1];
    _introTV.text = @"请填入店铺简介";
    _introTV.tag = 2004;
    _introTV.font = [UIFont systemFontOfSize:14];
    _introTV.layer.cornerRadius = 5;
    _introTV.delegate = self;
    [scrollView addSubview:_introTV];
    
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.tag = 2005;
    saveButton.frame = CGRectMake(LEFT_SPACE, _introTV.bottom + TOP_SPACE, scrollView.width - 2 * LEFT_SPACE, 35);
    saveButton.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 5;
    [saveButton addTarget:self action:@selector(createStoreAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:saveButton];
    
    
    scrollView.contentSize = CGSizeMake(scrollView.width, saveButton.bottom + TOP_SPACE * 3);
    
    
    LoginViewController * loginVC = (LoginViewController *)self.navigationController.topViewController;
    NSLog(@"1 VC= %@, VC2 = %@", loginVC, [self.navigationController.viewControllers firstObject]);
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.tanchuView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tanchuView.backgroundColor = [UIColor clearColor];
    
    NSDictionary * jsonDic = @{
                               @"Command":@64,
                               @"UserId":[UserInfo shareUserInfo].userId
                               };
    [self playPostWithDictionary:jsonDic];
    
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate * date = [NSDate date];
    NSDateFormatter* matter = [[NSDateFormatter alloc] init];
    [matter setDateStyle:NSDateFormatterFullStyle];
    [matter setDateFormat:@"yyyy-MM-dd"];
    self.today = [matter stringFromDate:date];
    [_locationView viewWillAppear];
    _locationView.delegate = self;
    _locService.delegate = self;
    _geoSearcher.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_locationView viewWillDisappear];
    _locationView.delegate = nil;
    _locService.delegate = nil;
    _geoSearcher.delegate = nil;
}


- (void)storeTypeChange:(UIButton *)button
{
    TJScrollView * scrollView = (TJScrollView *)[self.view viewWithTag:1001];
    UIButton * lastBT = (UIButton *)[scrollView viewWithTag:_storeType + 20000];
    lastBT.backgroundColor = [UIColor whiteColor];
    lastBT.selected = NO;
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        _storeType = button.tag - 20000;
    }else
    {
        button.backgroundColor = [UIColor whiteColor];
    }
}

- (void)changeImage:(UITapGestureRecognizer *)button
{
    NSLog(@"123 - 选择图片");
    self.selectImageBT = (UIImageView *)button.view;
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中获取", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)changeOpenTime:(UIButton *)button
{
    NSMutableArray * array = [NSMutableArray array];
    if ([button isEqual:self.startBT]) {
        if (self.endDate != nil) {
            for (int i = 0; i < self.endDate.intValue - 1; i++) {
                [array addObject:[NSNumber numberWithInt:i]];
            }
        }else
        {
            for (int i = 0; i < 23; i++) {
                [array addObject:[NSNumber numberWithInt:i]];
            }
        }
    }else if ([button isEqual:self.endBT]) {
        if (self.startDate != nil) {
            for (int i = self.startDate.intValue + 1; i < 24; i++) {
                [array addObject:[NSNumber numberWithInt:i]];
            }
        }else
        {
            for (int i = 1; i < 24; i++) {
                [array addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    __weak StoreCreateViewController * storeVC = self;
    TJHoursView * dateView = [[TJHoursView alloc] initWithDataArray:[array copy]];
    [dateView finishSelectComplete:^(NSNumber *date) {
        NSLog(@"%@", date);
        [button setTitle:[NSString stringWithFormat:@"%@点", date] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
        if ([button isEqual:storeVC.startBT]) {
            storeVC.startDate = date;
        }else if ([button isEqual:storeVC.endBT])
        {
            storeVC.endDate = date;
        }
    }];
    [self.view.window addSubview:dateView];
}

- (void)locationAction:(UIButton *)button
{
    NSLog(@"加载地图");
    [_locService stopUserLocationService];
    [_locService startUserLocationService];
//    _locationView.showsUserLocation = NO;
//    _locationView.userTrackingMode = BMKUserTrackingModeFollow;
//    _locationView.showsUserLocation = YES;
}

- (void)createStoreAction:(UIButton *)button
{
    NSLog(@"创建门店");
    if (self.logoImage == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择店铺图标" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.barcodeImage == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择店铺二维码" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (_storeType == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择店铺类型" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.nameTF.text == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入店铺名称" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.phoneTF.text == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入联系电话" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.startDate == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择店铺营业开始时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.endDate == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择店铺营业结束时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.sendTimeTF.text == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入预计送达时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.scopeTF.text == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入配送范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.storeAddressTF.text.length == 0 || self.coor.latitude == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请选择店铺位置" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.sendPriceTF.text == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入起送价" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else if (self.outSendPriceTF.text == nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入配送费" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:nil afterDelay:1.5];
    }else
    {
        [SVProgressHUD showWithStatus:@"正在保存中..." maskType:SVProgressHUDMaskTypeBlack];
        [self uploadImageWithUrlString:@"http://p.vlifee.com/uploadimg.aspx?savetype=4" image:self.logoImage type:1];
        [self uploadImageWithUrlString:@"http://p.vlifee.com/uploadimg.aspx?savetype=4" image:self.barcodeImage type:2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
                imagePC.delegate = self;
                imagePC.allowsEditing = YES;
                imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePC animated:YES completion:nil];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相机,请你选择图库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
            imagePC.delegate = self;
            imagePC.allowsEditing = YES;
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePC animated:YES completion:nil];
            //            NSLog(@"相册");
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - TxetField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSString * text = textField.text;
    if ([textField isEqual:self.scopeTF] || [textField isEqual:self.sendPriceTF] || [textField isEqual:self.outSendPriceTF]) {
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        BOOL a = [string isEqualToString:filtered];
        return a;
    }else if ([textField isEqual:self.sendTimeTF])
    {
        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"] invertedSet];
        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
        BOOL a = [string isEqualToString:filtered];
        return a;
    }
    return YES;
}


#pragma mark - TxetView Delegate 

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:_introTV]) {
        if ([textView.text isEqualToString:@"请填入店铺简介"] || textView.text.length == 0) {
            textView.text = @"";
            textView.textColor = [UIColor colorWithWhite:0.15 alpha:1];
        }
    }else if ([textView isEqual:_noticeTV]) {
        if ([textView.text isEqualToString:@"请填入店铺公告"] || textView.text.length == 0) {
            textView.text = @"";
            textView.textColor = [UIColor colorWithWhite:0.15 alpha:1];
        }
    }
}


#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self.selectImageBT isEqual:self.logoImageview]) {
//        NSLog(@"1 - %@", self.selectImageBT);
        self.logoImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        [self.logoBT setBackgroundImage:self.logoImage forState:UIControlStateNormal];
        self.logoImageview.image = self.logoImage;
    }else if ([self.selectImageBT isEqual:self.baImageView])
    {
//        NSLog(@"2 - %@", self.selectImageBT);
        self.barcodeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//        [self.barcodeBT setBackgroundImage:self.barcodeImage forState:UIControlStateNormal];
        self.baImageView.image = self.barcodeImage;
    }
//    NSLog(@"logo %@, bar %@", self.logoImage, self.barcodeBT);
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 地图 BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        if ([annotation isEqual:_annotation]) {
            newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        }else
        {
            newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        }
        // 从天上掉下效果
        newAnnotationView.animatesDrop = YES;
        NSLog(@"标注view");
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    NSLog(@"+++++ %@", mapPoi.text);
    [_locationView removeAnnotation:_annotation];
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = mapPoi.pt;
    _annotation = annotation;
    [_locationView addAnnotation:annotation];
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = mapPoi.pt;
    BOOL flag = [_geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"lat = %f, lon = %f", coordinate.latitude, coordinate.longitude);
    self.lon = coordinate.longitude;
    self.lat = coordinate.latitude;
    [_locationView removeAnnotation:_annotation];
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    _annotation = annotation;
    [_locationView addAnnotation:annotation];
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - 定位

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_locationView updateLocationData:userLocation];
    [_locService stopUserLocationService];
//    NSLog(@"定位");
    if (userLocation.location != nil) {
        [_locationView removeAnnotation:_annotation];
        [_locationView updateLocationData:userLocation];
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = userLocation.location.coordinate;
        annotation.title = userLocation.title;
        _annotation = annotation;
        [_locationView addAnnotation:annotation];
        [_locationView setCenterCoordinate:annotation.coordinate];
        //    NSLog(@"title = %@, subtitle = %@", userLocation.title, userLocation.subtitle);
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
        BOOL reverseGeoFlag;
        BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        BOOL geoFlag;
        
        if (self.address.length != 0) {
#warning 按返回地址定位
            geocodeSearchOption.address = self.address ;
            geoFlag = [_geoSearcher geoCode:geocodeSearchOption];
        }else
        {
            reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
            reverseGeoFlag = [_geoSearcher reverseGeoCode:reverseGeoCodeSearchOption];
        }
        if(reverseGeoFlag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
        
        if(geoFlag)
        {
            NSLog(@"geo检索发送成功");
        }
        else
        {
            NSLog(@"geo检索发送失败");
        }
        
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位失败 error = %@", error);
}


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.storeAddressTF.text = [NSString stringWithFormat:@" %@", result.address];
        self.coor = result.location;
        
        [_locationView removeAnnotation:_annotation];
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = result.location;
        annotation.title = result.address;
        _annotation = annotation;
        [_locationView addAnnotation:annotation];
        [_locationView setCenterCoordinate:annotation.coordinate];
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //        result.addressDetail.district
        NSLog(@"处理结果2 %@, %@, %@ %@", result.address, result.addressDetail.streetName, result.addressDetail.streetNumber, result.addressDetail.district);
        self.storeAddressTF.text = [NSString stringWithFormat:@" %@,%@,%@,%@%@", result.addressDetail.province, result.addressDetail.city, result.addressDetail.district, result.addressDetail.streetName, result.addressDetail.streetNumber];
        self.coor = result.location;
//        self.lon = self.coor.longitude;
//        self.lat = self.coor.latitude;
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)dealloc
{
    if (_locationView) {
        _locationView = nil;
        _locService = nil;
        _geoSearcher = nil;
    }
    NSLog(@"店面添加销毁");
}


#pragma mark - 数据请求 图片上传

- (void)uploadImageWithUrlString:(NSString *)urlString image:(UIImage *)image type:(int)type
{
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString * imageName = [self imageNameWithType:type];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:YES];
    __weak StoreCreateViewController * storeVC = self;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];

    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
        //        [formData appendPartWithFormData:imageData name:imageName];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"Result"] integerValue] == 1) {
            if (type == 1) {
                storeVC.logoURL = [responseObject objectForKey:@"ImgPath"];
            }else if (type == 2)
            {
                storeVC.barcodeURL = [responseObject objectForKey:@"ImgPath"];
            }
            if (self.changestore == 1) {
                if (_createNum == 1) {
                    [storeVC createStoreVC:storeVC];
                }
                _createNum++;
            }else
            {
                if (storeVC.barcodeURL != nil && storeVC.logoURL != nil) {
                    [storeVC createStoreVC:storeVC];
                }
            }
        }else
        {
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片添加失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"%@", error);
    }];
    
}


- (NSString *)imageNameWithType:(int)type
{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [myFormatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"t%@%lld%d.png", strTime, arc4random() % 9000000000 + 1000000000, type];
    //    NSLog(@"%lld", arc4random() % 9000000000 + 1000000000);
    return name;
}

- (NSString *)getLibarayCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths firstObject]);
    return [paths firstObject];
}

- (void)createStoreVC:(StoreCreateViewController *)storeVC
{
    NSString * storeIntroduce = @"";
    NSString * storeNotice = @"";
    if (storeVC.noticeTV.text.length != 0 && ![storeVC.noticeTV.text isEqualToString:@"请填入店铺公告"]) {
        storeNotice = storeVC.noticeTV.text;
        
    }
    if (storeVC.introTV.text.length != 0 && ![storeVC.introTV.text isEqualToString:@"请填入店铺简介"]) {
        storeIntroduce = storeVC.introTV.text;
    }
    
    double longitude;
    double latitude;
    if (self.lon) {
        longitude = _lon;
    }else
    {
        longitude = self.coor.longitude;
    }
    
    if (self.lat) {
        latitude = _lat;
    }else
    {
        latitude = self.coor.latitude;
    }
    
    
    if (self.changestore == 1) {
//        for (NSMutableDictionary * dic in self.priceForDistanceArray) {
//            NSLog(@"***%@***哇哈哈*********", [dic description]);
//        }
        NSDictionary * jsonDic = @{
                                   @"Command":@65,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"StoreIcon":storeVC.logoURL,
                                   @"StoreCodeIcon":storeVC.barcodeURL,
                                   @"StoreName":storeVC.nameTF.text,
                                   @"StorePhone":storeVC.phoneTF.text,
                                   @"StoreStartTime":[NSNumber numberWithInt:storeVC.startDate.intValue],
                                   @"StoreEndTime":[NSNumber numberWithInt:storeVC.endDate.intValue],
                                   @"SendPrice":[NSNumber numberWithDouble:storeVC.sendPriceTF.text.doubleValue],
                                   @"OutSentMoney":[NSNumber numberWithDouble:storeVC.outSendPriceTF.text.doubleValue],
                                   @"SendTime":[NSNumber numberWithInt:storeVC.sendTimeTF.text.intValue],
                                   @"TablewareFee":@([self.tablewarefeeTF.text doubleValue]),
                                   @"Radius":[NSNumber numberWithDouble:storeVC.scopeTF.text.doubleValue],
                                   @"SendArea":@"",
                                   @"StoreType":[NSNumber numberWithInteger:_storeType],
                                   @"StoreAddress":storeVC.storeAddressTF.text,
                                   @"Lon":[NSNumber numberWithDouble:longitude],
                                   @"Lat":[NSNumber numberWithDouble:latitude],
                                   @"StoreIntroduce":storeIntroduce,
                                   @"StoreNotice":storeNotice,
                                   @"DeliveryList":self.priceForDistanceArray
                                   };
        [storeVC playPostWithDictionary:jsonDic];

    }else
    {
        NSDictionary * jsonDic = @{
                                   @"Command":@41,
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"StoreIcon":storeVC.logoURL,
                                   @"StoreCodeIcon":storeVC.barcodeURL,
                                   @"StoreName":storeVC.nameTF.text,
                                   @"StorePhone":storeVC.phoneTF.text,
                                   @"StoreStartTime":[NSNumber numberWithInt:storeVC.startDate.intValue],
                                   @"StoreEndTime":[NSNumber numberWithInt:storeVC.endDate.intValue],
                                   @"SendPrice":[NSNumber numberWithDouble:storeVC.sendPriceTF.text.doubleValue],
                                   @"OutSentMoney":[NSNumber numberWithDouble:storeVC.outSendPriceTF.text.doubleValue],
                                   @"SendTime":[NSNumber numberWithInt:storeVC.sendTimeTF.text.intValue],
                                   @"TablewareFee":@([self.tablewarefeeTF.text doubleValue]),
                                   @"Radius":[NSNumber numberWithDouble:storeVC.scopeTF.text.doubleValue],
                                   @"SendArea":@"",
                                   @"StoreType":[NSNumber numberWithInteger:_storeType],
                                   @"StoreAddress":storeVC.storeAddressTF.text,
                                   @"Lon":[NSNumber numberWithDouble:longitude],
                                   @"Lat":[NSNumber numberWithDouble:latitude],
                                   @"StoreIntroduce":storeIntroduce,
                                   @"StoreNotice":storeNotice,
                                   @"DeliveryList":self.priceForDistanceArray
                                   };
        [storeVC playPostWithDictionary:jsonDic];

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
    NSLog(@"data==%@", [data description]);
    [SVProgressHUD dismiss];
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        
        int command = [[data objectForKey:@"Command"] intValue];
        if (command == 10064){
            [self createStoreWithDate:data];
            
            
        }else if (command == 10041)
        {
//        [UserInfo shareUserInfo].storeName = self.nameTF.text;
        
        LoginViewController * loginVC = (LoginViewController *)[self.navigationController.viewControllers firstObject];
        [loginVC pushTabBarVC];
//        NSLog(@"1 VC= %@, VC2 = %@", loginVC, [self.navigationController.viewControllers firstObject]);
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else
    {
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:nil message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"error = %@", error);
}


#pragma mark - 删除不同距离配送费

- (void)deletesendPriceView:(UIButton * )button
{
    UIView * view = [button superview];
    NSInteger b = view.tag - 8000;
    UIScrollView * scrollView = (UIScrollView *)[view superview];
    UIView * sendview = [scrollView viewWithTag:2000];
    
    for (int i = (int)b + 1;i < self.priceForDistanceViewArray.count ; i++) {
        OutSendPriceView * outview = [self.priceForDistanceViewArray objectAtIndex:i];
        outview.tag--;
        outview.frame = CGRectMake(0, _describView.bottom + (i - 1)* 40,  self.view.width, 40);
    }
    
    [self.priceForDistanceViewArray removeObjectAtIndex:b];
    [self.priceForDistanceArray removeObjectAtIndex:b];
    
    if (self.priceForDistanceArray.count == 0) {
        _describView.frame = CGRectMake(0, _addsendPriceBT.bottom + TOP_SPACE, self.view.width, 0);
        _describView.hidden = YES;
    }
    
    UILabel * noticeLB = [scrollView viewWithTag:2001];
    noticeLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _describView.bottom + self.priceForDistanceArray.count * 40, 100, 30);
    
    _noticeTV.frame = CGRectMake(LEFT_SPACE, noticeLB.bottom, _noticeTV.width, 70);
    
    UILabel * introLB = [scrollView viewWithTag:2003];
    introLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _noticeTV.bottom, 100, 30);
    
    self.introTV.frame = CGRectMake(LEFT_SPACE, introLB.bottom, _introTV.width, 70);
    
    UIButton * saveButton = (UIButton *)[scrollView viewWithTag:2005];
    saveButton.frame = CGRectMake(LEFT_SPACE, _introTV.bottom + TOP_SPACE, saveButton.width, 35);
    
    
    scrollView.contentSize = CGSizeMake(scrollView.width, saveButton.bottom + TOP_SPACE * 3);
    
    [view removeFromSuperview];
    
//    for (NSMutableDictionary * dic in self.priceForDistanceArray) {
//        NSLog(@"***%@***", [dic description]);
//    }
}
#pragma mark -  设置不同距离配送费,起送价
- (void)choceTasteAction:(UIButton *)button
{
    
    
    [self.view addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
    
    UIView * backView = [[UIView alloc]init];
    backView.frame = _tanchuView.frame;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = .5;
    [_tanchuView addSubview:backView];
    
    UIView *tastePriceAndIntegralView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 20, 260)];
    tastePriceAndIntegralView.center = _tanchuView.center;
    tastePriceAndIntegralView.backgroundColor = [UIColor whiteColor];
    [_tanchuView addSubview:tastePriceAndIntegralView];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, tastePriceAndIntegralView.width, 30)];
    nameLabel.text = @"设置配送信息";
    [tastePriceAndIntegralView addSubview:nameLabel];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, nameLabel.bottom + TOP_SPACE, 30, 30)];
    titleLabel.text = @"起:";
    titleLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:titleLabel];
    
    self.startDistanceTF = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, tastePriceAndIntegralView.width - 80, 30)];
    _startDistanceTF.delegate = self;
    _startDistanceTF.placeholder = @"请输入起点";
    _startDistanceTF.borderStyle = UITextBorderStyleNone;
    _startDistanceTF.keyboardType = UIKeyboardTypeNumberPad;
    [tastePriceAndIntegralView addSubview:_startDistanceTF];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, _startDistanceTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
    lineView2.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:lineView2];
    
    
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom + 10, 30, 30)];
    priceLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    priceLabel.text = @"终:";
    [tastePriceAndIntegralView addSubview:priceLabel];
    
    self.endDistanceTF = [[UITextField alloc]initWithFrame:CGRectMake(priceLabel.right, titleLabel.bottom + 10, tastePriceAndIntegralView.width - 80, 30)];
    _endDistanceTF.placeholder = @"请输入终点";
    _endDistanceTF.borderStyle = UITextBorderStyleNone;
    _endDistanceTF.keyboardType = UIKeyboardTypeNumberPad;
    [tastePriceAndIntegralView addSubview:_endDistanceTF];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, _endDistanceTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:lineView];
    
    UILabel * integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 10, 60, 30)];
    integralLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    integralLabel.textAlignment = NSTextAlignmentCenter;
    integralLabel.text = @"配送费:";
    [tastePriceAndIntegralView addSubview:integralLabel];
    
    self.spaceDeliveryTF = [[UITextField alloc]initWithFrame:CGRectMake(integralLabel.right, lineView.bottom + 10, tastePriceAndIntegralView.width - 100, 30)];
    _spaceDeliveryTF.placeholder = @"请输入配送费";
    _spaceDeliveryTF.borderStyle = UITextBorderStyleNone;
    _spaceDeliveryTF.keyboardType = UIKeyboardTypeNumberPad;
    [tastePriceAndIntegralView addSubview:_spaceDeliveryTF];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, _spaceDeliveryTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
    lineView1.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:lineView1];
    
    
    UILabel * startOutSendPriceForDistanceLB = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView1.bottom + 10, 60, 30)];
    startOutSendPriceForDistanceLB.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    startOutSendPriceForDistanceLB.textAlignment = NSTextAlignmentCenter;
    startOutSendPriceForDistanceLB.text = @"起送价:";
    [tastePriceAndIntegralView addSubview:startOutSendPriceForDistanceLB];
    
    self.spaceSendPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(startOutSendPriceForDistanceLB.right, startOutSendPriceForDistanceLB.top, tastePriceAndIntegralView.width - 100, 30)];
    _spaceSendPriceTF.placeholder = @"请输入配送费";
    _spaceSendPriceTF.borderStyle = UITextBorderStyleNone;
    _spaceSendPriceTF.keyboardType = UIKeyboardTypeNumberPad;
    [tastePriceAndIntegralView addSubview:_spaceSendPriceTF];
    
    UIView * lineView3 = [[UIView alloc]initWithFrame:CGRectMake(20, _spaceSendPriceTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
    lineView3.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    [tastePriceAndIntegralView addSubview:lineView3];

    
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancleButton.frame = CGRectMake(40, lineView3.bottom + 9, 80, 40);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleTastepriceAction) forControlEvents:UIControlEventTouchUpInside];
    [tastePriceAndIntegralView addSubview:cancleButton];
    
    UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(tastePriceAndIntegralView.width - 40 - 80, cancleButton.top, cancleButton.width, cancleButton.height);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureTasteprice:) forControlEvents:UIControlEventTouchUpInside];
    [tastePriceAndIntegralView addSubview:sureButton];
    
    [self animateIn];
    
}
- (void)animateIn
{
    self.tanchuView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.tanchuView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        self.tanchuView.alpha = 1;
        self.tanchuView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)cancleTastepriceAction
{
    [self.tanchuView removeFromSuperview];
}

- (void)sureTasteprice:(UIButton *)button
{
    
    [self.tanchuView removeFromSuperview];
    
    
    
    TJScrollView * scrollView = (TJScrollView *)[self.view viewWithTag:1001];
    UIView * sendview = [scrollView viewWithTag:2000];
    
    _describView.frame = CGRectMake(0, _addsendPriceBT.bottom + TOP_SPACE, self.view.width, 30);
    _describView.hidden = NO;
    
    OutSendPriceView * sendPriceView = [[OutSendPriceView alloc]initWithFrame:CGRectMake(0, _describView.bottom + self.priceForDistanceArray.count * 40,  self.view.width, 40)];
    sendPriceView.tag = 8000 + self.priceForDistanceArray.count;
//    sendPriceView.startdistanceTF.delegate = self;
//    sendPriceView.endDistanceTF.delegate = self;
//    sendPriceView.priceTF.delegate = self;
    [sendPriceView.deleteButton addTarget:self action:@selector(deletesendPriceView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sendPriceView];
    
    [self.priceForDistanceViewArray addObject:sendPriceView];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    if (self.startDistanceTF.text) {
        [dic setValue:@([self.startDistanceTF.text doubleValue]) forKey:StartSpace];
        sendPriceView.startdistanceLabel.text = [NSString stringWithFormat:@"%@ ~ ", self.startDistanceTF.text];
    }else
    {
        [dic setValue:@(0) forKey:StartSpace];
        sendPriceView.startdistanceLabel.text = @"0 ~ ";
    }
    if (self.endDistanceTF.text) {
        [dic setValue:@([self.endDistanceTF.text doubleValue]) forKey:EndSpace];
        NSString * str = sendPriceView.startdistanceLabel.text;
        sendPriceView.startdistanceLabel.text = [str stringByAppendingFormat:@"%@km", self.endDistanceTF.text];
    }else
    {
        [dic setValue:@(0) forKey:EndSpace];
        NSString * str = sendPriceView.startdistanceLabel.text;
        sendPriceView.startdistanceLabel.text = [str stringByAppendingString:@"0km"];
    }
    if (self.spaceDeliveryTF.text) {
        [dic setValue:@([self.spaceDeliveryTF.text doubleValue]) forKey:SpaceDelivery];
    }else
    {
        [dic setValue:@(0) forKey:SpaceDelivery];
    }
    if (self.spaceSendPriceTF.text) {
        [dic setValue:@([self.spaceSendPriceTF.text doubleValue]) forKey:SpaceSendPrice];
    }else
    {
        [dic setValue:@(0) forKey:SpaceSendPrice];
    }
    
    sendPriceView.startdistanceLabel.text = [NSString stringWithFormat:@"%@~%@ km", [dic objectForKey:@"StartSpace"], [dic objectForKey:@"EndSpace"]];
    sendPriceView.spaceDeliveryLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"SpaceDelivery"]];
    sendPriceView.spaceSendPriceLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"SpaceSendPrice"]];
    
    
    [self.priceForDistanceArray addObject:dic];
    
    UILabel * noticeLB = [scrollView viewWithTag:2001];
    noticeLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _describView.bottom + self.priceForDistanceArray.count * 40, 100, 30);
    
    
    _noticeTV.frame = CGRectMake(LEFT_SPACE, noticeLB.bottom, _noticeTV.width, 70);
    
    UILabel * introLB = [scrollView viewWithTag:2003];
    introLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _noticeTV.bottom, 100, 30);
    
    
    self.introTV.frame = CGRectMake(LEFT_SPACE, introLB.bottom, _introTV.width, 70);
    
    UIButton * saveButton = (UIButton *)[scrollView viewWithTag:2005];
    saveButton.frame = CGRectMake(LEFT_SPACE, _introTV.bottom + TOP_SPACE, saveButton.width, 35);
    
    
    scrollView.contentSize = CGSizeMake(scrollView.width, saveButton.bottom + TOP_SPACE * 3);

//    for (NSMutableDictionary * dic in self.priceForDistanceArray) {
//        NSLog(@"***%@***", [dic description]);
//    }
}

#pragma mark - 根据请求参数布局页面

- (void)createStoreWithDate:(NSDictionary * )dic
{
    
    __weak StoreCreateViewController * storeVC = self;
    
        UIImageView * logoview = [[UIImageView alloc]init];
        logoview.frame = self.logoBT.frame;
        NSString * str = [dic objectForKey:@"StoreIcon"];
        NSString * logostr = [NSString stringWithFormat:@"http://image.vlifee.com%@", str];
        self.logoURL = logostr;
        [_logoImageview sd_setImageWithURL:[NSURL URLWithString:logostr] placeholderImage:[UIImage imageNamed:@"uploading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                storeVC.logoImage = image;
//                [storeVC.logoBT setBackgroundImage:image forState:UIControlStateNormal];
                storeVC.logoImageview.image = image;
            }
        }];
        
        UIImageView * barcodeImageView = [[UIImageView alloc]init];
        barcodeImageView.frame = _barcodeBT.frame;
        NSString * barcodestr = [dic objectForKey:@"StoreCodeIcon"];
        barcodestr = [NSString stringWithFormat:@"http://image.vlifee.com%@", barcodestr];
        self.barcodeURL = barcodestr;
        
        
        [_baImageView sd_setImageWithURL:[NSURL URLWithString:barcodestr] placeholderImage:[UIImage imageNamed:@"uploading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                storeVC.barcodeImage = image;
//                [storeVC.barcodeBT setBackgroundImage:image forState:UIControlStateNormal];
                storeVC.baImageView.image = image;
                NSLog(@"******************************");
            }
            
        }];
//        NSLog(@"********%@\n*************%@", self.logoURL, self.barcodeURL);
    
  
    
    self.nameTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"StoreName"]];
    self.phoneTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"StorePhone"]];
    
    
    [self.startBT setTitle:[NSString stringWithFormat:@"%@点", [dic objectForKey:@"StoreStartTime"]] forState:UIControlStateNormal];
    [self.startBT setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    self.startDate = [dic objectForKey:@"StoreStartTime"];
    
    [self.endBT setTitle:[NSString stringWithFormat:@"%@点", [dic objectForKey:@"StoreEndTime"]] forState:UIControlStateNormal];
    [self.endBT setTitleColor:[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
    self.endDate = [dic objectForKey:@"StoreEndTime"];
    
    if ([[dic objectForKey:@"TablewareFee"] doubleValue] == 0) {
        self.tablewarefeeTF.text = @"0";
    }else
    {
        self.tablewarefeeTF.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TablewareFee"]];
    }
    self.sendPriceTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"SendPrice"]];
    
    self.outSendPriceTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"OutSentMoney"]];
    
    if (self.priceForDistanceArray.count) {
        [self.priceForDistanceArray removeAllObjects];
    }
    
    self.priceForDistanceArray = [[dic objectForKey:@"DeliveryList"] mutableCopy];
    [self addPriceForDistance];
    
    self.sendTimeTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"SendTime"]];
    
    self.scopeTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Radius"]];
    
    
    TJScrollView * scrollView = [self.view viewWithTag:1001];
    UIButton * button = [scrollView viewWithTag:([[dic objectForKey:@"StoreType"] integerValue] + 20000)];
    button.selected = YES;
    button.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
    _storeType = button.tag - 20000;
    
    self.storeAddressTF.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"StoreAddress"]];
    self.address = [NSString stringWithFormat:@"%@", [dic objectForKey:@"StoreAddress"]];
    self.lon = (float)[[dic objectForKey:@"Lon"] doubleValue];
    self.lat = (float)[[dic objectForKey:@"Lat"] doubleValue];

    
    
#warning 获取地址信息
    
    self.noticeTV.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"StoreNotice"]];
    
    self.introTV.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"StoreIntroduce"]];
    
    
}

- (void)addPriceForDistance
{
    UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:1001];
    UIView * sendview = [scrollView viewWithTag:2000];
    
    if (self.priceForDistanceArray.count) {
        _describView.frame = CGRectMake(0, _addsendPriceBT.bottom + TOP_SPACE, self.view.width, 30);
        _describView.hidden = NO;
    }
    
    for (int i = 0; i < self.priceForDistanceArray.count; i++) {
        OutSendPriceView * sendPriceView = [[OutSendPriceView alloc]initWithFrame:CGRectMake(0, _describView.bottom + i * 40,  self.view.width, 40)];
        sendPriceView.tag = 8000 + i;
        
        [sendPriceView.deleteButton addTarget:self action:@selector(deletesendPriceView:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:sendPriceView];
        
        NSDictionary * dic = [self.priceForDistanceArray objectAtIndex:i];
        sendPriceView.startdistanceLabel.text = [NSString stringWithFormat:@"%@~%@ km", [dic objectForKey:@"StartSpace"], [dic objectForKey:@"EndSpace"]];
        sendPriceView.spaceDeliveryLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"SpaceDelivery"]];
        sendPriceView.spaceSendPriceLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"SpaceSendPrice"]];
        
        [self.priceForDistanceViewArray addObject:sendPriceView];
    }
    
    
//    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//    
//    if (self.startDistanceTF.text) {
//        [dic setValue:@([self.startDistanceTF.text doubleValue]) forKey:StartSpace];
//        sendPriceView.startdistanceLabel.text = [NSString stringWithFormat:@"%@ ~ ", self.startDistanceTF.text];
//    }else
//    {
//        [dic setValue:@(0) forKey:StartSpace];
//        sendPriceView.startdistanceLabel.text = @"0 ~ ";
//    }
//    if (self.endDistanceTF.text) {
//        [dic setValue:@([self.endDistanceTF.text doubleValue]) forKey:EndSpace];
//        NSString * str = sendPriceView.startdistanceLabel.text;
//        sendPriceView.startdistanceLabel.text = [str stringByAppendingFormat:@"%@km", self.endDistanceTF.text];
//    }else
//    {
//        [dic setValue:@(0) forKey:EndSpace];
//        NSString * str = sendPriceView.startdistanceLabel.text;
//        sendPriceView.startdistanceLabel.text = [str stringByAppendingString:@"0km"];
//    }
//    if (self.spaceDeliveryTF.text) {
//        [dic setValue:@([self.spaceDeliveryTF.text doubleValue]) forKey:SpaceDelivery];
//    }else
//    {
//        [dic setValue:@(0) forKey:SpaceDelivery];
//    }
//    if (self.spaceSendPriceTF.text) {
//        [dic setValue:@([self.spaceSendPriceTF.text doubleValue]) forKey:SpaceSendPrice];
//    }else
//    {
//        [dic setValue:@(0) forKey:SpaceSendPrice];
//    }
    
//    sendPriceView.startdistanceLabel.text = [NSString stringWithFormat:@"%@ ~ %@ km", [dic objectForKey:@"StartSpace"], [dic objectForKey:@"EndSpace"]];
//    sendPriceView.spaceDeliveryLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"SpaceDelivery"]];
//    sendPriceView.spaceSendPriceLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"SpaceSendPrice"]];
    
    
    
    UILabel * noticeLB = [scrollView viewWithTag:2001];
    noticeLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _describView.bottom + self.priceForDistanceArray.count * 40, 100, 30);
    
    
    _noticeTV.frame = CGRectMake(LEFT_SPACE, noticeLB.bottom, _noticeTV.width, 70);
    
    UILabel * introLB = [scrollView viewWithTag:2003];
    introLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _noticeTV.bottom, 100, 30);
    
    
    self.introTV.frame = CGRectMake(LEFT_SPACE, introLB.bottom, _introTV.width, 70);
    
    UIButton * saveButton = (UIButton *)[scrollView viewWithTag:2005];
    saveButton.frame = CGRectMake(LEFT_SPACE, _introTV.bottom + TOP_SPACE, saveButton.width, 35);
    
    
    scrollView.contentSize = CGSizeMake(scrollView.width, saveButton.bottom + TOP_SPACE * 3);

}


// 废弃方法
- (void)addsendPrice:(UIButton *)button
{
    UIScrollView * scrollView = (UIScrollView *)[self.view viewWithTag:1001];
    UIView * sendview = [scrollView viewWithTag:2000];
    
    OutSendPriceView * sendPriceView = [[OutSendPriceView alloc]initWithFrame:CGRectMake(0, sendview.bottom + self.priceForDistanceArray.count * 40,  self.view.width, 40)];
    sendPriceView.tag = 8000 + self.priceForDistanceArray.count;
    //    sendPriceView.startdistanceTF.delegate = self;
    //    sendPriceView.endDistanceTF.delegate = self;
    //    sendPriceView.priceTF.delegate = self;
    [sendPriceView.deleteButton addTarget:self action:@selector(deletesendPriceView:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sendPriceView];
    
    [self.priceForDistanceViewArray addObject:sendPriceView];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [self.priceForDistanceArray addObject:dic];
    
    UILabel * noticeLB = [scrollView viewWithTag:2001];
    noticeLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + sendview.bottom + self.priceForDistanceArray.count * 40, 100, 30);
    
    
    _noticeTV.frame = CGRectMake(LEFT_SPACE, noticeLB.bottom, _noticeTV.width, 70);
    
    UILabel * introLB = [scrollView viewWithTag:2003];
    introLB.frame = CGRectMake(LEFT_SPACE, TOP_SPACE + _noticeTV.bottom, 100, 30);
    
    
    self.introTV.frame = CGRectMake(LEFT_SPACE, introLB.bottom, _introTV.width, 70);
    
    UIButton * saveButton = (UIButton *)[scrollView viewWithTag:2005];
    saveButton.frame = CGRectMake(LEFT_SPACE, _introTV.bottom + TOP_SPACE, saveButton.width, 35);
    
    
    scrollView.contentSize = CGSizeMake(scrollView.width, saveButton.bottom + TOP_SPACE * 3);
    //    _number++;
    
    
//    for (NSMutableDictionary * dic in self.priceForDistanceArray) {
//        NSLog(@"***%@***", [dic description]);
//    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView * view = [textField superview];
    int a = (int)(view.tag - 8000);
    if (textField.tag == 9001) {
        NSMutableDictionary * dic = [self.priceForDistanceArray objectAtIndex:a];
        [dic setValue:textField.text forKey:StartSpace];
    }else if (textField.tag == 9002)
    {
        NSMutableDictionary * dic = [self.priceForDistanceArray objectAtIndex:a];
        [dic setValue:textField.text forKey:EndSpace];
    }else if (textField.tag == 9003)
    {
        NSMutableDictionary * dic = [self.priceForDistanceArray objectAtIndex:a];
        [dic setValue:textField.text forKey:SpaceDelivery];
    }
}



//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSString * text = textField.text;
//    if (text.length >= 16) {
//        return NO;
//    }
//    if ([textField isEqual:self.nameTF]) {
//        NSCharacterSet * characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_\b"] invertedSet];
//        NSString * filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
//        BOOL a = [string isEqualToString:filtered];
//        return a;
//    }
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
