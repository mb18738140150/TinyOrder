//
//  RegisterLinkViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/6/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "RegisterLinkViewController.h"
#import "AppDelegate.h"
#define SAVEPHONEVIEW_TAG 10000000

@interface RegisterLinkViewController ()
@property (nonatomic, strong)UIImageView * shopfrontpageqrcodeImageView;
@end

@implementation RegisterLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收银台链接";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    [self addSubviews];
    
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * strrrrr = [[NSUserDefaults standardUserDefaults]objectForKey:@"CashierUrl"];
    UIImage * image = [[QRCode shareQRCode] createQRCodeForString:
                       [NSString stringWithFormat:@"%@", strrrrr]];
    NSData * inageData = UIImageJPEGRepresentation(image, 1.0);
    UIImage * image1 = [UIImage imageWithData:inageData];
    
    self.shopfrontpageqrcodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height / 2 - (self.view.width - 80) / 2 - 64, self.view.width - 80, self.view.width - 80)];
//    self.shopfrontpageqrcodeImageView.center = self.view.center;
    self.shopfrontpageqrcodeImageView.backgroundColor = [UIColor redColor];
    self.shopfrontpageqrcodeImageView.userInteractionEnabled = YES;
    
    self.shopfrontpageqrcodeImageView.image = image1;
    [self.view addSubview:_shopfrontpageqrcodeImageView];
    
    UITapGestureRecognizer * shopfrontpageqrcodeImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shopfrontpageqrcodeImageViewTapAction:)];
    [self.shopfrontpageqrcodeImageView addGestureRecognizer:shopfrontpageqrcodeImageViewTap];

    UILabel * tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.shopfrontpageqrcodeImageView.bottom + 10, self.view.width - 40, 40)];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.backgroundColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"扫描上方二维码，完成自助付款";
    [self.view addSubview:tipLabel];
}
#pragma mark - 点击店铺首页二维码保存
- (void)shopfrontpageqrcodeImageViewTapAction:(UITapGestureRecognizer *)sender
{
    NSData * updata = UIImagePNGRepresentation([UIImage imageNamed:@"uploading.png"]);
    NSData * shopImagevData = UIImagePNGRepresentation(self.shopfrontpageqrcodeImageView.image);
    
    if ([updata isEqualToData:shopImagevData]) {
        ;
    }else
    {
        [self showphoneView];
    }
    
}

- (void)showphoneView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    backView.backgroundColor = [UIColor colorWithWhite:.3 alpha:.5];
    backView.tag = SAVEPHONEVIEW_TAG;
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    [delegate.window addSubview:backView];
    
    UIImageView * QRiamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backView.width - 80, backView.width - 80)];
    QRiamgeView.backgroundColor = [UIColor whiteColor];
    QRiamgeView.center = backView.center;
    QRiamgeView.image = self.shopfrontpageqrcodeImageView.image;
    [backView addSubview:QRiamgeView];
    
    UIButton * saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBt.frame = CGRectMake(QRiamgeView.left, QRiamgeView.bottom + 20, QRiamgeView.width, 40);
    saveBt.backgroundColor = BACKGROUNDCOLOR;
    [saveBt setTitle:@"保存" forState:UIControlStateNormal];
    [saveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:saveBt];
    [saveBt addTarget:self action:@selector(sevaPhone) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView:)];
    [backView addGestureRecognizer:tap];
}
- (void)removeBackView:(UITapGestureRecognizer *)sender
{
    UIView * backView = sender.view;
    [backView removeFromSuperview];
}

- (void)sevaPhone
{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    UIView * backview =  [delegate.window viewWithTag:SAVEPHONEVIEW_TAG];
    [backview removeFromSuperview];
    
    UIImageWriteToSavedPhotosAlbum(self.shopfrontpageqrcodeImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", message] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:1.0];
    NSLog(@"message is %@",message);
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
