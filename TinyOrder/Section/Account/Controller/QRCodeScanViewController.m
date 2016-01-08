//
//  QRCodeScanViewController.m
//  TinyOrder
//
//  Created by 仙林 on 16/1/6.
//  Copyright © 2016年 仙林. All rights reserved.
//

#import "QRCodeScanViewController.h"

#define ScreenHigh [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface QRCodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong)AVCaptureDevice * device;
@property (nonatomic, strong)AVCaptureDeviceInput * input;
@property (nonatomic, strong)AVCaptureMetadataOutput * output;
@property (nonatomic, strong)AVCaptureSession * session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, copy)ReturnDataBlock  returnData;

@end

@implementation QRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫描二维码";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    // 顶部view
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.5;
    [self.view addSubview:topView];
    // 用于说明的label
    UILabel *introductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 50)];
    introductionLabel.backgroundColor = [UIColor clearColor];
    introductionLabel.numberOfLines = 2;
    introductionLabel.text = @"将二维码图像置于矩形方框内，系统会自动识别";
    introductionLabel.font = [UIFont systemFontOfSize:15];
    introductionLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:introductionLabel];
    
    // 左侧的view
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, (self.view.frame.size.width - 220)/ 2, 220)];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = 0.5;
    [self.view addSubview:leftView];
    
    // 右侧view
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - leftView.frame.size.width, 60, (self.view.frame.size.width - 220)/ 2, 220)];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = 0.5;
    [self.view addSubview:rightView];
    
    // 底部view
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 280, self.view.frame.size.width, self.view.frame.size.height - 280)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.5;
    [self.view addSubview:bottomView];
    
    UIView * lefttop = [[UIView alloc]initWithFrame:CGRectMake(leftView.frame.size.width, leftView.frame.origin.y, 20, 4)];
    lefttop.backgroundColor = [UIColor greenColor];
    [self.view addSubview:lefttop];
    
    UIView * leftspace1 = [[UIView alloc]initWithFrame:CGRectMake(leftView.frame.size.width, leftView.frame.origin.y + 4, 4, 16)];
    leftspace1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftspace1];
    
    UIView * leftspace2 = [[UIView alloc]initWithFrame:CGRectMake(leftView.frame.size.width, leftView.frame.origin.y + leftView.frame.size.height - 20, 4, 16)];
    leftspace2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftspace2];
    
    UIView * leftbottom = [[UIView alloc]initWithFrame:CGRectMake(leftView.frame.size.width, leftView.frame.origin.y + leftView.frame.size.height - 4, 20, 4)];
    leftbottom.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftbottom];

    UIView * righttop = [[UIView alloc]initWithFrame:CGRectMake(rightView.frame.origin.x - 20, rightView.frame.origin.y, 20, 4)];
    righttop.backgroundColor = [UIColor greenColor];
    [self.view addSubview:righttop];
    
    UIView * rightspace1 = [[UIView alloc]initWithFrame:CGRectMake(rightView.frame.origin.x - 4, rightView.frame.origin.y + 4, 4, 16)];
    rightspace1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightspace1];
    
    UIView * rightspace2 = [[UIView alloc]initWithFrame:CGRectMake(rightView.frame.origin.x - 4, rightView.frame.origin.y + rightView.frame.size.height - 20, 4, 16)];
    rightspace2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightspace2];
    
    UIView * rightbottom = [[UIView alloc]initWithFrame:CGRectMake(rightView.frame.origin.x - 20, rightView.frame.origin.y + rightView.frame.size.height - 4, 20, 4)];
    rightbottom.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightbottom];
    
    // 获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    // 创建输出流
    self.output = [[AVCaptureMetadataOutput alloc]init];
    // 设置代理 在主线程里刷新
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 初始化连接对象
    self.session = [[AVCaptureSession alloc]init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:_input];
    [_session addOutput:_output];
    // 设置扫码支持的编码格式（如下设置条形码和二维码兼容）
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    _output.rectOfInterest=CGRectMake(60/ScreenHigh,(ScreenWidth - 220)/2/ScreenWidth,220/ScreenHigh, 220/ScreenWidth);
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    // 开始捕获
    [_session startRunning];
    
    
    
    
    // Do any additional setup after loading the view.
}
- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        // 停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * matadataObject = [metadataObjects objectAtIndex:0];
        
        _returnData(matadataObject.stringValue);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)returnData:(ReturnDataBlock)dataBlock
{
    _returnData = dataBlock;
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
