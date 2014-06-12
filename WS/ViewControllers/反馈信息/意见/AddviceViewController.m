//
//  AddviceViewController.m
//  WS
//
//  Created by liuqin on 14-5-7.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "AddviceViewController.h"

@interface AddviceViewController ()

@end

@implementation AddviceViewController

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
    self.navView.titel_Label.text = @"意见";
    self.bgImageView.hidden = NO;
    self.toolbar.hidden = NO;
    self.myTextView.hidden = NO;
    self.label.hidden = NO;
    self.lineImageView.hidden = NO;
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(280, 35, 26, 20);
  [imageBtn setImage:[UIImage imageNamed:@"Camera"] forState:0];

    [imageBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:imageBtn];
    self.toolbar.hidden = NO;
    self.myTextView.hidden = NO;

    
}
-(void)SubmitAction{
    for (FujianClass *fujianClass in self.fujianArray) {
        NSString *datastr = fujianClass.fujianData;
        NSString *name = fujianClass.fujianName;
        [self sendMessage:datastr fileName:name completed:^{  }];
    }
    
    NSString *fujianStr = [self.sendFujianArray JSONString];
    NSMutableArray *params=[NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",YiJianXinXi:\"%@\",FuJian:%@ }",self.xiangmuId,self.fankuiId,[UserInfo shareInstance].userId,self.myTextView.text,fujianStr];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chuLiYiJianXinXi", nil]];
    
    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"ChuLiYiJianXinXi";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
//            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            return;
        }
//        NSLog(@"同步请求成功，请求结果为=%@",manager.responseString);
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


//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //        NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ChuLiYiJianXinXiResponse"]) {
        self.jsonData = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.jsonData appendString:string];
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
