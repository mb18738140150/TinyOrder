//
//  RealNameAuthenticationViewcontroller.m
//  TinyOrder
//
//  Created by 仙林 on 16/4/11.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "RealNameAuthenticationViewcontroller.h"
#import "AccountModel.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#define SCX_OBJECT_STRING(str) ([[NSString stringWithFormat:@"%@", (str) ? (str) : @""] isEqualToString:@"<null>"] ? @"" : [NSString stringWithFormat:@"%@", (str) ? (str) : @""])
@interface RealNameAuthenticationViewcontroller ()<HTTPPostDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
//@property (strong, nonatomic) IBOutlet UITextField *realnameTF;
//@property (strong, nonatomic) IBOutlet UITextField *idcardNumberTF;
//@property (strong, nonatomic) IBOutlet UIImageView *idImageview;
//@property (strong, nonatomic) IBOutlet UIImageView *businesslicenseImageview;
//@property (strong, nonatomic) IBOutlet UIImageView *fodLicenseImageview;
//@property (strong, nonatomic) IBOutlet UIButton *certificationBT;

@property (strong, nonatomic)  UIView *reasonView;
@property (strong, nonatomic)  UILabel *reasonLabel;

@property (strong, nonatomic)  UIScrollView *myScrollview;
@property (strong, nonatomic)  UIView *informationView;
@property (strong, nonatomic)  UITextField *realnameTF;
@property (strong, nonatomic)  UITextField *idcardNumberTF;

@property (strong, nonatomic)  UIView *tipView;
@property (strong, nonatomic)  UIView *iconimageview;
@property (strong, nonatomic)  UIImageView *idImageview;
@property (strong, nonatomic)  UIImageView *businesslicenseImageview;
@property (strong, nonatomic)  UIImageView *fodLicenseImageview;

@property (strong, nonatomic)  UIButton *certificationBT;

@property (nonatomic, copy)NSString * idImageStr;
@property (nonatomic, copy)NSString * businesslicenseimageStr;
@property (nonatomic, copy)NSString * diningLicenseImageStr;

@property (nonatomic, assign)int uploadImageNumber;
@property (nonatomic, strong)UIImagePickerController * imagePic;
@property (nonatomic, strong)UIImageView * imageView;

@end

@implementation RealNameAuthenticationViewcontroller
- (void)viewDidLoad
{
    self.navigationItem.title = @"实名认证";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.myScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.navigationController.navigationBar.height)];
    if (self.isfrom == 2) {
        self.myScrollview.height = self.view.height - self.navigationController.navigationBar.height - 20;
    }
    
    self.myScrollview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:self.myScrollview];
    self.uploadImageNumber = 0;
    
    self.imagePic = [[UIImagePickerController alloc]init];
    _imagePic.allowsEditing = YES;
    _imagePic.delegate = self;

    self.reasonView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, self.view.width, 35)];
    self.reasonView.backgroundColor = BACKGROUNDCOLOR;
    [self.myScrollview addSubview:self.reasonView];
    
    UIImageView * tipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 15, 15)];
    tipImageView.backgroundColor = BACKGROUNDCOLOR;
    tipImageView.image = [UIImage imageNamed:@"icon_tishi.png"];
    [self.reasonView addSubview:tipImageView];
    
    self.reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(tipImageView.right + 5, 10, self.reasonView.width - 50, 15)];
    self.reasonLabel.textColor = [UIColor whiteColor];
    self.reasonLabel.font = [UIFont systemFontOfSize:14];
    self.reasonLabel.numberOfLines = 0;
    [self.reasonView addSubview:self.reasonLabel];
    
    self.informationView = [[UIView alloc]initWithFrame:CGRectMake(0, self.reasonView.bottom + 10, self.reasonView.width, 92)];
    self.informationView.backgroundColor = [UIColor whiteColor];
    [self.myScrollview addSubview:self.informationView];
    
    UILabel * nameLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 59, 14)];
    nameLB.textColor = [UIColor blackColor];
    nameLB.text = @"真实姓名";
    nameLB.font = [UIFont systemFontOfSize:14];
    [self.informationView addSubview:nameLB];
    
    self.realnameTF = [[UITextField alloc]initWithFrame:CGRectMake(nameLB.right + 20, nameLB.top, self.informationView.width - nameLB.right - 20 - 15, 15)];
    self.realnameTF.font = [UIFont systemFontOfSize:14];
    self.realnameTF.delegate = self;
    [self.informationView addSubview:self.realnameTF];
    
    UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake(self.realnameTF.left, self.informationView.height / 2, self.realnameTF.width + 15, 1)];
    lineview.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.informationView addSubview:lineview];
    
    UILabel * idcaedNumberLB = [[UILabel alloc]initWithFrame:CGRectMake(15, nameLB.bottom + 32, 60, 14)];
    idcaedNumberLB.textColor = [UIColor blackColor];
    idcaedNumberLB.font = [UIFont systemFontOfSize:14];
    idcaedNumberLB.text = @"身份证号";
    [self.informationView addSubview:idcaedNumberLB];
    
    self.idcardNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(idcaedNumberLB.right + 20, idcaedNumberLB.top, self.informationView.width - idcaedNumberLB.right - 20 - 15, 15)];
    self.idcardNumberTF.font = [UIFont systemFontOfSize:14];
    self.idcardNumberTF.delegate = self;
    self.idcardNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.informationView addSubview:self.idcardNumberTF];
    
    self.tipView = [[UIView alloc]initWithFrame:CGRectMake(0, self.informationView.bottom + 20, self.view.width, 35)];
    self.tipView.backgroundColor = [UIColor whiteColor];
    [self.myScrollview addSubview:self.tipView];
    
    UIView * vLine = [[UIView alloc]initWithFrame:CGRectMake(15, 8, 2, 19)];
    vLine.backgroundColor = BACKGROUNDCOLOR;
    [self.tipView addSubview:vLine];
    
    UILabel * tipLB = [[UILabel alloc]initWithFrame:CGRectMake(vLine.right + 5, 10, self.tipView.width - 37, 15)];
    tipLB.textColor = [UIColor grayColor];
    tipLB.font = [UIFont systemFontOfSize:14];
    tipLB.text = @"请上传本人手持的身份证清晰照一张!";
    [self.tipView addSubview:tipLB];
    
    self.iconimageview = [[UIView alloc]initWithFrame:CGRectMake(0, self.tipView.bottom + 1, self.tipView.width, 242)];
    self.iconimageview.backgroundColor = [UIColor whiteColor];
    [self.myScrollview addSubview:self.iconimageview];
    
    UILabel * zhaopianLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 34, 30, 14)];
    zhaopianLB.text = @"照片";
    zhaopianLB.font = [UIFont systemFontOfSize:14];
    [self.iconimageview addSubview:zhaopianLB];
    
    self.idImageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.informationView.width - 95, 17, 80, 50)];
    self.idImageview.backgroundColor = [UIColor whiteColor];
    self.idImageview.image = [UIImage imageNamed:@"icon_ren_zheng.png"];
    [self.iconimageview addSubview:self.idImageview];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 80, self.informationView.width - 15, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.iconimageview addSubview:line1];
    
    UILabel * businesslicenselb = [[UILabel alloc]initWithFrame:CGRectMake(15, zhaopianLB.bottom + 67, 59, 14)];
    businesslicenselb.text = @"营业执照";
    businesslicenselb.font = [UIFont systemFontOfSize:14];
    [self.iconimageview addSubview:businesslicenselb];
    
    self.businesslicenseImageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.informationView.width - 95, self.idImageview.bottom + 29, 80, 50)];
    self.businesslicenseImageview.backgroundColor = [UIColor whiteColor];
    self.businesslicenseImageview.image = [UIImage imageNamed:@"icon_ren_zheng.png"];
    [self.iconimageview addSubview:self.businesslicenseImageview];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(15, line1.bottom + 80, self.informationView.width - 15, 1)];
    line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    [self.iconimageview addSubview:line2];

    UILabel * dininglicenselb = [[UILabel alloc]initWithFrame:CGRectMake(15, businesslicenselb.bottom + 66, 105, 15)];
    dininglicenselb.text = @"餐饮服务许可证";
    dininglicenselb.font = [UIFont systemFontOfSize:14];
    [self.iconimageview addSubview:dininglicenselb];
    
    self.fodLicenseImageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.informationView.width - 95, self.businesslicenseImageview.bottom + 31, 80, 50)];
    self.fodLicenseImageview.backgroundColor = [UIColor whiteColor];
    self.fodLicenseImageview.image = [UIImage imageNamed:@"icon_ren_zheng.png"];
    [self.iconimageview addSubview:self.fodLicenseImageview];
    
    self.certificationBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certificationBT.frame = CGRectMake(40, self.iconimageview.bottom + 40, self.view.width - 80, 40);
    self.certificationBT.backgroundColor = BACKGROUNDCOLOR;
    [self.certificationBT setTitle:@"立即认证" forState:UIControlStateNormal];
    [self.certificationBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.certificationBT.layer.cornerRadius = 5;
    self.certificationBT.layer.masksToBounds = YES;
    [self.certificationBT addTarget:self action:@selector(cetificationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollview addSubview:self.certificationBT];
    self.myScrollview.contentSize = CGSizeMake(self.view.width, self.certificationBT.bottom + 20);
    
    UITapGestureRecognizer * idTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(idimageAction:)];
    [self.idImageview addGestureRecognizer:idTap];
    self.idImageview.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * businesslicenseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(businessLicenseAction:)];
    [self.businesslicenseImageview addGestureRecognizer:businesslicenseTap];
    self.businesslicenseImageview.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * dininglicenseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diningLicenseAction:)];
    [self.fodLicenseImageview addGestureRecognizer:dininglicenseTap];
    self.fodLicenseImageview.userInteractionEnabled = YES;
    
    
    self.reasonView.frame = CGRectMake(0, 0, self.view.width, 0);
    self.reasonLabel.numberOfLines = 0;
    self.reasonView.hidden = YES;
    [self againLayout];
    if (self.model.realNameCertificationState.intValue == 1 || self.model.realNameCertificationState.intValue == 2) {
        self.realnameTF.enabled = NO;
        self.idcardNumberTF.enabled = NO;
        self.idImageview.userInteractionEnabled = NO;
        self.businesslicenseImageview.userInteractionEnabled = NO;
        self.fodLicenseImageview.userInteractionEnabled = NO;
        self.certificationBT.hidden = YES;
        [self againLayout];
    }else if (self.model.realNameCertificationState.intValue == 3)
    {
        self.certificationBT.hidden = NO;
        [self.certificationBT setTitle:@"重新认证" forState:UIControlStateNormal];
        self.reasonView.frame = CGRectMake(0, 0, self.view.width, 0);
        self.reasonView.hidden = NO;
        [self againLayout];
    }
    self.myScrollview.contentSize = CGSizeMake(self.view.width, _certificationBT.bottom );
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    if (self.isfrom == 1) {
        if (self.model.realNameCertificationState.intValue != 0) {
            NSDictionary * jsonDic = @{
                                       @"Command":@82,
                                       @"UserId":[UserInfo shareUserInfo].userId
                                       };
            [self playPostWithDictionary:jsonDic];
            [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"1px.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1px.png"] forBarMetrics:UIBarMetricsDefault];
    self.isfrom = 0;
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cetificationAction:(UIButton *)sender {
    
    NSData * idIcondata = UIImagePNGRepresentation(self.idImageview.image);
    NSData * businessIcondata = UIImagePNGRepresentation(self.businesslicenseImageview.image);
    NSData * diningIcondata = UIImagePNGRepresentation(self.fodLicenseImageview.image);
    NSData * defaultIcondata = UIImagePNGRepresentation([UIImage imageNamed:@"icon_ren_zheng.png"]);
    
    if (self.realnameTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (self.idcardNumberTF.text.length == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证号码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([idIcondata isEqual:defaultIcondata])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"身份证照片不能为空不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if([businessIcondata isEqual:defaultIcondata])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"营业执照不能为空不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self uploadImageWithUrlStringwithType:1 image:self.idImageview.image];
        [self uploadImageWithUrlStringwithType:2 image:self.businesslicenseImageview.image];
        [self uploadImageWithUrlStringwithType:3 image:self.fodLicenseImageview.image];
    }
}

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
    NSLog(@"++%@", [data description]);
    int command = [[data objectForKey:@"Command"] intValue];
    //    NSDictionary * dataDic = (NSDictionary *)data;
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        if (command == 10081)
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (command == 10082)
        {
            [self assignmentWithDIc:data];
        }
    }else
    {
        if ([data objectForKey:@"ErrorMsg"]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertView show];
            [alertView performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
        }
        
        
    }
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    
    if ([[error.userInfo objectForKey:@"Reason"] isEqualToString:@"服务器处理失败"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器处理失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
        [alert show];
    }else
    {
        
        UIAlertView * alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败请重新连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerV show];
    }
}

#pragma mark - 根据请求布局页面
- (void)assignmentWithDIc:(NSDictionary *)dic
{
    self.realnameTF.text = [dic objectForKey:@"RealName"];
    self.idcardNumberTF.text = [dic objectForKey:@"Idcardnumber"];
    NSString * idiconstr = [dic objectForKey:@"IdIcon"];
    idiconstr = [idiconstr stringByAppendingString:@".220220.png"];
    
    NSString * businessiconstr = [dic objectForKey:@"BusinessLicenseIcon"];
    businessiconstr = [businessiconstr stringByAppendingString:@".220220.png"];
    
    NSString * diningiconstr = [dic objectForKey:@"DiningLicenseIcon"];
    diningiconstr = [diningiconstr stringByAppendingString:@".220220.png"];
    
    __weak RealNameAuthenticationViewcontroller * realVC = self;
    [self.idImageview sd_setImageWithURL:[NSURL URLWithString:idiconstr] placeholderImage:[UIImage imageNamed:@"icon_ren_zheng.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            realVC.idImageview.image = image;
        }
    }];
    [self.businesslicenseImageview sd_setImageWithURL:[NSURL URLWithString:businessiconstr] placeholderImage:[UIImage imageNamed:@"icon_ren_zheng.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            realVC.businesslicenseImageview.image = image;
        }
    }];
    [self.fodLicenseImageview sd_setImageWithURL:[NSURL URLWithString:diningiconstr] placeholderImage:[UIImage imageNamed:@"icon_ren_zheng.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            realVC.fodLicenseImageview.image = image;
        }
    }];
//    if (((NSString *)[dic objectForKey:@"Reason"]).length != 0) {
//        ;
//    }
   
    if ([[dic objectForKey:@"RealNameCertificationState"] intValue] == 3) {
    
        NSString * str = SCX_OBJECT_STRING([dic objectForKey:@"Reason"]);
        self.reasonView.hidden = NO;
        //    str = @"水库方便的是放假吧是放假吧司法局欧版我覅你我；二佛吧是；欧in俄方我；新服务；偶记；偶尔玩我人家闺女弗兰克历史上的回复你绿豆沙都是看你发来；按分尸快递了的可能给福利卡控件的不舒服看了收入可能看世界杯年付款了如何呢";
        self.reasonLabel.text = str;
        
        if (str.length == 0) {
            self.reasonView.hidden = YES;
            self.reasonView.height = 0;
        }else
        {
            CGSize size = [self.reasonLabel.text boundingRectWithSize:CGSizeMake(self.reasonView.width - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            if (size.height > 15) {
                self.reasonLabel.frame = CGRectMake(35, 10, self.reasonView.width - 50, size.height);
                self.reasonView.frame = CGRectMake(0, 0, self.view.width, size.height + 20);
            }else
            {
                self.reasonLabel.frame = CGRectMake(35, 10, self.reasonView.width - 50, 15);
                self.reasonView.frame = CGRectMake(0, 0, self.view.width, 35);
            }
        }
    }else
    {
        self.reasonView.hidden = YES;
    }
    [self againLayout];
    
}

#pragma mark - 添加图片
- (void)idimageAction:(UITapGestureRecognizer *)sender
{
    self.imageView = (UIImageView *)sender.view;
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [tipControl addAction:sureAction];
            [self presentViewController:tipControl animated:YES completion:nil];
            
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}

- (void)businessLicenseAction:(UITapGestureRecognizer *)sender
{
    self.imageView = (UIImageView *)sender.view;
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [tipControl addAction:sureAction];
            [self presentViewController:tipControl animated:YES completion:nil];
            
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}
- (void)diningLicenseAction:(UITapGestureRecognizer *)sender
{
    self.imageView = (UIImageView *)sender.view;
    UIAlertController * alertcontroller = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePic animated:YES completion:nil];
        }else
        {
            UIAlertController * tipControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有相机,请选择图库" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ;
            }];
            [tipControl addAction:sureAction];
            [self presentViewController:tipControl animated:YES completion:nil];
            
        }
    }];
    UIAlertAction * libraryAction = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imagePic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePic animated:YES completion:nil];
    }];
    
    [alertcontroller addAction:cancleAction];
    [alertcontroller addAction:cameraAction];
    [alertcontroller addAction:libraryAction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    self.imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    [self configer:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
    self.imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)configer:(UIImage *)image
{
    NSData * data ;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
        
    }else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    for (int i = 10; i > 0; i-- ) {
        data = UIImageJPEGRepresentation(image, i / 10.0);
        
        CGFloat mm = data.length / 1024.0;
        if (mm < 300) {
            NSLog(@"****%f", mm);
            self.imageView.image = [UIImage imageWithData:data];
            break;
        }
    }
    
    
//    CGFloat mm = data.length / 1024.0;
//    if (mm > 300) {
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传图片大小不能超过300K" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//    }else
//    {
//        self.imageView.image = image;
//    }
    
}

- (void)uploadImageWithUrlStringwithType:(int)type image:(UIImage *)image
{
//    NSString * urlstr = @"http://p3o1r7t.vlifee.com/uploadimg.aspx?savetype=5";
    NSString * urlstr = [NSString stringWithFormat:@"%@%@", IMAGE_POST_URL, @"savetype=5"];
    NSString * url = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString * imageName = [self imageNamewithType:type];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:YES];
    
    __weak RealNameAuthenticationViewcontroller * realVc = self;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"Result"] integerValue] == 1) {
            if (type == 1) {
                realVc.idImageStr = [responseObject objectForKey:@"ImgPath"];
                realVc.uploadImageNumber++;
            }else if (type == 2)
            {
                realVc.businesslicenseimageStr = [responseObject objectForKey:@"ImgPath"];
                realVc.uploadImageNumber++;
            }else if (type == 3)
            {
                realVc.diningLicenseImageStr = [responseObject objectForKey:@"ImgPath"];
                realVc.uploadImageNumber++;
            }
            if (realVc.uploadImageNumber == 3) {
                    [realVc createStoreVC:realVc];
                realVc.uploadImageNumber = 0;
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
- (NSString *)imageNamewithType:(int)type
{
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [fomatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"t%@%lld%d.png", strTime, arc4random() % 9000000000 + 1000000000, type];
    return name;
}
- (NSString *)getLibarayCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths firstObject]);
    return [paths firstObject];
}
- (void)createStoreVC:(RealNameAuthenticationViewcontroller *)realVc
{
    NSDictionary * jsonDic = @{
                               @"Command":@81,
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"RealName":realVc.realnameTF.text,
                               @"Idcardnumber":realVc.idcardNumberTF.text,
                               @"IdIcon":realVc.idImageStr,
                               @"BusinessLicenseIcon":realVc.businesslicenseimageStr,
                               @"DiningLicenseIcon":realVc.diningLicenseImageStr
                               };
    [realVc playPostWithDictionary:jsonDic];
    [SVProgressHUD showWithStatus:@"发送请求..." maskType:SVProgressHUDMaskTypeBlack];
}
#pragma mark - 从新布局
- (void)againLayout
{
    if (self.reasonView.hidden) {
        self.informationView.frame = CGRectMake(0, self.reasonView.bottom + 1, self.view.width, 92);
    }else
    {
        self.informationView.frame = CGRectMake(0, self.reasonView.bottom + 10, self.view.width, 92);
    }
    self.tipView.frame = CGRectMake(0, self.informationView.bottom + 20, self.view.width, 35);
    self.iconimageview.frame = CGRectMake(0, self.tipView.bottom + 1, self.view.width, 242);
    self.certificationBT.frame = CGRectMake(40, _iconimageview.bottom + 40, self.view.width - 80, 40);
    
    if (self.certificationBT.hidden) {
        self.myScrollview.contentSize = CGSizeMake(self.view.width, self.iconimageview.bottom + 40);
        
    }else
    {
        self.myScrollview.contentSize = CGSizeMake(self.view.width, self.certificationBT.bottom + 40);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.idcardNumberTF]) {
        if (![NSString validateIDCardNumber:textField.text] ) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的身份证号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}


@end
