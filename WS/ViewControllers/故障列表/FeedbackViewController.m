//
//  FeedbackViewController.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FeedbackViewController.h"

#import "FMDBClass.h"

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

-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr tag:(int)tag{
    [UserInfo shareInstance].project_current_Id = jieguoID;
    [UserInfo shareInstance].project_current_name = titleStr;
    
    [[NSUserDefaults standardUserDefaults]setObject:jieguoID forKey:PROID];
    [[NSUserDefaults standardUserDefaults]setObject:titleStr forKey:PRONAME];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    cellHighArray = [[NSMutableArray alloc]init];
    self.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
    contentsArray = [[NSMutableArray alloc]init];

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
    }else if (refreshView == _footerVier){
        cellRowint = cellRowint + 10;
        if (cellRowint < contentsArray.count) {
            [cellHighArray removeAllObjects];
            [self.mytableView reloadData];
        }else{
            cellRowint = contentsArray.count;
            [cellHighArray removeAllObjects];
              [self.mytableView reloadData];
        }
    }
    [self performSelector:@selector(endFefrshing) withObject:nil afterDelay:0];
}
-(void)endFefrshing{
    [self.mytableView reloadData];
    [_headerView endRefreshing];
    [_footerVier endRefreshing];
}
- (float)getHeightForCell:(NSString *)string{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(290,2000);
    CGSize labelsize = [string sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return labelsize.height;
}
#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    for (MessageClass * meclass in self.messageArr) {
        [contentsArray addObject:meclass.XinXi_contants];
      }
     [cellHighArray addObject:[NSNumber numberWithFloat:160+ [self getHeightForCell:contentsArray[indexPath.row]]]];
    return 160+ [self getHeightForCell:contentsArray[indexPath.row]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
//    if (self.messageArr.count >=10) {
//        return cellRowint;
//    }else{
        return self.messageArr.count;
//    }
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
    cell.TypeLabel.text = [NSString stringWithFormat:@"%@--%@", [Global xiaoxiType:messClass.XinXi_type] ,messClass.XinXi_proName];
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
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(240, y, 75, 21)];
        btn2 = [[UIButton alloc]initWithFrame:CGRectMake(160, y, 75, 21)];
        btn3 = [[UIButton alloc]initWithFrame:CGRectMake(80, y, 75, 21)];
        btn4 = [[UIButton alloc]initWithFrame:CGRectMake(10, y, 75, 21)];
        btn5 = [[UIButton alloc]initWithFrame:CGRectMake(10, y + 20, 75, 21)];
        btn6 = [[UIButton alloc]initWithFrame:CGRectMake(80, y+20, 75, 21)];
    }else{
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(260, y, 48, 21)];
        btn2 = [[UIButton alloc]initWithFrame:CGRectMake(210, y, 48, 21)];
        btn3 = [[UIButton alloc]initWithFrame:CGRectMake(160, y, 48, 21)];
        btn4 = [[UIButton alloc]initWithFrame:CGRectMake(110, y, 48, 21)];
        btn5 = [[UIButton alloc]initWithFrame:CGRectMake(10, y, 48, 21)];
        btn6 = [[UIButton alloc]initWithFrame:CGRectMake(80, y, 48, 21)];
   }
 
    NSMutableArray *btnarray = [[NSMutableArray alloc]initWithObjects:btn1,btn2,btn3,btn4,btn5,btn6, nil];
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    int i = 0;
    if ([messClass.XinXi_forwarding isEqualToString:@"True"]) {
        i++;
         NSString *str;
        if (!cellEN) {
           str = @"zhuanfa";
        }else{
           str = @"Forward";
        }
       
        [imageDic setObject:str forKey:@"100"];
    }
    if ([messClass.XinXi_pingjia isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (!cellEN) {
            str = @"pingjia";
        }else{
            str = @"Evaluation";
        }
        [imageDic setObject:str forKey:@"200"];
    }
    if ([messClass.XinXi_result_submit isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (!cellEN) {
            str = @"queding";
        }else{
            str = @"Confirmation";
        }
        [imageDic setObject:str forKey:@"300"];
    }
    if ([messClass.XinXi_result isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (!cellEN) {
            str = @"jieguo";
        }else{
            str = @"Result";
        }
        [imageDic setObject:str forKey:@"400"];
    }
    if ([messClass.XinXi_yijian isEqualToString:@"True"]) {
        i++;
        
        NSString *str;
        if (!cellEN) {
            str = @"yijian";
        }else{
            str = @"Opinion";
        }
        [imageDic setObject:str forKey:@"500"];
        
    }
    if ([messClass.XinXi_jianyi isEqualToString:@"True"]) {
        i++;
        NSString *str;
        if (!cellEN) {
            str = @"jianyi";
        }else{
            str = @"Suqqestions";
        }
        
        [imageDic setObject:str forKey:@"600"];
        
    }
    NSArray *keys = [[imageDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (int j = 0; j < i; j++) {
        UIButton *btn = [btnarray objectAtIndex:j];
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
        DetailedViewController *detaiVC = [[DetailedViewController alloc]initWithNibName:IPHONE5?@"DetailedViewController":@"DetailedViewController_3.5" bundle:nil];
        detaiVC.xinxi_type = cell.XinXi_type;
        detaiVC.xinxi_id = cell.XinXi_ID;
        detaiVC.xinxi_currentFaultId = cell.XinXi_faultid;
        detaiVC.zhuanFaID = cell.Xinxi_zhuanfaId;
        [self.navigationController pushViewController:detaiVC animated:YES];
        
    }else{
        FeiFaultViewController *vc = [[FeiFaultViewController alloc]initWithNibName:IPHONE5?@"FeiFaultViewController":@"FeiFaultViewController_3.5" bundle:nil];
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
    cellHighArray = [[NSMutableArray alloc]init];
    self.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
    contentsArray = [[NSMutableArray alloc]init];
    [self.mytableView reloadData];
}
-(void)cellBtnAction:(UIButton *)btn{
    
    int tag = btn.tag;
    id v=[btn superview];
   do{
        v=[v superview];
   }while(![v isKindOfClass:[FaultCellTableViewCell class]]);
      FaultCellTableViewCell *cell =(FaultCellTableViewCell *) v;
    if (tag == 100) { //转发
        if (cellEN ) {
            ForwardingViewController *vc = [[ForwardingViewController alloc]initWithNibName:IPHONE5?@"ForwardingViewController_en":@"ForwardingViewController_3.5en" bundle:nil];
            vc.laugeEN = cellEN;
            vc.projectid = cell.XinXi_proid;
            vc.zhuangfarenid = [UserInfo shareInstance].userId;
            vc.messageid = cell.XinXi_ID;
            vc.messageType = cell.XinXi_type;
            vc.faultid = cell.XinXi_faultid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            ForwardingViewController *vc = [[ForwardingViewController alloc]initWithNibName:IPHONE5?@"ForwardingViewController":@"ForwardingViewController_3.5" bundle:nil];
            vc.laugeEN = cellEN;
            vc.projectid = cell.XinXi_proid;
            vc.zhuangfarenid = [UserInfo shareInstance].userId;
            vc.messageid = cell.XinXi_ID;
            vc.messageType = cell.XinXi_type;
            vc.faultid = cell.XinXi_faultid;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    else if (tag == 200){ //评价
        AddPingjiaViewController *vc = [[AddPingjiaViewController alloc]init];
        vc.laugeEN = cellEN;
        vc.xinxiType = cell.XinXi_type;
        vc.fankuiId =cell.XinXi_faultid;
        vc.xiangmuId = cell.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 300){ //确认
        if ( [self CanAdd:300 fankuiID:cell.XinXi_faultid]) {
            AddSubmitViewController  *vc = [[AddSubmitViewController alloc]init];
            vc.laugeEN = cellEN;
            vc.xinxiType = cell.XinXi_type;
            vc.fankuiId =cell.XinXi_faultid;
            vc.xiangmuId = cell.XinXi_proid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目已经添加结果确认"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
    }
    else if (tag == 400){ //结果
        
        if ( [self CanAdd:400 fankuiID:cell.XinXi_faultid]) {
            ResultViewController *vc = [[ResultViewController alloc]init];
            vc.laugeEN = cellEN;
            vc.xinxiType = cell.XinXi_type;
            vc.fankuiId =cell.XinXi_faultid;
            vc.xiangmuId = cell.XinXi_proid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目已经添加结果"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
    }
    else if (tag == 500){ //意见
        AddviceViewController *vc = [[AddviceViewController alloc]init];
        vc.laugeEN = cellEN;
        vc.xinxiType = cell.XinXi_type;
        vc.fankuiId =cell.XinXi_faultid;
        vc.xiangmuId = cell.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (tag == 600){ //建议
        SuggectionViewController *vc = [[SuggectionViewController alloc]init];
        vc.laugeEN = cellEN;
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
            UIAlertView *alterview = [[UIAlertView alloc]initWithTitle:nil message:@"连接服务器失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterview show];
            return;
        }
        
        NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
           XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
        
        XmlNode *node;
        
        if (i == 400) {
            node=[_helper soapXmlSelectSingleNode:@"//ShiFouYiTianJiaJieGuoResult"];
        }else{
            node=[_helper soapXmlSelectSingleNode:@"//ShiFouYiTianJiaJieGuoQueRenResult"];
        }
          NSDictionary *resultDic = [Global GetjsonStr:node.InnerText];
             if ([[resultDic objectForKey:@"return"] isEqualToString:@"true"]) {
                if ([[resultDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"True"]) {
                    isCan = NO;
                }else if([[resultDic objectForKey:@"ShiFouYiTianJia"] isEqualToString:@"False"]) {
                    isCan = YES;
                }
            }

     
    }];
    [manager startSynchronous];//开始同步
    return  isCan;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        cellEN = YES;
    }else{
        cellEN = NO;
    }
    
//     self.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
    [self.mytableView reloadData];
}
#pragma mark向服务发送消息得到列表内容
-(void)SengMessage{
    if (self.isSend) {
        return;
    }
    if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    
    NSString *seleStr =[NSString stringWithFormat: @"where type = 1 and proid = %@",[UserInfo shareInstance].project_current_Id ];
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
    
    NSString *str  =[NSString stringWithFormat:@"{RenYuanID:\"%@\",XiangMuID:\"%@\",ZiJiFanKuiID:\"%d\",JieShouFanKuiID:\"%d\",JieShouJianYiID:\"%d\",JieShouYiJianID:\"%d\",JieShouJieGuoID:\"%d\",JieShouJieGuoQueRenID:\"%d\",JieShouPingJiaID:\"%d\",GuZhangBianHao:\"\",XiaoXiShuXing:\"\",DangQianZhuangTai:\"\",KaiShiShiJian:\"\",JieShuShiJian:\"\",PaiXu:\"\",DuQuShuLiang: \"%@\",JieShouZhuanFaID:\"%d\"}",[UserInfo shareInstance].userId,[UserInfo shareInstance].project_current_Id,ZiJiFanKuiID,JieShouFanKuiID,JianYiID,YiJianID,JieGuoID,JieGuoQueRenID,PingJiaID,@"15",zuidazhuanfaId] ;
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"xuanZeXiangMu", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"XuanZeXiangMu";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    __block ServiceRequestManager *this = manager;
    [manager setSuccessBlock:^() {
        if (this.error) {
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
            return;
        }
         NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
        XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
        XmlNode *node=[_helper soapXmlSelectSingleNode:@"//XuanZeXiangMuResult"];
        NSDictionary *resultDic = [Global GetjsonStr:node.InnerText];
        
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if ([[resultDic objectForKey:@"return"]isEqualToString:@"true"]) {
            resultArray = [Global resultArray:resultDic :1:nil:nil where:@""];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:[resultDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
        if (resultArray.count >= 1)
        {
            for (MessageClass *messClass in resultArray) {  //有数据 且正确的情况
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
@end
