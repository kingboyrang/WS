//
//  OnlineServiceViewController.h
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceRequestManager.h" //soap请求
#import "Global.h"
#import "OnlineCell.h"
#import "UserInfo.h"
@interface OnlineServiceViewController : BaseViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *MytableView;

@property (nonatomic, strong)NSMutableString *jsonStr;
@property (nonatomic, strong)NSMutableArray *resultArray;
@end
