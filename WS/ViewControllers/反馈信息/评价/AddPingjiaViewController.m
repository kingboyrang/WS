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
    self.navView.titel_Label.text = @"评价";
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(280, 35, 26, 20);
  [imageBtn setImage:[UIImage imageNamed:@"Camera"] forState:0];

    [imageBtn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:imageBtn];
}
-(void)SubmitAction{
    
}

@end
