//
//  BaseViewController.m
//  WS
//
//  Created by gwzd on 14-4-1.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "Global.h"
#import "ServiceResult.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

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
    // Do any additional setup after loading the view.
    
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
    [sendButton setImage:[UIImage imageNamed:@"tijiao_normal"] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"tijiao_sele"] forState:UIControlStateHighlighted];
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
    self.myTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, 320, 410)];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated ];
}
#pragma mark - 调用相册和相机
-(void)chooseImage {
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = 1;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
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
        NSData *_data = UIImageJPEGRepresentation(image, 1.0f);
         NSString *_encodedImageStr = [_data base64Encoding];//转成base64String
        FujianClass *class = [[FujianClass alloc]init];
        class.fujianName = fileName;
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
//    NSLog(@"%@",self.fujianArray);
    [self addFujianView];
}

#pragma  mark 发送附件
-(void)sendMessage:(NSString *)base64string  fileName:(NSString *)fileName completed:(void(^)())finished{
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:base64string,@"base64String", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:fileName,@"fileName", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:self.xinxiType,@"xiaoXiLeiXing", nil]];

    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"UploadFile";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
//            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            return;
        }
        ServiceResult *sr=[ServiceResult serviceWithArgs:args responseText:manager.responseString];
        NSDictionary *resultJsonDic =[sr json];
        if (resultJsonDic&&[resultJsonDic.allKeys containsObject:@"return"]&&[[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
            [self.sendFujianArray addObject:resultJsonDic];
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
//    self.statusLabel.text = [NSString stringWithFormat:@"%d/128",number];
}
#pragma mark xmlparser 图片
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //        NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"UploadFileResult"]) {
        self.fujianResultStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.fujianResultStr appendString:string];
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}

//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //      NSLog(@"%@",NSStringFromSelector(_cmd) );
}
//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
}


@end
