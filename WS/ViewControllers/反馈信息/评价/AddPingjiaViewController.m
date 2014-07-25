//
//  AddPingjiaViewController.m
//  WS
//
//  Created by liuqin on 14-5-22.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "AddPingjiaViewController.h"

@interface AddPingjiaViewController ()

@end

@implementation AddPingjiaViewController

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
    self.toolbar.hidden = NO;
    
    if (self.laugeEN) {
        self.navView.titel_Label.text = @"Evauation";
    }else{
        self.navView.titel_Label.text = @"评价";
    }
    
    
    self.bgImageView.hidden = NO;
    self.toolbar.hidden = NO;
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 30)];
    headview.backgroundColor = [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];
    
    [self.view addSubview:headview];
    
    self.resultTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 70, 280, 20)];
    [self.resultTypeBtn setBackgroundImage:[UIImage imageNamed:@"searchSeleBtn"] forState:0];
    self.resultTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.resultTypeBtn];
    [self.resultTypeBtn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
    //
    
    self.tableView = [[Pull_downTable alloc]initWithFrame:CGRectMake(20, self.resultTypeBtn.frame.origin.y + self.resultTypeBtn.frame.size.height, 280, 120)];
    self.tableView.fondSize = 14.0f;
    self.tableView.myDelegate = self;
    self.jiChuArray = [[NSMutableArray alloc]init];
    NSArray *tableArr = @[@"优",@"良",@"中",@"差"];
    for (int i = 1; i<=4; i++) {
        Pull_downClass *class = [[Pull_downClass alloc]init];
        class.idStr = [NSString stringWithFormat:@"%d",i];
        class.MingCheng = [tableArr objectAtIndex:i-1];
        [self.jiChuArray addObject:class];
    }
    self.tableView.tableArray = self.jiChuArray; //成功请求完成之后赋值
    [self.tableView reloadData];
    
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    
    self.label.hidden = NO;
    self.myTextView.hidden = NO;
    self.lineImageView.hidden = NO;
    self.label.frame =CGRectMake(0, 95, 320, 30);
    self.lineImageView.frame =CGRectMake(0, self.label.frame.origin.y + self.label.frame.size.height, 320, 1);
    self.myTextView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, 320, IPHONE5?390:350);

}
-(void)BtnAction{
    self.tableView.hidden = NO;
}
-(void)SubmitAction{
    if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    if (self.JieGuoIDstr.length == 0) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"请选择评价结果" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    
    NSMutableArray *params=[NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",PingJiaXinXi:\"%@\",PingJiaJiBie:\"%@\"}",self.xiangmuId,self.fankuiId,[UserInfo shareInstance].userId,self.myTextView.text,self.JieGuoIDstr];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"keHuPingJiaXinXi", nil]];
    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"KeHuPingJia";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
            return;
        }
        
        NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
        XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
        XmlNode *node=[_helper soapXmlSelectSingleNode:@"//KeHuPingJiaResult"];
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];

        if ([[resultDic objectForKey:@"return"]isEqualToString:@"true"]) {
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加不成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [manager startSynchronous];//开始同步
}
#pragma  mark PULL_DOWNTableVIewDelegate
-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr tag:(int)tag{
    [self.resultTypeBtn setTitle:titleStr forState:0];
    self.JieGuoIDstr = jieguoID;
    self.tableView.hidden = YES;
}

@end
