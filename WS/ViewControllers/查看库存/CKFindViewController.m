//
//  CKFindViewController.m
//  WS
//
//  Created by liuqin on 14-7-17.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CKFindViewController.h"
#import "Pull_downClass.h"

@interface CKFindViewController ()

@end

@implementation CKFindViewController

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
    
   
    
    
    self.navView.titel_Label.text = @"搜  索";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"searBg.png"]];
    [self.view insertSubview:imageView belowSubview:self.navView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, 80, 20)];
    label1.text = @"仓库名称:";
    [self.view addSubview:label1];
    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.frame.size.width + 10, label1.frame.origin.y, 150, label1.frame.size.height)];
    self.btn1.backgroundColor = [UIColor blackColor];
    [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn1.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.btn1.tag = 100;
    [self.view addSubview:self.btn1];
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y + label1.frame.size.height + 10, 250, 1)];
    [image1 setImage:[UIImage imageNamed:@"zhuceLine1.png"]];
    [self.view addSubview:image1];
    
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, image1.frame.origin.y + image1.frame.size.height + 10, 80, 20)];
    label2.text = @"物料种类:";
    [self.view addSubview:label2];
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(label2.frame.origin.x + label2.frame.size.width + 10, label2.frame.origin.y, 150, label2.frame.size.height)];
    self.btn2.backgroundColor = [UIColor blackColor];
    [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    self.btn2.tag = 200;
    [self.view addSubview:self.btn2];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y + label2.frame.size.height + 10, 250, 1)];
    [image2 setImage:[UIImage imageNamed:@"zhuceLine1.png"]];
    [self.view addSubview:image2];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(30, image2.frame.origin.y + image2.frame.size.height + 10, 80, 20)];
    label3.text = @"物料名称:";
    [self.view addSubview:label3];
    self.textfield3 = [[UITextField alloc]initWithFrame:CGRectMake(label3.frame.origin.x + label3.frame.size.width + 10, label3.frame.origin.y, 150, label3.frame.size.height)];
    self.textfield3.backgroundColor = [UIColor blackColor];
    self.textfield3.textColor = [UIColor whiteColor];
    self.textfield3.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:self.textfield3];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(label3.frame.origin.x, label3.frame.origin.y + label3.frame.size.height + 10, 250, 2)];
    [image3 setImage:[UIImage imageNamed:@"line"]];
    [self.view addSubview:image3];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, image3.frame.origin.y +20, 60, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search-1.png"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(gotoNextVCAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn1 addTarget:self action:@selector(getBaseData:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn2 addTarget:self action:@selector(getBaseData:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:searchBtn];
    
    
  
    
    
    
}

-(void)back{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
-(void)getBaseData:(UIButton *)btn{
    
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    
     if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:btn.tag ==100? @"7":@"8",@"fenLei", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init] ;
    args.methodName=@"GetJiChuShuJuByFenLei";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setFinishBlock:^{
        NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
        XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
        XmlNode *node=[_helper soapXmlSelectSingleNode:@"//GetJiChuShuJuByFenLeiResult"];
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
        NSString *returnStr = [resultDic objectForKey:@"return"];
        self.baseDataArray = [[NSMutableArray alloc]init];
        if ([returnStr isEqualToString:@"true"]) {
            NSArray *array = [resultDic objectForKey:@"JiChuShuJu"];
            for (NSDictionary *dic in array) {
                Pull_downClass *class = [[Pull_downClass alloc]init];
                class.idStr = [dic objectForKey:@"ID"];
                class.MingCheng = [dic objectForKey:@"MingCheng"];
                [self.baseDataArray addObject:class];
            }
            
  
                self.tableView = [[Pull_downTable alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y + btn.frame.size.height,150, self.baseDataArray.count*30)];
                
                self.tableView.tag = btn.tag == 100 ?1:2;
                
                self.tableView.fondSize = 14.0f;
                self.tableView.myDelegate = self;
                self.tableView.tableArray = self.baseDataArray; //成功请求完成之后赋值
                [self.view addSubview:self.tableView];
   
        }
    }];
    [manager setFailedBlock:^{
    }];
    [manager startAsynchronous];

    
    
}
#pragma  mark PULL_DOWNTableVIewDelegate
-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr tag:(int)tag{
    if (tag == 1) {
        [self.btn1 setTitle:titleStr forState:UIControlStateNormal];
        self.cangkuid = jieguoID;
    }else if(tag == 2){
        [self.btn2 setTitle:titleStr forState:UIControlStateNormal];
        self.wuliaoid = jieguoID;
        
    }
    
    [self.tableView removeFromSuperview];
}
-(void)gotoNextVCAction{
    
    if (self.cangkuid.length ==0 || self.wuliaoid.length ==0) {
        
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"仓库名字和物料种类不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK ", nil];
        [alterView show];
        return;
    }
    
    
    
    
    CKKCViewController *vc = [[CKKCViewController alloc]init];
    vc.CangKuID = self.cangkuid;
    vc.WuLiaoLeiXingID =  self.wuliaoid;
    vc.WuLiaoMingCheng = self.textfield3.text;
    vc.DuQuShuLiang = @"20";
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
