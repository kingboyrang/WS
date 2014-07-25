//
//  SuggectionViewController.m
//  WS
//
//  Created by liuqin on 14-5-5.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "SuggectionViewController.h"

@interface SuggectionViewController ()

@end

@implementation SuggectionViewController

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
    // Do any additional setup after loading the view from its nib.
    self.bgImageView.hidden = NO;
    if (self.laugeEN) {
        self.navView.titel_Label.text = @"Suggestion";
        
    }else{
        self.navView.titel_Label.text = @"建议";
        
    }
    
    self.toolbar.hidden = NO;
    self.myTextView.hidden = NO;
    self.label.hidden = NO;
    self.lineImageView.hidden = NO;
    self.xinxiType = @"3";
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(280, 35, 26, 20);
    [imageBtn setImage:[UIImage imageNamed:@"Camera"] forState:0];
    [imageBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:imageBtn];

}

-(void)SubmitAction{
    if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    if (self.myTextView.text.length ==0) {
        UIAlertView *alterview = [[UIAlertView alloc]initWithTitle:nil message:@"建议内容不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterview show];
        return;
    }
    __block UIView *bg=nil;
    if (!bg) {
        bg=[[UIView alloc] initWithFrame:self.view.bounds];
        bg.backgroundColor=[UIColor grayColor];
        bg.alpha=0.613f;
        
        UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-30)/2, (self.view.bounds.size.height-30)/2, 30, 30)];
        indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
        [indicator startAnimating];
        [bg addSubview:indicator];
        [self.view addSubview:bg];
    }
      //队列请求
    
    if (self.fujianArray.count >0) {
        ServiceOperationQueue *queue=[[ServiceOperationQueue alloc] init];
        //这是上传图片
        for (FujianClass *fujianClass in self.fujianArray) {
            NSString *datastr = fujianClass.fujianData;
            NSString *name = fujianClass.fujianName;
            //添加图片上传线程
            [queue addOperation:[self uploadWithBase64:datastr fileName:name]];
        }
        [queue setFinishBlock:^(ServiceOperation *operation) {
            NSDictionary *userInfo=[operation userInfo];
            NSLog(@"operation.responseStatusCode = %d",operation.responseStatusCode);
            if (operation.responseStatusCode==200) {
                NSString *xml=[operation.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
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
                NSLog(@"upload image %@==%@!",[userInfo objectForKey:@"name"],boo?@"success":@"failed!");
            }
            
        }];
        //队列请求成功
        [queue setCompleteBlock:^{
            NSLog(@"image finished!!!!!");
            NSString *fujianStr = [self.sendFujianArray JSONString];
            NSMutableArray *params=[NSMutableArray array];
            NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",JianYiXinXi:\"%@\",FuJian:%@}",self.xiangmuId,self.fankuiId,[UserInfo shareInstance].userId,self.myTextView.text,fujianStr];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chuLiJianYiXinXi", nil]];
            
            ServiceArgs *args=[[ServiceArgs alloc] init];
            args.methodName=@"ChuLiJianYiXinXi";//要调用的webservice方法
            args.soapParams=params;//传递方法参数
            
            
            ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
            [manager setFinishBlock:^{
                [bg removeFromSuperview];
                bg=nil;
                NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
                XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
                XmlNode *node=[_helper soapXmlSelectSingleNode:@"//ChuLiJianYiXinXiResponse"];
                
                NSDictionary *resultJsonDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
                if (resultJsonDic&&[resultJsonDic.allKeys containsObject:@"return"]&&[[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
                    
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:[resultJsonDic objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }];
            [manager setFailedBlock:^{
                [bg removeFromSuperview];
                bg=nil;
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alterView show];
            }];
            [manager startAsynchronous];
        }];

    }else{
        NSString *fujianStr = [self.sendFujianArray JSONString];
        NSMutableArray *params=[NSMutableArray array];
        NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",JianYiXinXi:\"%@\",FuJian:%@}",self.xiangmuId,self.fankuiId,[UserInfo shareInstance].userId,self.myTextView.text,fujianStr];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chuLiJianYiXinXi", nil]];
        
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.methodName=@"ChuLiJianYiXinXi";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        [manager setSuccessBlock:^() {
            if (manager.error) {
                return;
            }
            [bg removeFromSuperview];
            NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
            XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
            XmlNode *node=[_helper soapXmlSelectSingleNode:@"//ChuLiJianYiXinXiResponse"];
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            
            if ([[resultDic objectForKey:@"return"]isEqualToString:@"true"]) {
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alterView show];
            }else{
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"添加不成功" message:[resultDic objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alterView show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        [manager startSynchronous];//开始同步
  
    }
    
    
}



@end
