//
//  FeedbackViewController.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"反馈信息";
    }
    return self;
}

#pragma mark向服务发送消息
-(void)SengMessage{
    NSString *seleStr =[NSString stringWithFormat: @"where type = 1 and proid = %@",[UserInfo shareInstance].project_current_Id];
    int ZiJiFanKuiID = [Global TableName:INFOTABLE where:seleStr isFault:YES zuidaZhuanfa:NO];
    NSString *OtherseleStr =[NSString stringWithFormat: @"where type = 2 and proid = %@",[UserInfo shareInstance].project_current_Id ];
    int JieShouFanKuiID  = [Global TableName:INFOTABLE where:OtherseleStr isFault:YES zuidaZhuanfa:NO];
    NSString *jianyiStr = [NSString stringWithFormat:@"where proid = %@ and type = 3",[UserInfo shareInstance].project_current_Id];
    int JianYiID = [Global TableName:INFOTABLE where:jianyiStr isFault:NO zuidaZhuanfa:NO];
    NSString *yijianStr = [NSString stringWithFormat:@"where proid = %@ and type = 4",[UserInfo shareInstance].project_current_Id];
    int YiJianID = [Global TableName:INFOTABLE where:yijianStr isFault:NO zuidaZhuanfa:NO];
    NSString *JieGuoStr = [NSString stringWithFormat:@"where proid = %@ and type = 5",[UserInfo shareInstance].project_current_Id];
    int JieGuoID = [Global TableName:INFOTABLE where:JieGuoStr isFault:NO zuidaZhuanfa:NO];
    NSString *JieGuoQueRenStr = [NSString stringWithFormat:@"where proid = %@ and type = 6",[UserInfo shareInstance].project_current_Id];
    int JieGuoQueRenID = [Global TableName:INFOTABLE where:JieGuoQueRenStr isFault:NO zuidaZhuanfa:NO];
    NSString *PingJiaIDStr = [NSString stringWithFormat:@"where proid = %@ and type = 7",[UserInfo shareInstance].project_current_Id];
    int PingJiaID = [Global TableName:INFOTABLE where:PingJiaIDStr isFault:NO zuidaZhuanfa:NO];
    
    NSString *zhuanfaId = [NSString stringWithFormat:@"where proid = %@ ",[UserInfo shareInstance].project_current_Id];
    int zuidazhuanfaId = [Global TableName:INFOTABLE where:zhuanfaId isFault:NO zuidaZhuanfa:YES];

    
    
    
    
    
    

        NSString *str =[NSString stringWithFormat:@"{RenYuanID:\"%@\",XiangMuID:\"%@\",ZiJiFanKuiID:\"%d\",JieShouFanKuiID:\"%d\",JieShouJianYiID:\"%d\",JieShouYiJianID:\"%d\",JieShouJieGuoID:\"%d\",JieShouJieGuoQueRenID:\"%d\",JieShouPingJiaID:\"%d\",GuZhangBianHao:\"\",XiaoXiShuXing:\"\",DangQianZhuangTai:\"\",KaiShiShiJian:\"\",JieShuShiJian:\"\",PaiXu:\"\",DuQuShuLiang: \"%@\",JieShouZhuanFaID:\"%d\"}",[UserInfo shareInstance].userId,[UserInfo shareInstance].project_current_Id,ZiJiFanKuiID,JieShouFanKuiID,JianYiID,YiJianID,JieGuoID,JieGuoQueRenID,PingJiaID,@"15",zuidazhuanfaId] ;
        NSMutableArray *params=[NSMutableArray array];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"xuanZeXiangMu", nil]];
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.methodName=@"XuanZeXiangMu";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        //    NSLog(@"soap=%@",args.bodyMessage);
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        __block ServiceRequestManager *this = manager;
        [manager setSuccessBlock:^() {
            if (this.error) {
                
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                    
                  
                return;
            }
            //请求成功
//                NSLog(@"获取主页面信息成功，请求结果为=\n%@",this.responseString);
                NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[this.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                [xml setDelegate:self];
                [xml parse];  //xml开始解析
                
                NSDictionary *resultmyJsonDic = [Global GetjsonStr:self.resultJsonStr];
            NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                if ([[resultmyJsonDic objectForKey:@"return"]isEqualToString:@"true"]) {
                    resultArray = [Global resultArray:resultmyJsonDic :1:nil:nil where:@""];
                }else{
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:[resultmyJsonDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                }
               
                if (resultArray.count >= 1)
                {

                    for (MessageClass *messClass in resultArray) {  //有数据 且正确的情况
                        
                        [contentsArray addObject:messClass.XinXi_contants];
                        [self.messageArr addObject:messClass];
                        
                    }
                    [self.mytableView reloadData];
                }
                else{
                    NSLog(@"没有信息");
                }

            
            
        }];
        [manager startSynchronous];//开始同步
        
    
    
}
-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr{
//    NSLog(@"jieguoID,titleStr = %@,%@",jieguoID,titleStr);
    [UserInfo shareInstance].project_current_Id = jieguoID;
    [UserInfo shareInstance].project_current_name = titleStr;
    
    [[NSUserDefaults standardUserDefaults]setObject:jieguoID forKey:PROID];
    [[NSUserDefaults standardUserDefaults]setObject:titleStr forKey:PRONAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
    self.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
    cellHighArray = [[NSMutableArray alloc]init];
    self.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
    contentsArray = [[NSMutableArray alloc]init];
    for (MessageClass *messClass in self.messageArr) {  //有数据 且正确的情况
        [contentsArray addObject:messClass.XinXi_contants];
    }
    [self.mytableView reloadData];

    [self SengMessage];
    self.tableView.hidden = YES;
}
-(void)showSeleProTable{
    self.tableView.hidden = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.\
   
    cellRowint = 10;
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        self.navView.titel_Label.textAlignment = NSTextAlignmentLeft;
        self.navView.titel_Label.text = @"Feedback information";
    }else{
        self.navView.titel_Label.text = @"反馈信息";
    }
    NSMutableArray *proArray = [[FMDBClass shareInstance]seleDate:PROJECTTABLE wherestr:@""];
    NSMutableArray *pull_dowmArray = [[NSMutableArray alloc]init];
    for (ProjectClass *proClass in proArray) {
        Pull_downClass *pullClass = [[Pull_downClass alloc]init];
        pullClass.idStr = proClass.pro_id;
        pullClass.MingCheng = proClass.pro_jiancheng;
        [pull_dowmArray addObject:pullClass];
    }
    
    self.tableView = [[Pull_downTable alloc]initWithFrame:CGRectMake(200, 55, 120, pull_dowmArray.count*30)];
    self.tableView.tableArray = pull_dowmArray;
    self.tableView.fondSize = 13.0f;
    self.tableView.myDelegate = self;
    [self.view addSubview:self.tableView];  //切换项目
    self.tableView.hidden = YES;
    
    UIButton *changeProBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 35, 80, 14)];
    
    if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
        
        [changeProBtn setImage:[UIImage imageNamed:@"Switching projsct-1"] forState:UIControlStateNormal];
        [changeProBtn setImage:[UIImage imageNamed:@"Switching projsct"] forState:UIControlStateHighlighted];
    }else{
        [changeProBtn setImage:[UIImage imageNamed:@"changeProNor"] forState:UIControlStateNormal];
        [changeProBtn setImage:[UIImage imageNamed:@"changeProSel"] forState:UIControlStateHighlighted];
    }
    
    
    [changeProBtn addTarget:self action:@selector(showSeleProTable) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:changeProBtn];
    cellHighArray = [[NSMutableArray alloc]init];
    
   
    contentsArray = [[NSMutableArray alloc]init];
    for (MessageClass *messClass in self.messageArr) {  //有数据 且正确的情况
        [contentsArray addObject:messClass.XinXi_contants];
    }
    [self.mytableView reloadData];

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,100, 30)];
    [btn setTitle:@"切换项目" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
   UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    _headerView = [[MJRefreshHeaderView alloc]init];
    _headerView.delegate = self;
    _headerView.scrollView = self.mytableView;
    
    _footerVier = [[MJRefreshFooterView alloc]init];
    _footerVier.delegate = self;
    _footerVier.scrollView = self.mytableView;

     [self SengMessage];  //网络请求
}
#pragma mark 刷新数据
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    
    if (refreshView == _headerView) {
        [self SengMessage];
//        if (pageNumber==1) {
//            self.list=arr;
//            [_refreshTable reloadData];
//        }else{
//            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:arr.count];
//            int total=self.list.count;
//            for (int i=0; i<[arr count]; i++) {
//                [self.list addObject:[arr objectAtIndex:i]];
//                NSIndexPath *newPath=[NSIndexPath indexPathForRow:i+total inSection:0];
//                [insertIndexPaths addObject:newPath];
//            }
//            //重新呼叫UITableView的方法, 來生成行.
//            [_refreshTable beginUpdates];
//            [_refreshTable insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//            [_refreshTable endUpdates];
//            [self showSuccessViewWithHide:^(AnimateErrorView *successView) {
//                successView.labelTitle.text=[NSString stringWithFormat:@"更新%d筆資料!",insertIndexPaths.count];
//            } completed:nil];
//        }
    }else if (refreshView == _footerVier){
        cellRowint = cellRowint + 10;
        if (cellRowint < contentsArray.count) {
//            NSMutableArray *inserIndexPaths = [[NSMutableArray alloc]initWithCapacity:10];
//            int total =  contentsArray.count;
//            for (int i = 0; i< 10; i++) {
//                
//            }
//            
//            [self.mytableView beginUpdates];
//            [self.mytableView insertRowsAtIndexPaths: withRowAnimation:UITableViewRowAnimationBottom];
//            [self.mytableView endUpdates];
            [cellHighArray removeAllObjects];
            [self.mytableView reloadData];
        }else{
            cellRowint = contentsArray.count;
            [cellHighArray removeAllObjects];
              [self.mytableView reloadData];
        }
//         NSLog(@"%d,count = %d",cellRowint,contentsArray.count);
    }
    [self performSelector:@selector(endFefrshing) withObject:nil afterDelay:0];
}
-(void)endFefrshing{
    [self.mytableView reloadData];
    [_headerView endRefreshing];
    [_footerVier endRefreshing];
}

- (float)getHeightForCell:(NSString *)string
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(290,2000);
    CGSize labelsize = [string sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize.height;
}
#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    [cellHighArray addObject:[NSNumber numberWithFloat:160+ [self getHeightForCell:contentsArray[indexPath.row]]]];
    return cellH+ [self getHeightForCell:contentsArray[indexPath.row]];
   
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (self.messageArr.count >=10) {
        return cellRowint;
    }else{
        return self.messageArr.count;
    }
}
-(int)cellBottomBtn:(int)heigh{
    return heigh;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
      FaultCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell != nil) {
        for (UIView *view in [cell subviews]) {
            [view removeFromSuperview];
        }
    }
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"FaultCellTableViewCell" owner:nil options:nil];
    cell = [arr objectAtIndex:0];
    
    
    MessageClass *messClass = [[MessageClass alloc]init];
    messClass = [self.messageArr objectAtIndex:indexPath.row];
    cell.messLabel.text = messClass.XinXi_contants;
    cell.BiaoHao.text =messClass.XinXi_BiaoHao;
    cell.FaBuShijian.text = messClass.XinXi_FaBuShiJian;
    cell.ZhuanYe.text = [NSString stringWithFormat:@"%@--%@",messClass.XinXi_ZhuanYe,messClass.XinXi_WenTiJiBie];
    cell.Deal_state.text =[Global dealState:messClass.XinXi_deal_state] ;
    cell.FaQiRen.text = messClass.XinXi_FaQiRen;

    cell.XinXi_proid = messClass.XinXi_proid;
    cell.XinXi_type = messClass.XinXi_type;
    
    cell.XinXi_ID =  messClass.XinXi_ID;
    cell.XinXi_faultid = messClass.XinXi_faultid;
    cell.Xinxi_zhuanfaId = messClass.XinXi_JieShouZhuanFaID;
    if ([messClass.XinXi_read_state isEqualToString:@"1"]) {
        [cell.read_stateImg setImage:[UIImage imageNamed:@"weidu"]];
    }else{
        [cell.read_stateImg setImage:[UIImage imageNamed:@"yidu"]];
    }
    
    int y = [[cellHighArray objectAtIndex:indexPath.row] intValue]-30;
    
    UIButton *btn1,*btn2,*btn3,*btn4,*btn5,*btn6;
    
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(80, y+22, 75, 21)];
        btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, y+22, 75, 21)];
        btn3 = [[UIButton alloc]initWithFrame:CGRectMake(240, y, 75, 21)];
        btn4 = [[UIButton alloc]initWithFrame:CGRectMake(160, y, 75, 21)];
        btn5 = [[UIButton alloc]initWithFrame:CGRectMake(80, y, 75, 21)];
        btn6 = [[UIButton alloc]initWithFrame:CGRectMake(10, y,75, 21)];
    }else{
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(260, y, 48, 21)];
        btn2 = [[UIButton alloc]initWithFrame:CGRectMake(210, y, 48, 21)];
        btn3 = [[UIButton alloc]initWithFrame:CGRectMake(160, y, 48, 21)];
        btn4 = [[UIButton alloc]initWithFrame:CGRectMake(110, y, 48, 21)];
        btn5 = [[UIButton alloc]initWithFrame:CGRectMake(60, y, 48, 21)];
        btn6 = [[UIButton alloc]initWithFrame:CGRectMake(10, y, 48, 21)];
        
    }

    NSMutableArray *btnarray = [[NSMutableArray alloc]initWithObjects:btn1,btn2,btn3,btn4,btn5,btn6, nil];
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    int i = 0;
    if ([messClass.XinXi_forwarding isEqualToString:@"True"]) {
        i++;
         NSString *str;
        if (cellH == 160) {
           str = @"zhuanfa";
        }else{
           str = @"Forward";
        }
       
        [imageDic setObject:str forKey:@"100"];
    }
    if ([messClass.XinXi_pingjia isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (cellH == 160) {
            str = @"pingjia";
        }else{
            str = @"Evaluation";
        }
        [imageDic setObject:str forKey:@"200"];
    }
    if ([messClass.XinXi_result_submit isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (cellH == 160) {
            str = @"queding";
        }else{
            str = @"Confirmation";
        }
        [imageDic setObject:str forKey:@"300"];
    }
    if ([messClass.XinXi_result isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (cellH == 160) {
            str = @"queding";
        }else{
            str = @"Result";
        }
        [imageDic setObject:str forKey:@"400"];
    }
    if ([messClass.XinXi_yijian isEqualToString:@"True"]) {
        i++;
        
        NSString *str;
        if (cellH == 160) {
            str = @"yijian";
        }else{
            str = @"Opinion";
        }
        [imageDic setObject:str forKey:@"500"];
        
    }
    if ([messClass.XinXi_jianyi isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (cellH == 160) {
            str = @"jianyi";
        }else{
            str = @"Suqqestions";
        }
        
        [imageDic setObject:str forKey:@"600"];
        
    }

    
    NSArray *keys = [[imageDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (int j = 0; j < i; j++) {
        UIButton *btn = [btnarray objectAtIndex:j];
         btn.tag = [[keys objectAtIndex:j] intValue];
        [btn setImage:[UIImage imageNamed: [imageDic objectForKey:[keys objectAtIndex:j]]] forState:UIControlStateNormal];
        btn.tag = [[keys objectAtIndex:j] intValue]; //btn.tag
        [btn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
    }
     return cell;
}
#pragma mark tableViewDateSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    
    FaultCellTableViewCell *cell = (FaultCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    
    [[FMDBClass shareInstance]UpData:INFOTABLE setStr:@"read_state = 2" whereStr:[NSString stringWithFormat:@"id = %@ and type = %@",cell.XinXi_ID,cell.XinXi_type]];
    

    
    if ([cell.XinXi_type isEqualToString:@"1"] ||[cell.XinXi_type isEqualToString:@"2"]) {
        
        DetailedViewController *detaiVC = [[DetailedViewController alloc]initWithNibName:@"DetailedViewController" bundle:nil];
        detaiVC.xinxi_type = cell.XinXi_type;
        detaiVC.xinxi_id = cell.XinXi_ID;
        detaiVC.xinxi_currentFaultId = cell.XinXi_faultid;
        detaiVC.zhuanFaID = cell.Xinxi_zhuanfaId;
        [self.navigationController pushViewController:detaiVC animated:YES];
        
    }else{
        FeiFaultViewController *vc = [[FeiFaultViewController alloc]initWithNibName:@"FeiFaultViewController" bundle:nil];
        vc.FieXinXiLeiXing = cell.XinXi_type;
        vc.FieXinXiID = cell.XinXi_ID;
        vc.FieFanKuiID = cell.XinXi_faultid;
        vc.FieRenYuanID = [UserInfo shareInstance].userId;
        vc.typeStr = [Global xiaoxiType:cell.XinXi_type];
        NSString *seleStr = [NSString stringWithFormat:@"where proid = %@ and falutid = %@ and type = %@ ",[UserInfo shareInstance].project_current_Id,vc.FieFanKuiID,vc.FieXinXiLeiXing];
        
        NSMutableArray *dataArray = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:seleStr];
        int bigId = 0;
        for (MessageClass *class in dataArray) {
            bigId = bigId >= [class.XinXi_ID intValue]?bigId:[class.XinXi_ID intValue];
        }
        if ([cell.XinXi_type isEqualToString:@"3"]) {
            vc.ZuiDaJianYiID = [NSString stringWithFormat:@"%d",bigId];
            vc.ZuiDaYiJianID = @"0";
            vc.JieGuoID = @"0";
            vc.JieGuoQueRenID=@"0";
            vc.PingJiaID=@"0";
            
        }else if ([cell.XinXi_type isEqualToString:@"4"]){
            vc.ZuiDaJianYiID = @"0";
            vc.ZuiDaYiJianID = [NSString stringWithFormat:@"%d",bigId];
            vc.JieGuoID = @"0";
            vc.JieGuoQueRenID=@"0";
            vc.PingJiaID=@"0";
        }else if ([cell.XinXi_type isEqualToString:@"5"]){
            vc.ZuiDaJianYiID = @"0";
            vc.ZuiDaYiJianID = @"0";
            vc.JieGuoID = [NSString stringWithFormat:@"%d",bigId];
            vc.JieGuoQueRenID=@"0";
            vc.PingJiaID=@"0";
        }else if ([cell.XinXi_type isEqualToString:@"6"]){
            vc.ZuiDaJianYiID = @"0";
            vc.ZuiDaYiJianID = @"0";
            vc.JieGuoID = @"0";
            vc.JieGuoQueRenID=[NSString stringWithFormat:@"%d",bigId];
            vc.PingJiaID=@"0";
        }else if ([cell.XinXi_type isEqualToString:@""]){
            vc.ZuiDaJianYiID = @"0";
            vc.ZuiDaYiJianID = @"0";
            vc.JieGuoID = @"0";
            vc.JieGuoQueRenID=@"0";
            vc.PingJiaID=[NSString stringWithFormat:@"%d",bigId];
        }

        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)cellBtnAction:(UIButton *)btn{
    
    int tag = btn.tag;
    id v=[btn superview];
   do{
        v=[v superview];
   }while(![v isKindOfClass:[FaultCellTableViewCell class]]);
      FaultCellTableViewCell *cell =(FaultCellTableViewCell *) v;
     if (tag == 100) { //转发
        ForwardingViewController *vc = [[ForwardingViewController alloc]initWithNibName:@"ForwardingViewController" bundle:nil];
        vc.projectid = cell.XinXi_proid;
        vc.zhuangfarenid = [UserInfo shareInstance].userId;
        vc.messageid = cell.XinXi_ID;
        vc.messageType = cell.XinXi_type;
        vc.faultid = cell.XinXi_faultid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag == 200){ //评价
         AddPingjiaViewController *vc = [[AddPingjiaViewController alloc]init];
         vc.xinxiType = cell.XinXi_type;
        vc.fankuiId =cell.XinXi_faultid;
        vc.xiangmuId = cell.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 300){ //确认
        if ( [self CanAdd:300 fankuiID:cell.XinXi_faultid]) {
            
            AddSubmitViewController  *vc = [[AddSubmitViewController alloc]init];
            vc.xinxiType = cell.XinXi_type;
            vc.fankuiId =cell.XinXi_faultid;
            vc.xiangmuId = cell.XinXi_proid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目已经添加结果确认"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
            
        }

    }

   else if(tag == 400){ //结果
       
       if ( [self CanAdd:400 fankuiID:cell.XinXi_faultid]) {
           ResultViewController *vc = [[ResultViewController alloc]init];
           vc.xinxiType = cell.XinXi_type;
           vc.fankuiId =cell.XinXi_faultid;
           vc.xiangmuId = cell.XinXi_proid;
           [self.navigationController pushViewController:vc animated:YES];
       }else{
           UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目已经添加结果"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
           [alterView show];
       }
       
       

    }else if(tag == 500){ //意见
        AddviceViewController *vc = [[AddviceViewController alloc]init];
        vc.xinxiType = cell.XinXi_type;
        vc.fankuiId =cell.XinXi_faultid;
        vc.xiangmuId = cell.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (tag == 600){ //建议
        SuggectionViewController *vc = [[SuggectionViewController alloc]init];
        vc.xinxiType = cell.XinXi_type;
        vc.fankuiId =cell.XinXi_faultid;
        vc.xiangmuId = cell.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(BOOL)CanAdd:(int)i fankuiID:(NSString *) fankuiid{
    
    __block BOOL isCan = NO;
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:fankuiid,@"fanKuiID", nil]];
    
    ServiceArgs *args=[[ServiceArgs alloc] init] ;
    if (i == 400) {
        args.methodName=@"ShiFouYiTianJiaJieGuo";//要调用的webservice方法
    }else{
        args.methodName=@"ShiFouYiTianJiaJieGuoQueRen";//要调用的webservice方法
    }
   
    args.soapParams=params;//传递方法参数
    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
//            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            return;
        }
//        NSLog(@"同步请求成功，请求结果为=%@",manager.responseString);
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[manager.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        
        [xml setDelegate:self];
        [xml parse];  //xml开始解析
        
        if (i == 400) {
            
            if ([[[Global GetjsonStr:ShiFouYiTianJiaJieGuoResultStr] objectForKey:@"return"] isEqualToString:@"true"]) {
                
                if ([[resultJsonDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"True"]) {
                    isCan = NO;
                    
                }else if ([[resultJsonDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"false"]){
                    isCan = YES;
                }
            }

        }else{
            if ([[[Global GetjsonStr:ShiFouYiTianJiaJieGuoQueRenResultStr] objectForKey:@"return"] isEqualToString:@"true"]) {
                
                if ([[resultJsonDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"True"]) {
                    isCan = NO;
                    
                }else if ([[resultJsonDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"false"]){
                    isCan = YES;
                }
            }

            
        }
//            if ([[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
//                
//                if ([[resultJsonDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"True"]) {
//                    isCan = NO;
//                    
//                }else if ([[resultJsonDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"false"]){
//                    isCan = YES;
//                }
//            }
 
     
      
    }];
    [manager startSynchronous];//开始同步
    return  isCan;
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
    if ([elementName isEqualToString:@"XuanZeXiangMuResult"]) {
        self.resultJsonStr = [[NSMutableString alloc]init];
    }else if ([elementName isEqualToString:@"ShiFouYiTianJiaJieGuoResult"]){
        ShiFouYiTianJiaJieGuoResultStr = [[NSMutableString alloc]init];
    }else if ([elementName isEqualToString:@"ShiFouYiTianJiaJieGuoQueRenResult"]){
        ShiFouYiTianJiaJieGuoQueRenResultStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.resultJsonStr appendString:string];
    [ShiFouYiTianJiaJieGuoResultStr appendString:string];
    [ShiFouYiTianJiaJieGuoQueRenResultStr appendString:string];
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
#pragma mark 返回
-(void)back
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]  animated:YES];
}
- (IBAction)GotoSerachVC:(id)sender {
    
    NSString *xibStr ;
    if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
        xibStr = @"SearchViewController_en";
    }else{
        xibStr = @"SearchViewController";
    }
    
    SearchViewController *vc = [[SearchViewController alloc]initWithNibName:xibStr bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        cellH = 180;
    }else{
        cellH = 160;
    }
    
     self.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
    [self.mytableView reloadData];
}
@end
