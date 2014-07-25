//
//  ForwardingViewController.h
//  WS
//
//  Created by liuqin on 14-5-4.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "ForwardTableViewCell.h"
#import "PerSonClass.h"
#import "FMDBClass.h"
#import "ServiceRequestManager.h"
#import "Global.h"

@interface ForwardingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ForwardTableViewCellDelegate,NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *personArray;
@property (nonatomic, strong) NSMutableString *jsonStr;    //JsonStr
@property (nonatomic, strong) NSMutableDictionary *selectedPersons;    //选中人员信息

@property (nonatomic, strong)NSMutableString *personStr;
@property BOOL laugeEN;

@property (nonatomic, strong)NSString *messageType; //信息类型
@property (nonatomic, strong)NSString *messageid;   //信息id
@property (nonatomic, strong)NSString *faultid;  // 反馈id
@property (nonatomic, strong)NSString *zhuangfarenid; //转发人id
@property (nonatomic, strong)NSString *jieshourenid;  //接收人id
@property (nonatomic, strong)NSString *projectid;  //项目id
- (IBAction)ButtonAction:(id)sender;


@end


