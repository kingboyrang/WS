//
//  RegistrationViewController.m
//  WSDemo
//
//  Created by gwzd on 14-3-20.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ProView.h"
#define HIGHT [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ?100 : 20

@interface RegistrationViewController ()
{
    ProView *proView;
}
@end

@implementation RegistrationViewController

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
    self.navView.titel_Label.text = @"注册";
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.usernameTextF.delegate = self;
    self.xingMingTextF .delegate = self;
    self.usernameTextF.delegate = self;
    self.passwordTextF .delegate = self;
    self.phoneTextF.delegate = self;
    self.emailTextF .delegate = self;
    self.companyTextF .delegate = self;
    
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
    if ([elementName isEqualToString:@"YongHuZhuCeResult"]) {
        resultJsonStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [resultJsonStr appendString:string];
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

#pragma mark textfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.companyTextF  )
    {
        [self ViewAnimation:0 :-70];
    }
    if (textField == self.emailTextF  )
    {
        [self ViewAnimation:0 :-50];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
     [self ViewAnimation:0 :0];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark隐藏键盘手势
-(void)tapGesture:(UIGestureRecognizer *)gesture{
      [self ViewAnimation:0 :0];
    [self.usernameTextF resignFirstResponder];
    [self.passwordTextF resignFirstResponder];
    [self.phoneTextF resignFirstResponder];
    [self.emailTextF resignFirstResponder];
    [self.companyTextF resignFirstResponder];
}

/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

- (IBAction)submitAction:(id)sender {
       if (![self isValidateEmail:self.emailTextF.text] && [self isValidateMobile:self.phoneTextF.text ]) {
           UIAlertView *alterViw = [[UIAlertView alloc]initWithTitle:@"" message:@"邮箱或手机号格式不对" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
           [alterViw show];
           return;
       }
        if (![self IsEnableConnection]) {
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
            return;
        }
              NSString *str = [NSString stringWithFormat:@"{XingMing:\"%@\",YongHuMing:\"%@\",MiMa:\"%@\",ShouJiHao:\"%@\",YouXiang:\"%@\",GongSiMingCheng:\"%@\",KeHuDuanBiaoShi:\"%@\"}",self.xingMingTextF.text,self.usernameTextF.text,self.passwordTextF.text,self.phoneTextF.text,self.emailTextF.text,self.companyTextF.text,@"1"];
            NSMutableArray *params=[NSMutableArray array];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"zhuCeXinXi", nil]];
            ServiceArgs *args=[[ServiceArgs alloc] init];
            args.methodName=@"YongHuZhuCe";//要调用的webservice方法
            args.soapParams=params;//传递方法参数
            
            ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
            __block ServiceRequestManager *this = manager;
            [manager setSuccessBlock:^() {
                if (this.error) {
                    NSLog(@"同步请求失败，失败原因=%@",this.error.description);
                    //请求失败
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"请求失败" message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                     return;
                }
                //请求成功
                NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[this.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                [xml setDelegate:self];
                [xml parse];  //xml开始解析
                
                NSError *err;
                NSData *jsonData = [resultJsonStr dataUsingEncoding:NSUTF8StringEncoding]; //json解析 转成 data
                NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
                NSString *resultMessage = [jsonDic objectForKey:@"error"];
                if ([resultMessage isEqualToString:@"000"]) {
                    proView = [[[NSBundle mainBundle]loadNibNamed:@"ProView" owner:nil options:nil]objectAtIndex:0];
                    proView.frame = CGRectMake(0, 0, 320, 568);
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320,200)];
                    label.backgroundColor = [UIColor clearColor];
                    label.numberOfLines = 2;
                    label.textAlignment = NSTextAlignmentCenter;
                    NSString *message;
                    if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
                        message =@"感谢您使用售后服务信息交流管理平台为保障您身份的真实性，系统将在72小时内向您注册邮箱发送审核结果，请注意查收，由此给您带来的不便请谅解。";
                    }else{
                        message =@"Thank you for using customer service information manegement platform    To ensure the authenticity of your identity,the system will send the auditresult to the registered mailbox,please note that check,Thank you for understanding";
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
                 }else{
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"" message:[Global tishiMessage:resultMessage] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                }
                
            }];
            [manager startSynchronous];//开始同步
}

-(void)removeView{
    [proView removeFromSuperview];
}
@end
