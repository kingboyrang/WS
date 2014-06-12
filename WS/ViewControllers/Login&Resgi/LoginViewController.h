//
//  LoginViewController.h
//  WS
//
//  Created by gwzd on 14-4-1.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"

#import "RegistrationViewController.h" //注册页面
#import "FindEmailViewController.h"    //找回密码
#import "SeleViewController.h"
#import "ProView.h"

#import "ServiceRequestManager.h" //soap请求
#import "FMDBClass.h"            //数据库单例
#import "PersonInfoClass.h"      //个人信息model
#import "ProjectClass.h"         //项目model

#import "Header.h"              //头文件
#import "Global.h"
#import "UserInfo.h"
@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
//登陆成功处理
- (void)loginSuccessViewController:(LoginViewController *)loginViewController withResponse:(id)response;
//登陆失败处理
- (void)loginFailViewController:(LoginViewController *)loginViewController withError:(NSError *)error;
@end

@interface LoginViewController : BaseViewController<UIActionSheetDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,NSXMLParserDelegate,ProViewDelegate>
{
    BOOL SUCCESS; //登录是否成功
}


@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextF;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (nonatomic, strong) NSMutableString *jsonStr;    //JsonStr
@property (nonatomic, strong) NSMutableArray *projectArray;  //项目组

@property (nonatomic, strong)id<LoginViewControllerDelegate>delegate;
- (IBAction)ButtonAction:(id)sender;

@end
