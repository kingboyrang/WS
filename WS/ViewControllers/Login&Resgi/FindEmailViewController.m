//
//  FindEmailViewController.m
//  WS
//
//  Created by liuqin on 14-5-16.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FindEmailViewController.h"

@interface FindEmailViewController ()
{
    ProView *proView;
}
@end

@implementation FindEmailViewController

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
    
    
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        self.navView.titel_Label.text = @"Forgot Password";
        
    }else{
        self.navView.titel_Label.text = @"找回密码";
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)removeView{
    [proView removeFromSuperview];
}
#pragma mark忘记密码
-(void)ForgetPassWorld{
    
   
               NSString *str =[NSString stringWithFormat: @"{YongHuMing:\"%@\",YouXiang:\"%@\"}",self.userNameTextF.text,self.emailTextF.text];
        NSMutableArray *params=[NSMutableArray array];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"wangJiMiMa", nil]];
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.methodName=@"WangJiMiMa";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        __block ServiceRequestManager *this = manager;
        [manager setSuccessBlock:^() {
            if (this.error) {
//                NSLog(@"同步请求失败，失败原因=%@",this.error.description);
                //请求失败
                      UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"连接服务器失败" message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                 return;
            }
            //请求成功
//            NSLog(@"%@",this.responseString);
                NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[this.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                [xml setDelegate:self];
                [xml parse];  //xml开始解析

                NSError *err;
                NSData *jsonData = [self.jsonStr dataUsingEncoding:NSUTF8StringEncoding];      //json解析 转成 data
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
                NSString *returnStr = [jsonDic objectForKey:@"return"];
                if ([returnStr isEqualToString:@"false"])
                {
                    NSString *errorStr = [jsonDic objectForKey:@"error"];
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:errorStr] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                }else{
                    proView = [[[NSBundle mainBundle]loadNibNamed:@"ProView" owner:nil options:nil]objectAtIndex:0];
                    proView.frame = CGRectMake(0, 0, 320, 568);
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
                    label.backgroundColor = [UIColor clearColor];
                    label.numberOfLines = 2;
                    label.textAlignment = NSTextAlignmentCenter;
                    NSString *message;
                    if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
                         message =@"感谢您使用售后服务信息交流管理平台密码已发送到您邮箱,请查收";
                    }else{
                         message =@"Thank you for using customer service information Password has been sent to your mailbox please check";
                    }
                   
                    label.text = message;
                    label.textColor = [UIColor whiteColor];
                    UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 300,80, 30)];
                    [subBtn setImage:[UIImage imageNamed:@"pwSelBtn"] forState:UIControlStateNormal];
                    [subBtn setImage:[UIImage imageNamed:@"pwNorBtn"] forState:UIControlStateHighlighted];
                    [subBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
                    [proView addSubview:subBtn];
                    [proView addSubview:label];
                    [self.view addSubview:proView];
                }
          }];
        [manager startSynchronous];//开始同步
 }

- (IBAction)btnActon:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        self.userNameTextF.text = @"";
        self.emailTextF.text = @"";
    }else if (button.tag ==1){
        [self ForgetPassWorld];
    }
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
    if ([elementName isEqualToString:@"WangJiMiMaResult"]) {
        self.jsonStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   
    [self.jsonStr appendString:string];
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
   
    
}

//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
   
}
//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
  }


@end
