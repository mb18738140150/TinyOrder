//
//  AddMenuViewController.m
//  TinyOrder
//
//  Created by 仙林 on 15/4/8.
//  Copyright (c) 2015年 仙林. All rights reserved.
//

#import "AddMenuViewController.h"
#import "AddMenuView.h"
#import "DetailModel.h"
#import "AFNetworking.h"
#import <UIImageView+WebCache.h>
#import "TasteDetailsCell.h"
#import "TasteDetailModel.h"
#import "MenuModel.h"
#define CELLIDENTIFIRE @"cell"

#import "MealPropertyViewController.h"

#define CaidanbuttonTag 1000

@interface AddMenuViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HTTPPostDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    BOOL _isSeleteImage;
}
@property (nonatomic, copy)ReturnValueBlock returnValueBlock;

@property (nonatomic, strong)AddMenuView * addMenuView;
@property (nonatomic, strong)NSString * submitImageName;
@property (nonatomic, strong)UIImagePickerController * imagePC;

@property (nonatomic, strong)NSMutableArray * propertyArray;

// 弹出框
@property (nonatomic, strong)UIView * tanchuView;

// 添加口味视图
@property (nonatomic, strong)UIView * addTasteView;

// 口味信息设置视图
@property (nonatomic, strong)UIView * tastePriceAndIntegralView;
@property (nonatomic, strong)UITextField * tasteNameTF;
@property (nonatomic, strong)UITextField * priceTF;
@property (nonatomic, strong)UITextField * integralTF;

// 菜单列表
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)MenuModel * model;
// 新加菜品返回的foodId
//@property (nonatomic, assign)int foodId;

@end

@implementation AddMenuViewController
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)propertyArray
{
    if (!_propertyArray) {
        self.propertyArray = [NSMutableArray array];
    }
    return _propertyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int isAddOrEdit = 0;
    
    if (self.classifyId) {
        isAddOrEdit = 1;
    }
    // 获取classifyId类名
    NSString * str = [NSString stringWithUTF8String:object_getClassName(self.classifyId)];
    NSLog(@"********%d*********%@", isAddOrEdit, str);
    self.addMenuView = [[AddMenuView alloc] initWithFrame:self.view.bounds andIsfromwaimaiOrTangshi:self.isFromeWaimaiOrTangshi isAddOrEdit:isAddOrEdit];
//    [_addMenuView.submitButton addTarget:self action:@selector(submitNewMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [_addMenuView.photoButton addTarget:self action:@selector(getPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_addMenuView.mealPropertyBT addTarget:self action:@selector(addMealPropertyAction:) forControlEvents:UIControlEventTouchUpInside];
    _addMenuView.nameTF.delegate = self;
    _addMenuView.paceTF.delegate = self;
    _addMenuView.integralTF.delegate = self;
    _addMenuView.numberTF.delegate = self;
    _addMenuView.sortCodeTF.delegate = self;
    _addMenuView.unitTF.delegate = self;
    _addMenuView.markTF.delegate = self;
    _addMenuView.describeTFview.delegate = self;
    if (self.isFromeWaimaiOrTangshi == 2) {
        _addMenuView.synchronousLabel.text = @"是否同步到外卖";
    }else
    {
        _addMenuView.synchronousLabel.text = @"是否同步到堂食";
    }
    [_addMenuView.synchronousBT addTarget:self action:@selector(synchronousAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _addMenuView.propertyTableView.delegate = self;
    _addMenuView.propertyTableView.dataSource = self;
    [_addMenuView.propertyTableView registerClass:[TasteDetailsCell class] forCellReuseIdentifier:CELLIDENTIFIRE];
    _addMenuView.propertyTableView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [_addMenuView addGestureRecognizer:tapGesture];
    [self.view addSubview:_addMenuView];
    
    _isSeleteImage = NO;
    if (self.detailMD) {
        self.addMenuView.nameTF.text = self.detailMD.name;
        self.addMenuView.paceTF.text = [NSString stringWithFormat:@"%@", self.detailMD.money];
        self.addMenuView.integralTF.text = [NSString stringWithFormat:@"%d", self.detailMD.integral];
        self.addMenuView.numberTF.text = [NSString stringWithFormat:@"%@", self.detailMD.foodBoxMoney];
        [self.addMenuView.photoView sd_setImageWithURL:[NSURL URLWithString:self.detailMD.icon] placeholderImage:[UIImage imageNamed:@"PHOTO.png"]];
        self.addMenuView.sortCodeTF.text = [NSString stringWithFormat:@"%d", self.detailMD.SortCode];
        
        self.addMenuView.propertyTableView.hidden = NO;
        self.addMenuView.addPropertyButton.hidden = NO;
        
        NSArray * array = self.detailMD.attList;
        for (NSDictionary * dic in array) {
            TasteDetailModel * model = [[TasteDetailModel alloc]initWithDiationary:dic];
            [self.propertyArray addObject:model];
        }
    }else if (self.foodId)
    {
        self.addMenuView.propertyTableView.hidden = NO;
        self.addMenuView.addPropertyButton.hidden = NO;
    }
    [self.addMenuView.addPropertyButton addTarget:self action:@selector(choceTasteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.imagePC = [[UIImagePickerController alloc] init];
    _imagePC.allowsEditing = YES;
    _imagePC.delegate = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backLastVC:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitNewMenuAction:)];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    if (self.foodId) {
        
        NSDictionary * jsonDic1 = @{
                                    @"UserId":[UserInfo shareUserInfo].userId,
                                    @"Command":@60,
                                    @"FoodId":@(self.foodId)
                                    };
        [self playPostWithDictionary:jsonDic1];
        
        NSDictionary * jsonDic = @{
                                   @"UserId":[UserInfo shareUserInfo].userId,
                                   @"Command":@63,
                                   @"FoodId":@(self.foodId)
                                   };
        [self playPostWithDictionary:jsonDic];
    }
    
    self.tanchuView = [[UIView alloc]initWithFrame:self.view.bounds];
    _tanchuView.backgroundColor = [UIColor clearColor];
//    _tanchuView.alpha = .1;
    
}

- (void)backLastVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getPhotoAction:(UIButton *)button
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中获取", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    /*
    UIImagePickerController * imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeCamera;
    imagePC.allowsEditing = YES;
    imagePC.delegate = self;
    [self presentViewController:imagePC animated:YES completion:nil];
     */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePC animated:YES completion:nil];
            }else
            {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相机,请你选择图库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
            break;
        case 1:
        {
            self.imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePC animated:YES completion:nil];
//            NSLog(@"相册");
        }
            break;
            
        default:
            break;
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    self.addMenuView.photoView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    _isSeleteImage = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TxetView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请填入菜品描述(选填)"] || textView.text.length == 0) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithWhite:0.15 alpha:1];
    }
}

- (void)tapGestureAction{
    [self animateFrame];
    [self.addMenuView.nameTF resignFirstResponder];
    [self.addMenuView.paceTF resignFirstResponder];
    [_addMenuView.integralTF resignFirstResponder];
    [_addMenuView.numberTF resignFirstResponder];
    [_addMenuView.unitTF resignFirstResponder];
    [_addMenuView.markTF resignFirstResponder];
    [_addMenuView.sortCodeTF resignFirstResponder];
    [_addMenuView.describeTFview resignFirstResponder];
}

- (void)animateFrame
{
//    [UIView animateWithDuration:1 animations:^{
//        _addMenuView.frame = self.view.bounds;
//    }];
}


- (void)submitNewMenuAction:(UIBarButtonItem *)button
{
    if (self.addMenuView.nameTF.text.length != 0 && self.addMenuView.paceTF.text.length != 0) {
        if (self.detailMD != nil && _isSeleteImage == NO) {
            int sortCode = 1000;
            if (self.addMenuView.sortCodeTF.text.length != 0) {
                sortCode = [self.addMenuView.sortCodeTF.text intValue];
            }else
            {
                sortCode = 100;
            }
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@12,
                                       @"Name":self.addMenuView.nameTF.text,
                                       @"Money":[NSNumber numberWithDouble:[self.addMenuView.paceTF.text doubleValue]],
                                       @"MealId":@(self.foodId),
                                       @"Icon":self.detailMD.icon,
                                       @"FoodBoxMoney":[NSNumber numberWithDouble:[self.addMenuView.numberTF.text doubleValue]],
                                       @"Integral":@([self.addMenuView.integralTF.text intValue]),
                                       @"Describe":_addMenuView.describeTFview.text,
                                       @"Unit":_addMenuView.unitTF.text,
                                       @"Mark":_addMenuView.markTF.text,
                                       @"SortCode":@(sortCode)
                                       };
            [self playPostWithDictionary:jsonDic];
        }else
        {
            NSString * urlString = @"http://p.vlifee.com/uploadimg.aspx?savetype=4";
            [self uploadImageWithUrlString:urlString];
        }
        [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
//        [self.navigationController popViewControllerAnimated:YES];
//        self.returnValueBlock(self.addMenuView.nameTF.text);
        /*
        if (self.detailMD) {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Name":self.addMenuView.nameTF.text,
                                       @"Count":[NSNumber numberWithInt:[self.addMenuView.numberTF.text intValue]],
                                       @"Money":[NSNumber numberWithDouble:[self.addMenuView.paceTF.text doubleValue]],
                                       @"MealId":self.detailMD.mealId
                                       };
            [self playPostWithDictionary:jsonDic];
        }else if (self.classifyId)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Name":self.addMenuView.nameTF.text,
                                       @"Count":[NSNumber numberWithInt:[self.addMenuView.numberTF.text intValue]],
                                       @"Money":[NSNumber numberWithDouble:[self.addMenuView.paceTF.text doubleValue]],
                                       @"ClassifyId":self.classifyId
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        */
    }else
    {
        UIAlertView * alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"菜名,价格,图片都不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alerView show];
    }
}

- (void)uploadImageWithUrlString:(NSString *)urlString
{
    
    NSString * url = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UIImage * image = self.addMenuView.photoView.image;
    NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString * imageName = [self imageName];
    NSString * imagePath = [[self getLibarayCachePath] stringByAppendingPathComponent:imageName];
    [imageData writeToFile:imagePath atomically:YES];
    __weak AddMenuViewController * addMenuVC = self;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:imagePath mimeType:@"image/jpg/file"];
//        [formData appendPartWithFormData:imageData name:imageName];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject = %@", responseObject);
        if ([[responseObject objectForKey:@"Result"] integerValue] == 1) {
            NSDictionary * jsonDic = nil;
            
            NSLog(@"***addMenuVC.foodId = %d*****%@*", addMenuVC.foodId, addMenuVC.detailMD.mealId);
            
            int sortCode = 1000;
            if (self.addMenuView.sortCodeTF.text.length != 0) {
                sortCode = [self.addMenuView.sortCodeTF.text intValue];
            }else
            {
                sortCode = 100;
            }
            
             if (addMenuVC.foodId || addMenuVC.detailMD.mealId)
            {
                NSNumber * id ;
                
                if (addMenuVC.foodId) {
                    id = @(addMenuVC.foodId);
                }else if (addMenuVC.detailMD.mealId)
                {
                    id = addMenuVC.detailMD.mealId;
                }
                
                jsonDic = @{
                            @"UserId":[UserInfo shareUserInfo].userId,
                            @"Command":@12,
                            @"Name":addMenuVC.addMenuView.nameTF.text,
                            @"Money":[NSNumber numberWithDouble:[addMenuVC.addMenuView.paceTF.text doubleValue]],
                            @"MealId":id,
                            @"Icon":[responseObject objectForKey:@"ImgPath"],
                            @"FoodBoxMoney":[NSNumber numberWithDouble:[addMenuVC.addMenuView.numberTF.text doubleValue]],
                            @"Integral":@([addMenuVC.addMenuView.integralTF.text intValue]),
                            @"Describe":addMenuVC.addMenuView.describeTFview.text,
                            @"Unit":addMenuVC.addMenuView.unitTF.text,
                            @"Mark":addMenuVC.addMenuView.markTF.text,
                            @"SortCode":@(sortCode)
                            };
            }else if (addMenuVC.classifyId) {
                
                int SyncCategoryId = 0;
                if ([_addMenuView.synchronousBT.titleLabel.text isEqualToString:@"否"]) {
                    ;
                }else
                {
                    SyncCategoryId = [self.model.classifyId intValue];
                }
                
                jsonDic = @{
                            @"UserId":[UserInfo shareUserInfo].userId,
                            @"Command":@11,
                            @"Name":addMenuVC.addMenuView.nameTF.text,
                            @"Money":[NSNumber numberWithDouble:[addMenuVC.addMenuView.paceTF.text doubleValue]],
                            @"ClassifyId":addMenuVC.classifyId,
                            @"Icon":[responseObject objectForKey:@"ImgPath"],
                            @"FoodBoxMoney":[NSNumber numberWithDouble:[addMenuVC.addMenuView.numberTF.text doubleValue]],
                            @"Integral":@([addMenuVC.addMenuView.integralTF.text intValue]),
                            @"Describe":addMenuVC.addMenuView.describeTFview.text,
                            @"Unit":addMenuVC.addMenuView.unitTF.text,
                            @"Mark":addMenuVC.addMenuView.markTF.text,
                            @"SortCode":@(sortCode),
                            @"ClassifyType":@(self.isFromeWaimaiOrTangshi),
                            @"SyncCategoryId":@(SyncCategoryId)
                            };
            }
            NSLog(@"***%@", jsonDic);
            [addMenuVC playPostWithDictionary:jsonDic];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"图片添加失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"%@", error);
    }];
    
}


- (NSString *)imageName
{
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString * strTime = [myFormatter stringFromDate:[NSDate date]];
    NSString * name = [NSString stringWithFormat:@"t%@%@%lld%@.png", [UserInfo shareUserInfo].userId, strTime, arc4random() % 9000000000 + 1000000000, [UserInfo shareUserInfo].userName];
//    NSLog(@"%lld", arc4random() % 9000000000 + 1000000000);
    return name;
}

- (NSString *)getLibarayCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", [paths firstObject]);
    return [paths firstObject];
}



- (void)playPostWithDictionary:(NSDictionary *)dic
{
    NSString * jsonStr = [dic JSONString];
        NSLog(@"****%@", jsonStr);
    NSString * str = [NSString stringWithFormat:@"%@231618", jsonStr];
    NSString * md5Str = [str md5];
    NSString * urlString = [NSString stringWithFormat:@"%@%@", POST_URL, md5Str];
    
    HTTPPost * httpPost = [HTTPPost shareHTTPPost];
    [httpPost post:urlString HTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    httpPost.delegate = self;
}



- (void)refresh:(id)data
{
    NSLog(@"data==%@", data);
    //    NSDictionary * dataDic = (NSDictionary *)data;
    [SVProgressHUD dismiss];
    if ([[data objectForKey:@"Result"] isEqual:@1]) {
        
         if ([[data objectForKey:@"Command"] isEqual:@10060])
        {
            
            if (self.propertyArray.count != 0) {
                [self.propertyArray removeAllObjects];
            }
            NSArray * array = [data objectForKey:@"AttList"];
            for (NSDictionary * dic in array) {
                TasteDetailModel * model = [[TasteDetailModel alloc]initWithDiationary:dic];
                [self.propertyArray addObject:model];
            }
            
            [self.addMenuView.propertyTableView reloadData];
        }else if ([[data objectForKey:@"Command"] isEqual:@10061])
        {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
             if (self.foodId)
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@60,
                                           @"FoodId":@(self.foodId)
                                           };
                [self playPostWithDictionary:jsonDic];
            }
        }else if ([[data objectForKey:@"Command"] isEqual:@10059])
        {
            UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertV show];
            [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
            if (self.foodId)
            {
                NSDictionary * jsonDic = @{
                                           @"UserId":[UserInfo shareUserInfo].userId,
                                           @"Command":@60,
                                           @"FoodId":@(self.foodId)
                                           };
                [self playPostWithDictionary:jsonDic];
            }
        }else if ([[data objectForKey:@"Command"] isEqual:@10063])
        {
            DetailModel * model = [[DetailModel alloc]initWithDictionary:data];
            self.detailMD = model;
            self.detailMD.mealId = @(self.foodId);
            NSLog(@"*%@*****%d", self.detailMD.mealId, self.foodId);
            self.addMenuView.nameTF.text = model.name;
            self.addMenuView.paceTF.text = [NSString stringWithFormat:@"%@", model.money];
            self.addMenuView.integralTF.text = [NSString stringWithFormat:@"%d", model.integral];
            self.addMenuView.numberTF.text = [NSString stringWithFormat:@"%@", model.foodBoxMoney];
            [self.addMenuView.photoView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"PHOTO.png"]];
            self.addMenuView.sortCodeTF.text = [NSString stringWithFormat:@"%d", self.detailMD.SortCode];
            self.addMenuView.propertyTableView.hidden = NO;
            self.addMenuView.addPropertyButton.hidden = NO;
        }else if ([[data objectForKey:@"Command"] isEqual:@10001])
        {
#warning fff
            NSArray * menuArray = [data objectForKey:@"ClassifyList"];
            if (self.dataArray.count) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary * dic in menuArray) {
                MenuModel * menuMD = [[MenuModel alloc] initWithDictionary:dic];
                [self.dataArray addObject:menuMD];
            }
            [self tanchucandan];
        }
        else
        {
            
            if (self.foodId) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }else if (self.classifyId)
            {
                self.foodId = [[data objectForKey:@"FoodId"] intValue];
                NSLog(@"*****%d", self.foodId);
                //            NSLog(@"***self.foodId =%d ***** (int)[data objectForKey] = %d***", self.foodId, (int)[data objectForKey:@"FoodId"]);
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"菜品添加成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
                
                self.addMenuView.propertyTableView.hidden = NO;
                self.addMenuView.addPropertyButton.hidden = NO;
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }

        
    }else
    {
        [SVProgressHUD dismiss];
        UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:[data objectForKey:@"ErrorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    }
    NSLog(@"%@", [data objectForKey:@"ErrorMsg"]);
}

- (void)failWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    UIAlertView * alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertV show];
    [alertV performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
    NSLog(@"error = %@", error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex) {
//        MealPropertyViewController * mealVC = [[MealPropertyViewController alloc]init];
//        
//        mealVC.foodId = self.foodId;
//        
//        NSLog(@"mealVC.foodId = %d****self.foodId = %d****", mealVC.foodId, self.foodId);
//        
//        [self.navigationController pushViewController:mealVC animated:YES];
//    }else
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"出现时候foodid = %d", self.foodId);
}

- (void)returnMenuValue:(ReturnValueBlock)valueBlock
{
    _returnValueBlock = valueBlock;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.foodId = 0;
//    self.classifyId = 0;
//    self.detailMD = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    if (_returnValueBlock) {
        _returnValueBlock();
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UIView animateWithDuration:1.0 animations:^{
//        self.addMenuView.frame = CGRectMake(0, -160, self.view.frame.size.width, self.view.frame.size.height);
//    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animateFrame];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:_addMenuView.sortCodeTF] || [textField isEqual:_addMenuView.integralTF] ) {
        NSCharacterSet * chracteSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"] invertedSet];
        NSString *filestring = [[string componentsSeparatedByCharactersInSet:chracteSet]componentsJoinedByString:@""];
        BOOL a = [string isEqualToString:filestring];
        return a;
    }else if ([textField isEqual:_addMenuView.numberTF] || [textField isEqual:_addMenuView.paceTF])
    {
        NSCharacterSet * chracteSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        NSString *filestring = [[string componentsSeparatedByCharactersInSet:chracteSet]componentsJoinedByString:@""];
        BOOL a = [string isEqualToString:filestring];
        return a;
    }
    return YES;
}
#pragma mark - 添加菜品属性
- (void)addMealPropertyAction:(UIButton *)button
{
    MealPropertyViewController * mealVC = [[MealPropertyViewController alloc]init];
    
    mealVC.tasteDetaileArray = [self.detailMD.attList mutableCopy];
    mealVC.detailMD = self.detailMD;
    [self.navigationController pushViewController:mealVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - propertyTableView datesource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.propertyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TasteDetailModel * tasteModel = [self.propertyArray objectAtIndex:indexPath.row];
    TasteDetailsCell * cell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIRE forIndexPath:indexPath];
    [cell creatSubviews:self.addMenuView.propertyTableView.bounds];
    
    cell.tasteDetailsView.nameLabel.text = tasteModel.attName;
    cell.tasteDetailsView.integralLabel.text = [NSString stringWithFormat:@"%d", tasteModel.attIntegral];
    cell.tasteDetailsView.priceLabel.text = [NSString stringWithFormat:@"%.2f", tasteModel.attPrice];
    
    return cell;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TasteDetailModel * model = [self.propertyArray objectAtIndex:indexPath.row];
        
       if (self.foodId)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@61,
                                       @"AttId":@(model.attId),
                                       @"FoodId":@(self.foodId)
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        
    }];
    rowAction.backgroundColor = [UIColor redColor];
    NSArray * arr = @[rowAction];
    return arr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, (self.view.width - 40) / 2, 39)];
    titleLabel.text = @"菜品属性";
    titleLabel.backgroundColor = [UIColor whiteColor];
    
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

#pragma mark - 添加某菜品附加属性

- (void)choceTasteAction:(UIButton *)button
{
   
    
    [self.view addSubview:_tanchuView];
    
    [_tanchuView removeAllSubviews];
    
        
        UIView * backView = [[UIView alloc]init];
        backView.frame = _tanchuView.frame;
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = .5;
        [_tanchuView addSubview:backView];
        
        UIView *tastePriceAndIntegralView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 20, 200)];
        tastePriceAndIntegralView.center = _tanchuView.center;
        tastePriceAndIntegralView.backgroundColor = [UIColor whiteColor];
        [_tanchuView addSubview:tastePriceAndIntegralView];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 40, 30)];
        titleLabel.text = @"名称";
        titleLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        [tastePriceAndIntegralView addSubview:titleLabel];
        
        self.tasteNameTF = [[UITextField alloc]initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, tastePriceAndIntegralView.width - 80, 30)];
        _tasteNameTF.placeholder = @"属性名称";
        _tasteNameTF.borderStyle = UITextBorderStyleNone;
//        _tasteNameTF.keyboardType = UIKeyboardTypeNumberPad;
        [tastePriceAndIntegralView addSubview:_tasteNameTF];
        
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(20, _tasteNameTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
        lineView2.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        [tastePriceAndIntegralView addSubview:lineView2];
        
        
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, titleLabel.bottom + 10, 40, 30)];
        priceLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = @"￥";
        [tastePriceAndIntegralView addSubview:priceLabel];
        
        self.priceTF = [[UITextField alloc]initWithFrame:CGRectMake(priceLabel.right, titleLabel.bottom + 10, tastePriceAndIntegralView.width - 80, 30)];
        _priceTF.placeholder = @"请设置价格";
        _priceTF.borderStyle = UITextBorderStyleNone;
        _priceTF.keyboardType = UIKeyboardTypeNumberPad;
        [tastePriceAndIntegralView addSubview:_priceTF];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(20, _priceTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        [tastePriceAndIntegralView addSubview:lineView];
        
        UILabel * integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 10, 40, 30)];
        integralLabel.textColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        integralLabel.textAlignment = NSTextAlignmentCenter;
        integralLabel.text = @"积";
        [tastePriceAndIntegralView addSubview:integralLabel];
        
        self.integralTF = [[UITextField alloc]initWithFrame:CGRectMake(integralLabel.right, lineView.bottom + 10, tastePriceAndIntegralView.width - 80, 30)];
        _integralTF.placeholder = @"请设置积分";
        _integralTF.borderStyle = UITextBorderStyleNone;
        _integralTF.keyboardType = UIKeyboardTypeNumberPad;
        [tastePriceAndIntegralView addSubview:_integralTF];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(20, _integralTF.bottom, tastePriceAndIntegralView.width - 40, 1)];
        lineView1.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:72 / 255.0 blue:47 / 255.0 alpha:1];
        [tastePriceAndIntegralView addSubview:lineView1];
        
        
        UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancleButton.frame = CGRectMake(40, lineView1.bottom + 9, 80, 40);
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
    
    if (self.priceTF.text.length == 0 || self.tasteNameTF.text.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"菜品属性名称,价格不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
//        if (self.detailMD) {
//            NSDictionary * jsonDic = @{
//                                       @"UserId":[UserInfo shareUserInfo].userId,
//                                       @"Command":@59,
//                                       @"AttrName":self.tasteNameTF.text ,
//                                       @"FoodId":self.detailMD.mealId,
//                                       @"AttrPrice":@([self.priceTF.text doubleValue]),
//                                       @"AttrIntegral":@([self.integralTF.text integerValue])
//                                       };
//            [self playPostWithDictionary:jsonDic];
//        }else
            if (self.foodId)
        {
            NSDictionary * jsonDic = @{
                                       @"UserId":[UserInfo shareUserInfo].userId,
                                       @"Command":@59,
                                       @"AttrName":self.tasteNameTF.text ,
                                       @"FoodId":@(self.foodId),
                                       @"AttrPrice":@([self.priceTF.text doubleValue]),
                                       @"AttrIntegral":@([self.integralTF.text integerValue])
                                       };
            [self playPostWithDictionary:jsonDic];
        }
        
    }
    
    
}

- (void)synchronousAction:(UIButton *)button
{
    int type = 0;
    if (self.isFromeWaimaiOrTangshi == 1) {
        type = 2;
    }else
    {
        type = 1;
    }
    
    NSDictionary * jsonDic = @{
                               @"UserId":[UserInfo shareUserInfo].userId,
                               @"CurPage":@1,
                               @"Command":@1,
                               @"CurCount":@(MAX_CANON),
                               @"ClassifyType":@(type)
                               };
    [self playPostWithDictionary:jsonDic];
}

- (void)tanchucandan
{
    if (self.dataArray.count) {
        
        [self.view addSubview:_tanchuView];
        
        [_tanchuView removeAllSubviews];
        
        
        UIView * backView = [[UIView alloc]init];
        backView.frame = _tanchuView.frame;
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = .5;
        [_tanchuView addSubview:backView];
        
        
        UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width / 2, self.view.height / 2)];
        scrollView.backgroundColor = [UIColor whiteColor];
        
        UIButton * cancleBT = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancleBT setTitle:@"否" forState:UIControlStateNormal];
        cancleBT.frame = CGRectMake(0, 0, scrollView.width, 30);
        cancleBT.tag = CaidanbuttonTag * 2;
        [cancleBT addTarget:self action:@selector(choseCaidan:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:cancleBT];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            MenuModel * model = [self.dataArray objectAtIndex:i];
            UIButton * caidanbutton = [UIButton buttonWithType:UIButtonTypeSystem];
            [caidanbutton setTitle:model.name forState:UIControlStateNormal];
            caidanbutton.frame = CGRectMake(0, 30 * (1 + i), scrollView.width, 30);
            caidanbutton.tag = CaidanbuttonTag + i;
            [caidanbutton addTarget:self action:@selector(choseCaidan:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:caidanbutton];
        }
        
        if (self.dataArray.count > 5) {
            scrollView.frame = CGRectMake(0, 0, self.view.width / 2, self.view.height / 2);
            scrollView.contentSize = CGSizeMake(scrollView.width, self.dataArray.count * 30 + 30);
        }else
        {
            scrollView.frame = CGRectMake(0, 0, self.view.width / 2, self.dataArray.count * 30 + 30);
        }
        
        scrollView.center = self.view.center;
        
        [_tanchuView addSubview:scrollView];
        
        [self animateIn];
    }
    
}

- (void)choseCaidan:(UIButton *)button
{
    [self.tanchuView removeFromSuperview];
    if (button.tag != CaidanbuttonTag * 2) {
        NSInteger num = button.tag - CaidanbuttonTag;
        self.model = [self.dataArray objectAtIndex:num];
        
        [_addMenuView.synchronousBT setTitle:self.model.name forState:UIControlStateNormal];
    }else
    {
        [_addMenuView.synchronousBT setTitle:@"否" forState:UIControlStateNormal];
    }
    
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
