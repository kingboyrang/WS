//
//  BaseViewController.m
//  WS
//
//  Created by gwzd on 14-4-1.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

//@synthesize albumCamera;
//@synthesize xiangmuId;
//@synthesize fankuiId;
//@synthesize bgImageView;
//
//@synthesize imageScrollView;
//
//@synthesize toolbar;
//@synthesize navView;
//
//@synthesize fujianArray; //选择图片的信息数组
//@synthesize fujianResultStr;
//@synthesize xinxiType;
//@synthesize sendFujianArray;//向服务发送的数组
//
//@synthesize myTextView;
//@synthesize label;
//@synthesize lineImageView;

#pragma mark 判断网络
-(BOOL)IsEnableConnection{
    
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.albumCamera=[[AlbumCameraImage alloc] init];
    self.albumCamera.delegate=self;
    
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.bgImageView setImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.view addSubview:self.bgImageView];
    self.bgImageView.hidden = YES;
   self.sendFujianArray = [[NSMutableArray alloc]init];
    self.fujianArray = [[NSMutableArray alloc]init];
    IF_IOS7_OR_GREATER(
                       self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
                       self.extendedLayoutIncludesOpaqueBars = NO;
                       self.modalPresentationCapturesStatusBarAppearance = NO;
                       )
    self.navigationController.navigationBarHidden = YES;
    if (self.navigationController.viewControllers.count > 1) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
           self.navView = [[[NSBundle mainBundle]loadNibNamed:@"NavView_7" owner:nil options:nil]objectAtIndex:0];
            self.navView.delegate = self;
            [self.view addSubview:self.navView];
        }else{
            self.navView = [[[NSBundle mainBundle]loadNibNamed:@"NavView" owner:nil options:nil]objectAtIndex:0];
            self.navView.delegate = self;
            [self.view addSubview:self.navView];
 
        }
    }
    self.toolbar = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                          self.view.bounds.size.height -60.0f,
                                                          self.view.bounds.size.width,
                                                          60.0f)];

    self.toolbar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.toolbar];
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(100, 15,120, 30);
    
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        [sendButton setImage:[UIImage imageNamed:@"Submit1"] forState:UIControlStateNormal];
        [sendButton setImage:[UIImage imageNamed:@"submit-1"] forState:UIControlStateHighlighted];
    }else{
        [sendButton setImage:[UIImage imageNamed:@"tijiao_normal"] forState:UIControlStateNormal];
        [sendButton setImage:[UIImage imageNamed:@"tijiao_sele"] forState:UIControlStateHighlighted];
    }
    
  
    [sendButton addTarget:self action:@selector(SubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar addSubview:sendButton];
    self.toolbar.hidden = YES;
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 320, 30)];
    self.label.text = @"  字数限制还剩1000字";
    self.label.textAlignment = NSTextAlignmentLeft;
    self.label.textColor = [UIColor grayColor];
    self.label.font = [UIFont systemFontOfSize:14];
    self.label.backgroundColor = [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];
    [self.view addSubview:self.label];
    [self.label setHidden:YES];
    
    self.lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.label.frame.origin.y + self.label.frame.size.height, 320, 1)];
    self.lineImageView.backgroundColor = [UIColor whiteColor];
    self.lineImageView.alpha = 0.8;
    [self.view addSubview:self.lineImageView];
    self.lineImageView.hidden = YES;
    self.myTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, 320, self.view.bounds.size.height - (self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height)-60)];
    self.myTextView.backgroundColor = [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];
    self.myTextView.returnKeyType = UIReturnKeyDone;
      self.myTextView.delegate = self;
    [self.view addSubview:self.myTextView];
    [self.myTextView setHidden:YES];
}
#pragma mark 返回
-(void)back
{
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)navBarItembackPressed:(id)sender
{
//    if(self.goBackHandler){
//        self.goBackHandler();
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - 调用相册和相机
-(void)chooseImage {
      // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
    
        sheetView = [[[NSBundle mainBundle]loadNibNamed:IPHONE5 ? @"MySheetView":@"MySheetView_3.5" owner:nil options:nil]objectAtIndex:0];
        BOOL ISEN = [[Global getPreferredLanguage]isEqualToString:@"en"];
        [sheetView.takePhotoBtn setTitle:ISEN? @"Take photo":@"拍照" forState:UIControlStateNormal];
        [sheetView.photeBtn setTitle:ISEN?@"Chose photo":@"从手机相册选择" forState:UIControlStateNormal];
        
        
    }
    
    else {
        sheetView = [[[NSBundle mainBundle]loadNibNamed:IPHONE5?@"MySheetView_noCrame":@"MySheetView_noCrame3.5" owner:nil options:nil]objectAtIndex:0];
        [sheetView.photeBtn setTitle:@"Chose photo" forState:UIControlStateNormal];
        
        
    }
    sheetView.delegate = self;
    [self.view addSubview:sheetView];
    
}
#pragma mark -sheetAction
-(void)MySheetAction:(int)tag{
    NSUInteger sourceType = 0;
 [sheetView removeFromSuperview];
    if (tag == 100) {
        [sheetView removeFromSuperview];
    }else if (tag == 200){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = 1;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];

    }else if (tag == 300){
        [self.albumCamera showCameraInController:self];

    }
}

/////////////////////////////////////
- (void)photoFromAlbumCameraWithImage:(UIImage*)image{
    //取得拍照图片
    //Document
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *  locationString=[dateformatter stringFromDate:senddate]; //当前时间
    NSString *fileName = locationString;  //得到图片名字
    NSData *_data = UIImageJPEGRepresentation(image, 0.8f);
    NSString *_encodedImageStr = [_data base64Encoding];//转成base64String
    FujianClass *class = [[FujianClass alloc]init];
    class.fujianName = [NSString stringWithFormat:@"%@.png",fileName];
    class.fujianData = _encodedImageStr;
    class.myImage = image;
    [self.fujianArray addObject:class];
    [self addFujianView];
    
}
- (void)dismissImagePickerController
{
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popToViewController:self animated:YES];
    }
}
#pragma mark - QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [self dismissImagePickerController];
}
#pragma mark - done方法
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets  //图片名
{
    for (ALAsset *item in assets) {
        
        ALAssetRepresentation *representation = [item defaultRepresentation];
        NSString *fileName = [representation filename];  //得到图片名字
        UIImage *image = [UIImage imageWithCGImage:representation.fullResolutionImage];//原图
        NSData *_data = UIImageJPEGRepresentation(image, 0.8f);
         NSString *_encodedImageStr = [_data base64Encoding];//转成base64String
        FujianClass *class = [[FujianClass alloc]init];
        class.fujianName = [NSString stringWithFormat:@"%@",fileName];
        class.fujianData = _encodedImageStr;
        class.myImage = image;
        [self.fujianArray addObject:class];
    }
     [self dismissImagePickerController];
    [self addFujianView];
}
#pragma mark -cancel 方法
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    
    [self dismissImagePickerController];
}
#pragma mark 显示图片VIEW
-(void)addFujianView{
    if (self.fujianArray.count > 0) {
        if ([self.view.subviews containsObject:self.imageScrollView])
        {
            [self.imageScrollView removeFromSuperview];
            self.imageScrollView = [[ShowImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height -160.0f, 320,100)];
            
            self.imageScrollView.scrollview.contentSize = CGSizeMake(self.fujianArray.count * 95+10,100);
            [self.view addSubview:self.imageScrollView];
            
        }
        else
        {
            self.imageScrollView = [[ShowImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 160.0f, 320, 100)];
            
            self.imageScrollView.scrollview.contentSize = CGSizeMake(self.fujianArray.count * 95+10, 100);
            [self.view addSubview:self.imageScrollView];
            
        }
        for (int i = 0; i< self.fujianArray.count;i++) {
            
            FujianClass *class = [self.fujianArray objectAtIndex:i];
            UIButton *deleBtn=[[UIButton alloc] initWithFrame:CGRectMake(80+i*95, 0,20, 20)];
            [deleBtn setImage:[UIImage imageNamed:@"deleBtn"] forState:0];
            deleBtn.tag=i;
            [deleBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *ImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*95,10, 80, 80)];
            [ImageView setImage:class.myImage];
            [self.imageScrollView.scrollview addSubview:ImageView];
            [self.imageScrollView.scrollview addSubview:deleBtn];
        }
    }
    else{
        if ([self.view.subviews containsObject:self.imageScrollView]) {
            [self.imageScrollView removeFromSuperview];
            
        }
    }
}
#pragma mark 删除图片
-(void)deleteImage:(UIButton *)btn{
    int tag = btn.tag;
    [self.fujianArray removeObjectAtIndex:tag];
    [self addFujianView];
}

#pragma  mark 发送附件
//图片上传
-(ServiceOperation*)uploadWithBase64:(NSString *)base64string  fileName:(NSString *)fileName{
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:base64string,@"base64String", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:fileName,@"fileName", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.xinxiType,@"xiaoXiLeiXing", nil]];
    
    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"UploadFile";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    args.httpWay=ServiceHttpSoap1;
   
    ServiceOperation *operation=[[ServiceOperation alloc] initWithArgs:args];
    operation.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:fileName,@"name", nil];
    return operation;
}
-(void)sendMessage:(NSString *)base64string  fileName:(NSString *)fileName completed:(void(^)())finished{
    
    
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:base64string,@"base64String", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:fileName,@"fileName", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.xinxiType,@"xiaoXiLeiXing", nil]];

    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"UploadFile";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    args.httpWay=ServiceHttpSoap1;
    NSLog(@"header=%@",args.headers);
    NSLog(@"body=%@",args.bodyMessage);
    

    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    
    [manager setSuccessBlock:^() {
        if (manager.error) {
            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            
            return;
        }
        NSLog(@"登录请求成功，请求结果为=\n%@",manager.responseString);
        NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
        XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
        XmlNode *node=[_helper soapXmlSelectSingleNode:@"//UploadFileResult"];
        BOOL boo=NO;
        NSDictionary *resultJsonDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
        if (resultJsonDic&&[resultJsonDic.allKeys containsObject:@"return"]&&[[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
            boo=YES;
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSDictionary *dic = @{@"YuanMingCheng": [resultJsonDic objectForKey:@"YuanMingCheng"],@"XinMingCheng":[resultJsonDic objectForKey:@"XinMingCheng"],@"LeiXing":[resultJsonDic objectForKey:@"LeiXing"]};
            [array addObject:dic];
            [self.sendFujianArray addObject:dic];
        }
        
    }];
    [manager startSynchronous];//开始同步
    
 }

#pragma mark textView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    self.label.text = [NSString stringWithFormat:@"  字数限制还剩%d字",1000-number];
    NSLog(@"%d",number);
    if (number > 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于1000" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:128];
        number = 1000;
    }
}

-(void)SubmitAction{
    
}
@end
