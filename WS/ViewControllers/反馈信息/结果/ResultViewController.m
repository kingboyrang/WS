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
-(void)SubmitAction{
    
    for (FujianClass *fujianClass in self.fujianArray) {
        NSString *datastr = fujianClass.fujianData;
        NSString *name = fujianClass.fujianName;
        [self sendMessage:datastr fileName:name completed:^{  }];
    }
    
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
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[manager.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];  //xml开始解析
        NSDictionary *resultJsonDic = [Global GetjsonStr:self.jsonData];
        if ([[resultJsonDic objectForKey:@"return"]isEqualToString:@"true"]) {
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加不成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
        self.myTextView.text = @"";
        [self.imageScrollView removeFromSuperview];
        [self.fujianArray removeAllObjects];
        
    }];
    [manager startSynchronous];//开始同步

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navView.titel_Label.text = @"结果";
    self.bgImageView.hidden = NO;
    self.toolbar.hidden = NO;
 
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(280, 35, 26, 20);
   [imageBtn setImage:[UIImage imageNamed:@"Camera"] forState:0];

    [imageBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:imageBtn];
    
    self.jiChuArray = [[NSMutableArray alloc]init];
    
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 30)];
    headview.backgroundColor = [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];

    [self.view addSubview:headview];
    
   self.resultTypeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 70, 280, 20)];
    [self.resultTypeBtn setBackgroundImage:[UIImage imageNamed:@"searchSeleBtn"] forState:0];
    self.resultTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.resultTypeBtn];
    [self.resultTypeBtn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
//
    
    self.tableView = [[Pull_downTable alloc]initWithFrame:CGRectMake(20, self.resultTypeBtn.frame.origin.y + self.resultTypeBtn.frame.size.height, 280, 60)];
    self.tableView.fondSize = 14.0f;
    self.tableView.myDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    
    self.label.hidden = NO;
    self.myTextView.hidden = NO;
    self.lineImageView.hidden = NO;
    self.label.frame =CGRectMake(0, 95, 320, 30);
    self.lineImageView.frame =CGRectMake(0, self.label.frame.origin.y + self.label.frame.size.height, 320, 1);
   self.myTextView.frame = CGRectMake(0, self.lineImageView.frame.origin.y+self.lineImageView.frame.size.height, 320, 380);
 
}
#pragma  mark PULL_DOWNTableVIewDelegate
-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr{
    [self.resultTypeBtn setTitle:titleStr forState:0];
    self.JieGuoIDstr = jieguoID;
    self.tableView.hidden = YES;
}
-(void)BtnAction{
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"4",@"fenLei", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init] ;
    args.methodName=@"GetJiChuShuJuByFenLei";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setFinishBlock:^{
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[manager.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];  //xml开始解析
        NSError *err;
        NSData *jsonData = [self.jichuDataStr dataUsingEncoding:NSUTF8StringEncoding];      //json解析 转成 data
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
        NSString *returnStr = [jsonDic objectForKey:@"return"];
        if ([returnStr isEqualToString:@"true"]) {
            NSArray *array = [jsonDic objectForKey:@"JiChuShuJu"];
            for (NSDictionary *dic in array) {
                Pull_downClass *class = [[Pull_downClass alloc]init];
                class.idStr = [dic objectForKey:@"ID"];
                class.MingCheng = [dic objectForKey:@"MingCheng"];
                [self.jiChuArray addObject:class];
            }
            self.tableView.tableArray = self.jiChuArray; //成功请求完成之后赋值
            [self.tableView reloadData];
            self.tableView.hidden = NO;
        }
    }];
    [manager setFailedBlock:^{
    }];
    [manager startAsynchronous];
   
}

#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //        NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetJiChuShuJuByFenLeiResult"]) {
        self.jichuDataStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.jichuDataStr appendString:string];
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
