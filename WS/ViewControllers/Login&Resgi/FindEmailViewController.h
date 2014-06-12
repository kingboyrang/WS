//
//  FindEmailViewController.h
//  WS
//
//  Created by liuqin on 14-5-16.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "Global.h"
#import "ProView.h"
@interface FindEmailViewController : BaseViewController<UITextFieldDelegate>

@property (strong, nonatomic)NSMutableString *jsonStr;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextF;
@property (weak, nonatomic) IBOutlet UITextField *emailTextF;
- (IBAction)btnActon:(id)sender;


@end
