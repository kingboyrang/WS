//
//  SearchViewController.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "SearchViewController.h"
#import "Header.h"
#import "FeedbackViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        self.navView.titel_Label.text = @"Search";
    }else{
        
        self.navView.titel_Label.text = @"搜索";

    }
    
    self.tableView = [[downTableView alloc]init];
    self.tableView.myTableDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)BtnAction:(id)sender {
    self.tableView.hidden = NO;
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    if (tag == 1) {
        self.seleBtnTag = 1;
        self.tableView.tableArray = [[NSMutableArray alloc]initWithObjects:@"自己反馈",@"接受反馈",@"建议",@"意见",@"结果",@"确认",@"评价", nil];
        self.tableView.frame = CGRectMake(self.xianxiproBtn.frame.origin.x, self.xianxiproBtn.frame.origin.y + self.xianxiproBtn.frame.size.height, self.xianxiproBtn.frame.size.width, self.tableView.tableArray.count*30);
        [self.tableView reloadData];
    }else if (tag == 2){
        self.seleBtnTag = 2;
        self.tableView.tableArray = [[NSMutableArray alloc]initWithObjects:@"处理中",@"已处理", nil];
        self.tableView.frame = CGRectMake(self.stateBtn.frame.origin.x, self.stateBtn.frame.origin.y + self.stateBtn.frame.size.height, self.stateBtn.frame.size.width, self.tableView.tableArray.count*30);
        [self.tableView reloadData];
    }else if (tag == 3){
        self.seleBtnTag = 3;
        self.tableView.tableArray = [[NSMutableArray alloc]initWithObjects:@"按反馈时间倒序",@"按时间正序",@"按编号倒序",@"按编号正序",@"按状态倒序",@"按状态正序", nil];
        self.tableView.frame = CGRectMake(self.paixuTiaojianBtn.frame.origin.x,self.paixuTiaojianBtn.frame.origin.y + self.paixuTiaojianBtn.frame.size.height , self.paixuTiaojianBtn.frame.size.width,self.tableView.tableArray.count*30);
        [self.tableView reloadData];
    }
    
}
-(void)hideTableView:(int)row{
    
    self.tableView.hidden = YES;
    if (self.seleBtnTag == 1) {
        [self.xianxiproBtn setTitle:[self.tableView.tableArray objectAtIndex:row] forState:0];
        xianxiInt = row;
    }else if (self.seleBtnTag == 2){
        [self.stateBtn setTitle:[self.tableView.tableArray objectAtIndex:row] forState:0];
        stateInt = row;
    }else if (self.seleBtnTag == 3){
         [self.paixuTiaojianBtn setTitle:[self.tableView.tableArray objectAtIndex:row] forState:0];
        paixuTiaojianInt = row;
    }
}
- (IBAction)searchAction:(id)sender{
    
    NSLog(@"self.xianxiproBtn.tag,self.stateBtn.tag,self.paixuTiaojianBtn.tag---->%d,%d,%d,",self.xianxiproBtn.tag,self.stateBtn.tag,self.paixuTiaojianBtn.tag);
    NSString *tableName;
    NSString *XiaoXiShuXing;
    if (xianxiInt == 0) {
        tableName = INFOTABLE;
        XiaoXiShuXing = @"1"; //自己反馈
    }else if (xianxiInt == 1){
        tableName = INFOTABLE;
        XiaoXiShuXing = @"2"; //推送反馈
    }else if (xianxiInt == 2){
        tableName = INFOTABLE;
        XiaoXiShuXing = @"3"; //推送反馈
    }else if (xianxiInt == 3){
        tableName = INFOTABLE;
        XiaoXiShuXing = @"4"; //推送反馈
    }else if (xianxiInt == 4){
        tableName = INFOTABLE;
        XiaoXiShuXing = @"5"; //推送反馈
    }else if (xianxiInt == 5){
        tableName = INFOTABLE;
        XiaoXiShuXing = @"6"; //推送反馈
    }else if (xianxiInt == 6){
        tableName = INFOTABLE;
        XiaoXiShuXing = @"7"; //推送反馈
    }
    NSString *dealstr;
    if (stateInt == 0) {
        dealstr = @"1";
    }else if (stateInt == 1){
        dealstr = @"2";
    }
    NSString *paixuTiaojianStr;
    
    if (paixuTiaojianInt == 0) {
        paixuTiaojianStr = @"order by fabu_time desc"; //倒
    }else if (paixuTiaojianInt ==1){
        paixuTiaojianStr = @"order by fabu_time asc";//正
    }else if (paixuTiaojianInt ==2){
        paixuTiaojianStr = @"order by bianhao desc";
    }else if (paixuTiaojianInt ==3){
        paixuTiaojianStr = @"order by bianhao asc";
    }else if (paixuTiaojianInt ==4){
        paixuTiaojianStr = @"order by deal_state desc";
    }else if (paixuTiaojianInt ==5){
        paixuTiaojianStr = @"order by deal_state desc";
    }
    
    
    
    FeedbackViewController *feedVC = [[FeedbackViewController alloc]initWithNibName:IPHONE5? @"FeedbackViewController":@"FeedbackViewController_3.5" bundle:nil];
    feedVC.isSend = YES;

     NSString *sqlStr = [NSString stringWithFormat:@"where proid = %@ and bianhao like '%%%@%%' and type = %@ and deal_state = %@ %@ ",[UserInfo shareInstance].project_current_Id,self.TextField.text,XiaoXiShuXing,dealstr,paixuTiaojianStr];
  
    feedVC.messageArr = [[FMDBClass shareInstance]seleDate:tableName wherestr:sqlStr];
    [self.navigationController pushViewController:feedVC animated:YES];
    
}
@end
