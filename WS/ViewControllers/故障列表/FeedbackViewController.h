//
//  FeedbackViewController.h
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "FMDBClass.h"
#import "ServiceRequestManager.h" //soap请求
#import "FaultCellTableViewCell.h"
#import "MJRefresh.h"
#import "Global.h"
#import "UserInfo.h"
#import "MessageClass.h"

#import "ForwardingViewController.h" 
#import "SuggectionViewController.h"
#import "AddviceViewController.h"
#import "ResultViewController.h"
#import "AddPingjiaViewController.h"
#import "AddSubmitViewController.h"

#import "SearchViewController.h"
#import "FeiFaultViewController.h"
#import "DetailedViewController.h"

#import "ProjectClass.h"
#import "Pull_downTable.h"
#import "Pull_downClass.h"
@interface FeedbackViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,NSXMLParserDelegate,Pull_downTableDelegate>
{
   
    int cellH; //cell 高度
    
    NSMutableArray *contentsArray;
    MJRefreshHeaderView *_headerView;
    MJRefreshFooterView *_footerVier;
    int cellRowint;
    NSMutableArray *cellHighArray;
    NSMutableString *ShiFouYiTianJiaJieGuoResultStr;
    NSMutableString *ShiFouYiTianJiaJieGuoQueRenResultStr;
    NSDictionary *resultJsonDic;
}

@property (strong, nonatomic)Pull_downTable *tableView;
@property (nonatomic, strong) NSMutableArray *messageArr;
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (nonatomic, strong)NSString *userID;
@property (nonatomic ,strong)NSString *projectID;
@property (nonatomic ,strong)NSString *maxfankui;
@property (nonatomic ,strong)NSString *maxjianyi;
@property (nonatomic ,strong)NSString *maxyijian;
@property (nonatomic ,strong)NSString *maxjieguo;
@property (nonatomic ,strong)NSString *maxjieguoqueren;
@property (nonatomic ,strong)NSString *maxpingjian;
@property (nonatomic ,strong)NSMutableString *resultJsonStr;
- (IBAction)GotoSerachVC:(id)sender;


@end
