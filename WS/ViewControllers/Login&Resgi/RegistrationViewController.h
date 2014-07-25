//
//  RegistrationViewController.h
//  WSDemo
//
//  Created by gwzd on 14-3-20.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceRequestManager.h" //soap请求
#import "Global.h"

@interface RegistrationViewController : BaseViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,NSXMLParserDelegate>
{
   
    NSMutableString *resultJsonStr;
 
}
@property (weak, nonatomic) IBOutlet UITextField *xingMingTextF;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
@property (weak, nonatomic) IBOutlet UITextField *companyTextF;
- (IBAction)submitAction:(id)sender;




@end
