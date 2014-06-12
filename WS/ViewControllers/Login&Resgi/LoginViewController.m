//
//  LoginViewController.m
//  WS
//
//  Created by gwzd on 14-4-1.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "LoginViewController.h"

#import "ServiceRequestManager.h"
#import "ServiceOperation.h"
#import "JSONKit.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.title = @"登录";
    [self initView];
    SUCCESS = NO;
     self.projectArray = [[NSMutableArray alloc]init];

}
#pragma mark 加载视图
- (void)initView{
    self.userNameTextF.borderStyle = UITextBorderStyleBezel;
    self.passWordTextF.borderStyle = UITextBorderStyleBezel;
    self.userNameTextF.returnKeyType = UIReturnKeyDone;
    self.passWordTextF.returnKeyType = UIReturnKeyDone;
    self.userNameTextF.delegate = self;
    self.passWordTextF.delegate = self;
    [self.view addSubview:self.userNameTextF];
    [self.view addSubview:self.passWordTextF];
     [self.regisBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}
#pragma mark ButtonAction
- (IBAction)ButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    if (tag == 111)  //注册
    {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
        backItem.title = @"返回";
        
        NSString *xibStr;
        if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
            xibStr = @"RegistrationViewController_en";
        }else{
            xibStr = @"RegistrationViewController";
        }
        
        self.navigationItem.backBarButtonItem = backItem;
        RegistrationViewController *regVC = [[RegistrationViewController alloc]initWithNibName:xibStr bundle:nil];
        [self.navigationController pushViewController:regVC animated:YES];
    }
    else if (tag == 222) //登录
    {
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
//        backItem.title = @"";
//        self.navigationItem.backBarButtonItem = backItem;
        [self SengMessage];

        
    
    }
    else if (tag == 3333) //忘记密码
    {
        NSString *xibStr;
        if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
            xibStr = @"FindEmailViewController_en";
        }else{
            xibStr = @"FindEmailViewController";
        }
        
        FindEmailViewController *vc = [[FindEmailViewController alloc]initWithNibName:xibStr bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark向服务发送登录消息
-(void)SengMessage{
    NSString *str =[NSString stringWithFormat: @"{YongHuMing:\"%@\",MiMa:\"%@\"}",self.userNameTextF.text,self.passWordTextF.text];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"dengLuXinXi", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"YongHuDengLu";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    __block ServiceRequestManager *this = manager;
    [manager setSuccessBlock:^() {
        if (this.error) {
            NSLog(@"同步请求失败，失败原因=%@",this.error.description);
            //请求失败
            
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"LoginFailed", @"登录失败") message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
            
            
            return;
        }
        //请求成功
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[this.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];  //xml开始解析
        NSDictionary *resultJsonDic = [Global GetjsonStr:self.jsonStr];
        if ([[resultJsonDic objectForKey:@"return"]isEqualToString:@"true"]) {
            
            self.projectArray =  [Global resultArray:resultJsonDic :2:nil:nil where:@""];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:[resultJsonDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
        
        if (self.projectArray.count > 1) {
            ProView *proView =[[[NSBundle mainBundle]loadNibNamed:@"ProView" owner:nil options:nil]objectAtIndex:0];
            proView.seleDelegate = self;
            proView.tableArray = self.projectArray;
            int h  = proView.tableArray.count * 70+40;
            int y = (self.view.frame.size.height  - h)/2;
            [ proView makeTableViewCGReframe:0 :y :320 :h ];
            [self.view addSubview:proView];
            
            
        }else if(self.projectArray.count == 1){
            
            
            ProjectClass *proclass = [self.projectArray objectAtIndex:0];

            [[NSUserDefaults standardUserDefaults]setObject:proclass.pro_id forKey:PROID];
            [[NSUserDefaults standardUserDefaults]setObject:proclass.pro_quancheng forKey:PRONAME];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [UserInfo shareInstance].project_current_name = proclass.pro_quancheng;
            [UserInfo shareInstance].project_current_Id = proclass.pro_id;
            if ([self.delegate respondsToSelector:@selector(loginSuccessViewController:withResponse:)])
            {
                [self.delegate loginSuccessViewController:self withResponse:@"登陆成功"];
            }
            
        }
        
        
    }];
    [manager startSynchronous];//开始同步
    
    
}
    

#pragma mark 选择项目信息
-(void)selePro:(ProjectClass *)proclass{
    
    [[NSUserDefaults standardUserDefaults]setObject:proclass.pro_id forKey:PROID];
    [[NSUserDefaults standardUserDefaults]setObject:proclass.pro_quancheng forKey:PRONAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [UserInfo shareInstance].project_current_name = proclass.pro_quancheng;
    [UserInfo shareInstance].project_current_Id = proclass.pro_id;
    if ([self.delegate respondsToSelector:@selector(loginSuccessViewController:withResponse:)])
    {
        [self.delegate loginSuccessViewController:self withResponse:@"登陆成功"];
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
    if ([elementName isEqualToString:@"YongHuDengLuResult"]) {
        self.jsonStr = [[NSMutableString alloc]init];
    }else if ([elementName isEqualToString:@"WangJiMiMaResponse"]){
        self.jsonStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.jsonStr appendString:string];
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



#pragma mark TextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userNameTextF)
    {
        [self.userNameTextF resignFirstResponder];
    }
    else
    {
        [self.passWordTextF resignFirstResponder];
    }
    [self ViewAnimation:0 :0];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.passWordTextF)
    {
        [self ViewAnimation:0 :-35];
    }
    else if (textField == self.userNameTextF)
    {
        [self ViewAnimation:0 :0];
    }
}
-(void)ViewAnimation : (int)x : (int)y{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(x,y,width,height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
