//
//  ResultViewController.m
//  WS
//
//  Created by liuqin on 14-5-7.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

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
    
    if (self.laugeEN) {
        self.navView.titel_Label.text = @"Result";
    }else{
        self.navView.titel_Label.text = @"结果";
    }
    
    self.bgImageView.hidden = NO;
    self.toolbar.hidden = NO;
    self.bgImageView.hidden = NO;
    self.toolbar.hidden = NO;
    self.myTextView.hidden = NO;
    self.label.hidden = NO;
    self.lineImageView.hidden = NO;
    self.xinxiType = @"5";
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(280, 35, 26, 20);
   [imageBtn setImage:[UIImage imageNamed:@"Camera"] forState:0];

    [imageBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:imageBtn];
    
   
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 30)];
    headview.backgroundColor = [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];

    [self.view addSubview:headview];
    
     self.resultTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 70, 280, 20)];
    [self.resultTypeBtn setBackgroundImage:[UIImage imageNamed:@"searchSeleBtn"] forState:UIControlStateNormal];
    [self.resultTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resultTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:self.resultTypeBtn];
    [self.resultTypeBtn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];

    self.label.hidden = NO;
    self.myTextView.hidden = NO;
    self.lineImageView.hidden = NO;
    self.label.frame =CGRectMake(0, 95, 320, 30);
    self.lineImageView.frame =CGRectMake(0, self.label.frame.origin.y + self.label.frame.size.height, 320, 1);
   self.myTextView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, 320,  IPHONE5?390:350);
    

 
}
#pragma  mark PULL_DOWNTableVIewDelegate
-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr tag:(int)tag{
    [self.resultTypeBtn setTitle:titleStr forState:UIControlStateNormal];
    self.JieGuoIDstr = jieguoID;
    [self.tableView removeFromSuperview];
}
-(void)BtnAction{

    if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    
    
    if ( self.JieGuoIDstr.length == 0) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择级别～" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
 
    }
    
        NSMutableArray *params=[NSMutableArray array];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"fenLei", nil]];
        ServiceArgs *args=[[ServiceArgs alloc] init] ;
        args.methodName=@"GetJiChuShuJuByFenLei";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        [manager setFinishBlock:^{
            
            NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
            XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
            XmlNode *node=[_helper soapXmlSelectSingleNode:@"//GetJiChuShuJuByFenLeiResult"];
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];

            self.jiChuArray = [[NSMutableArray alloc]init];
            NSString *returnStr = [resultDic objectForKey:@"return"];
            if ([returnStr isEqualToString:@"true"]) {
                NSArray *array = [resultDic objectForKey:@"JiChuShuJu"];
                for (NSDictionary *dic in array) {
                    Pull_downClass *class = [[Pull_downClass alloc]init];
                    class.idStr = [dic objectForKey:@"ID"];
                    class.MingCheng = [dic objectForKey:@"MingCheng"];
                    [self.jiChuArray addObject:class];
                }
                
                self.tableView = [[Pull_downTable alloc]initWithFrame:CGRectMake(20, self.resultTypeBtn.frame.origin.y + self.resultTypeBtn.frame.size.height, 280, self.jiChuArray.count*30)];
                self.tableView.fondSize = 14.0f;
                self.tableView.tableArray = self.jiChuArray; //成功请求完成之后赋值
                self.tableView.myDelegate = self;
                [self.view addSubview:self.tableView];
            }
        }];
        [manager setFailedBlock:^{
        }];
        [manager startAsynchronous];
}
#pragma mark 提交事件
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
    
    
    if (self.fujianArray.count >0) {
        //队列请求
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
            NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",JieGuoXinXi:\"%@\",JieGuoID:\"%@\",FuJian:%@ }",self.xiangmuId,self.fankuiId,[UserInfo shareInstance].userId,self.myTextView.text,self.JieGuoIDstr,fujianStr];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chuLiJieGuoXinXi", nil]];
            
            
            ServiceArgs *args=[[ServiceArgs alloc] init];
            args.methodName=@"ChuLiJieGuoXinXiTianJia";//要调用的webservice方法
            args.soapParams=params;//传递方法参数
            
            ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
            [manager setFinishBlock:^{
                [bg removeFromSuperview];
                bg=nil;
                NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
                XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
                XmlNode *node=[_helper soapXmlSelectSingleNode:@"//ChuLiJieGuoXinXiTianJiaResponse"];
                
                NSDictionary *resultJsonDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
                if (resultJsonDic&&[resultJsonDic.allKeys containsObject:@"return"]&&[[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
                    
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    
                }else{
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:[resultJsonDic objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    
                }
                [self.navigationController popViewControllerAnimated:YES];
                
                
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
        NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",JieGuoXinXi:\"%@\",JieGuoID:\"%@\",FuJian:%@ }",self.xiangmuId,self.fankuiId,[UserInfo shareInstance].userId,self.myTextView.text,self.JieGuoIDstr,fujianStr];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chuLiJieGuoXinXi", nil]];
        
        
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.methodName=@"ChuLiJieGuoXinXiTianJia";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        
        
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        [manager setSuccessBlock:^() {
            if (manager.error) {
                return;
            }
            [bg removeFromSuperview];
            NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
            XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
            XmlNode *node=[_helper soapXmlSelectSingleNode:@"//ChuLiJieGuoXinXiTianJiaResponse"];
            
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
