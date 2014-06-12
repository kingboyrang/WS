//
//  SearchViewController.h
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "downTableView.h"
#import "UserInfo.h"







@interface SearchViewController : BaseViewController<TableViewDelegte,UITextFieldDelegate>

{
    int xianxiInt;
    int stateInt;
    int paixuTiaojianInt;
    
}

@property int seleBtnTag;

@property (weak, nonatomic) IBOutlet UIButton *xianxiproBtn;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@property (weak, nonatomic) IBOutlet UIButton *paixuTiaojianBtn;

@property (weak, nonatomic) IBOutlet UITextField *TextField;


@property (strong, nonatomic)downTableView *tableView;

- (IBAction)BtnAction:(id)sender;

- (IBAction)searchAction:(id)sender;

@end
