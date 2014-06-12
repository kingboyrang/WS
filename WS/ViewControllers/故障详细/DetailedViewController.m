//
//  DetailedViewController.m
//  WS
//
//  Created by liuqin on 14-5-12.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "DetailedViewController.h"
#import "NSString+TPCategory.h"
#import "CanKanListView.h"

@interface DetailedViewController ()

{
    NSString *messageTye;
}

@end

@implementation DetailedViewController
@synthesize xinxi_type;
@synthesize xinxi_id;
@synthesize xinxi_currentFaultId;
@synthesize myMessageClass;
@synthesize biaohao_lab,time_lab,fault_lab,state_lab;


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
    // Do any additional setup after loading the view from its nib.
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        self.navView.titel_Label.text = @"Feedback information";
    }else{
        
        self.navView.titel_Label.text = @"详细信息";
    }
    ////////////判断 数据库有没有此反馈消息
    NSMutableArray *array = [[FMDBClass shareInstance]seleDate:DETALEDTABLE wherestr:[NSString stringWithFormat:@"where faultid = %@ and proid = %@ and type = %@",self.xinxi_currentFaultId,[UserInfo shareInstance].project_current_Id,self.xinxi_type]];
    if (array.count < 1) {
          [self sendMessage];
    }else{
        self.myMessageClass = [array objectAtIndex:0];
        [self addMessageForView];
    }

}
-(void)sendMessage{
//    NSLog(@"开始异步请求!");
    NSMutableArray *params=[NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"{XinXiLeiXing: \"%@\", XinXiID: \"%@\", FanKuiID: \"%@\",RenYuanID:\"%@\",ZhuanFaXinXiID:\"%@\"}",self.xinxi_type,self.xinxi_id,self.xinxi_currentFaultId,[UserInfo shareInstance].userId,self.zhuanFaID];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chaKanXinXiXiangQing", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"ChaKanFanKuiWenTiXiangQing";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setFinishBlock:^() {
        NSLog(@"异步请求成功，请求结果为=%@",manager.responseString);
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[manager.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];  //xml开始解析
        NSDictionary *resultJsonDic = [Global GetjsonStr:self.resultJsonStr];
         [Global resultArray:resultJsonDic :4 :@"" :nil where:@""];//写数据
        if ([[resultJsonDic objectForKey:@"return"]isEqualToString:@"true"]) {
            NSArray *falutArray = [resultJsonDic objectForKey:@"FanKuiXinXi"];
            NSDictionary *dic = [falutArray objectAtIndex:0];
            NSString *faultid = [dic objectForKey:@"FanKuiXinXiID"];
            NSString *proid = [dic objectForKey:@"XiangMuID"];
            NSString *faulttype = [dic objectForKey:@"FanKuiXinXiLeiXing"];
            messageTye = [dic objectForKey:@"XinXiLeiXing"];
            self.myMessageClass = [[[FMDBClass shareInstance]seleDate:DETALEDTABLE wherestr:[NSString stringWithFormat:@"where faultid = %@ and proid = %@ and fankuiXinxiType = %@",faultid,proid,faulttype]]objectAtIndex:0];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"" message:[Global tishiMessage:[resultJsonDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
        

        [self addMessageForView];
    }];
    [manager setFailedBlock:^() {
//        NSLog(@"异步请求失败，失败原因=%@",manager.error.description);
    }];
    [manager startAsynchronous];//开始异步

}
-(void)addMessageForView{
    self.biaohao_lab.text = [NSString stringWithFormat:@"[%@]",self.myMessageClass.XinXi_BiaoHao];
    self.time_lab.text = self.myMessageClass.XinXi_FaBuShiJian;
 
    self.fault_lab.text = [NSString stringWithFormat:@"%@--%@,反馈--%@",self.myMessageClass.XinXi_ZhuanYe,[Global isFault:self.myMessageClass.XinXi_faultType],self.myMessageClass.XinXi_proName];

    self.state_lab.text = [NSString stringWithFormat:@"状态:%@  发起人:%@[%@]",[Global dealState:self.myMessageClass.XinXi_deal_state],self.myMessageClass.XinXi_FaQiRen,self.myMessageClass.XinXi_faqi_role];
    UILabel *contantlabe = [[UILabel alloc]initWithFrame:CGRectZero];
    contantlabe.backgroundColor = [UIColor clearColor];
    contantlabe.textColor = [UIColor whiteColor];
    contantlabe.numberOfLines = 0;
    contantlabe.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(300, 1000);
    CGSize contantSize = [self.myMessageClass.XinXi_contants sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    contantlabe.frame = CGRectMake(10, 0, 300, contantSize.height);
    contantlabe.text = self.myMessageClass.XinXi_contants;
    [contantlabe sizeToFit];
    [self.faultScrollView addSubview:contantlabe];
    
    NSString *whereStr = [NSString stringWithFormat:@"where proid = %@ and faultid = %@ and faultType = %@ and messType = %@ and orgid = %@",self.myMessageClass.XinXi_proid,self.myMessageClass.XinXi_faultid,self.myMessageClass.XinXi_faultType,self.myMessageClass.XinXi_type,self.myMessageClass.XinXi_ID];
    
    NSArray *fujianarray = [[FMDBClass shareInstance]seleDate:IMAGETABLE wherestr:whereStr];
    NSMutableArray *fjimageArrary = [[NSMutableArray alloc]init];
    NSMutableArray *fjfileArray = [[NSMutableArray alloc]init];
    for (int i = 0;i < fujianarray.count; i++) {
        FujianClass *fjclass = [[FujianClass alloc]init];
        fjclass = [fujianarray objectAtIndex:i];
        if ([fjclass.fujiantype isEqualToString:@"1"]) { //图片
            [fjimageArrary addObject:fjclass];
        }
        else
        {
            [fjfileArray addObject:fjclass];
        }
    }
    float y = contantlabe.frame.origin.y + contantlabe.frame.size.height+5;
    for (int i = 0; i< fjimageArrary.count;i++) {
        FujianClass *fj = [[FujianClass alloc]init];
        fj = [fjimageArrary objectAtIndex:i];
        
        
        FujianBtn *fujianBtn = [[FujianBtn alloc]init];
        fujianBtn.fujianName = fj.fujianName;
        fujianBtn.fujiantype = fj.fujiantype;
        fujianBtn.fjclass  = fj;
        fujianBtn.backgroundColor = [UIColor clearColor];

        
        /*读取入图片*/
        //因为拿到的是个路径，所以把它加载成一个data对象
        NSData *data=[NSData dataWithContentsOfFile:fj.fujianbendiPath];
        //直接把该图片读出来
        if (data.length == 0) {
            fujianBtn.frame = CGRectMake(20, y, 90, 60);
             y += 70;
             [fujianBtn setImage:[UIImage imageNamed:@"test"] forState:0];
        }else{
            UIImage *image = [UIImage imageWithData:data];
            if (image.size.width > 300 || image.size.height > 400) {
                 fujianBtn.frame = CGRectMake(20, y, 250, image.size.height * 250/image.size.width);
            }else{
                fujianBtn.frame = CGRectMake(20, y, image.size.width, image.size.height);
            }
            fujianBtn.btnImage = image;
              y += fujianBtn.frame.size.height +10;
            [fujianBtn setImage:image forState:0];
        }

       
        [fujianBtn addTarget:self action:@selector(clickImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.faultScrollView addSubview:fujianBtn];
    }
    for (int i = 0; i< fjfileArray.count;i++) {
        FujianClass *fj = [[FujianClass alloc]init];
        fj = [fjfileArray objectAtIndex:i];
        CGSize size = [fj.fujianName textSize:[UIFont systemFontOfSize:12.0f] withWidth:self.view.frame.size.width - 20];
        FujianBtn *fujianBtn = [[FujianBtn alloc]initWithFrame:CGRectMake(10, y ,size.width, 25)];
        fujianBtn.fjclass = fj;
        fujianBtn.backgroundColor = [UIColor clearColor];
        [fujianBtn setTitleColor:[UIColor whiteColor] forState:0];
        [fujianBtn setTitle:fj.fujianName forState:0];
        fujianBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        fujianBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        fujianBtn.fujiantype = fj.fujianName;
        fujianBtn.fujiantype = fj.fujiantype;
        fujianBtn.Paths = fj.fujianPaths; //网络地址
        [fujianBtn addTarget:self action:@selector(clickImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.faultScrollView addSubview:fujianBtn];
        y += 30;
        
    }
    
    
    CanKanListView *listView = [[[NSBundle mainBundle]loadNibNamed:@"CanKanListView" owner:nil options:nil]objectAtIndex:0];
    listView.frame = CGRectMake(0, y, 320, 200);
    listView.delegate = self;
    [self.faultScrollView addSubview:listView];
    [self.faultScrollView setContentSize:CGSizeMake(320,listView.frame.size.height+y)];
    [self addCaoZuoBtn];
}
-(void)clickImageBtn:(FujianBtn *)btn{
    NSLog(@"");
    
    if ([btn.fujiantype isEqualToString:@"1"]) {
     
        
        ImageCropper *cropper = [[ImageCropper alloc] initWithImage:btn.btnImage];
        [cropper setDelegate:self];
        
        [self presentViewController:cropper animated:YES completion:nil];
   }
    else
   {
       
          [WTStatusBar setStatusText:@"Downloading data..." animated:YES];
        
         _progress=0.0;
        ServiceRequestManager *manager=[ServiceRequestManager requestWithURL:[NSURL URLWithString:btn.Paths]];
        [manager setProgressBlock:^(long long total, long long size, float rate) {
            _progress=rate;
        [WTStatusBar setProgress:_progress animated:YES];

        }];
        [manager setFinishBlock:^() {
            NSData *fileData = manager.responseData;
            
            
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYYMMddhhmmssSSS"];
            NSString *  locationString=[dateformatter stringFromDate:senddate]; //当前时间
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);

            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",locationString,btn.fjclass.fujianName]];
            [fileData writeToFile: uniquePath    atomically:YES];
            
            [[FMDBClass shareInstance]UpData:IMAGETABLE setStr:[NSString stringWithFormat:@"bendiPath = %@",uniquePath] whereStr:[NSString stringWithFormat:@"where proid = %@ and faultid = %@ and faultType = %@ and id = %@ and type = %@  and orgid = %@",btn.fjclass.fujianproid,btn.fjclass.fujianfaultid,btn.fjclass.fujianFaultType,btn.fjclass.fujianid,btn.fjclass.fujiantype,btn.fjclass.fujianorgid]];
            
            [WTStatusBar setStatusText:@"Done!" timeout:0.5 animated:YES];
            
        }];
        [manager setFailedBlock:^() {
            NSLog(@"下载失败，失败原因=%@",manager.error.description);
        }];
        [manager startAsynchronous];//开始异步

        
       
//        [self performSelector:@selector(setTextStatusProgress2) withObject:nil afterDelay:0.5];
    }
    
}

//圖片等比例顯示
- (CGSize)autoImageSize:(CGSize)imgSize
{
    CGFloat oldWidth = imgSize.width;
    CGFloat oldHeight = imgSize.height;
    CGSize saveSize =imgSize;
    
    CGSize defaultSize = CGSizeMake(300, 300); //預設大小
    CGFloat wPre = oldWidth / defaultSize.width;
    CGFloat hPre = oldHeight / defaultSize.height;
    if (oldWidth > defaultSize.width || oldHeight > defaultSize.height) {
        if (wPre > hPre) {
            saveSize.width = defaultSize.width;
            saveSize.height = oldHeight / wPre;
        }
        else {
            saveSize.width = oldWidth / hPre;
            saveSize.height = defaultSize.height;
        }
    }
    if (saveSize.width>self.view.frame.size.width) {
        saveSize.width=self.view.frame.size.width;
    }
    if (saveSize.height>self.view.frame.size.height) {
        saveSize.height=self.view.frame.size.height;
    }
    return saveSize;
}


- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)image {
	[imageView setImage:image];
	[self dismissViewControllerAnimated:YES completion:nil];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)imageCropperDidCancel:(ImageCropper *)cropper {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

//- (void)setTextStatusProgress2
//{
//    [WTStatusBar setStatusText:@"Downloading data..." animated:YES];
//    _progress = 0;
//    [WTStatusBar setProgressBarColor:[UIColor greenColor]];
//    [self performSelector:@selector(setTextStatusProgress3) withObject:nil afterDelay:0.1];
//}
//
//- (void)setTextStatusProgress3
//{
//    
//    if (_progress < 1.0)
//    {
////        _progress += 0.3;
////        [WTStatusBar setProgress:_progress animated:YES];
//        [self performSelector:@selector(setTextStatusProgress3) withObject:nil afterDelay:0.1];
//    }
//    else
//    {
//        [WTStatusBar setStatusText:@"Done!" timeout:0.5 animated:YES];
//    }
//}

-(void)removeBtn:(UIButton *)btn{
    [btn removeFromSuperview];
}
-(void)addCaoZuoBtn{
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(260, 523, 48, 21)];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(210, 523, 48, 21)];
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(160, 523, 48, 21)];
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(110, 523, 48, 21)];
    UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(60, 523, 48, 21)];
    UIButton *btn6 = [[UIButton alloc]initWithFrame:CGRectMake(10, 523, 48, 21)];
    
    
    NSMutableArray *btnarray = [[NSMutableArray alloc]initWithObjects:btn1,btn2,btn3,btn4,btn5,btn6, nil];
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    int i = 0;
    if ([self.myMessageClass.XinXi_forwarding isEqualToString:@"True"]) {
        i++;
        NSString *str = @"zhuanfa";
        [imageDic setObject:str forKey:@"100"];
    }
    if ([self.myMessageClass.XinXi_pingjia isEqualToString:@"True"]) {
        i++;
        NSString *str = @"pingjia";
        [imageDic setObject:str forKey:@"200"];
    }
    if ([self.myMessageClass.XinXi_result_submit isEqualToString:@"True"]) {
        i++;
        NSString *str = @"queding";
        [imageDic setObject:str forKey:@"300"];
    }
    if ([self.myMessageClass.XinXi_result isEqualToString:@"True"]) {
        i++;
        NSString *str = @"jieguo";
        [imageDic setObject:str forKey:@"400"];
    }
    if ([self.myMessageClass.XinXi_yijian isEqualToString:@"True"]) {
        i++;
        NSString *str = @"yijian";
        [imageDic setObject:str forKey:@"500"];
        
    }
    if ([self.myMessageClass.XinXi_jianyi isEqualToString:@"True"]) {
        i++;
        NSString *str = @"jianyi";
        [imageDic setObject:str forKey:@"600"];
        
    }
    
    
    NSArray *keys = [[imageDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (int j = 0; j < i; j++) {
        UIButton *btn = [btnarray objectAtIndex:j];
        btn.tag = [[keys objectAtIndex:j] intValue];
        [btn setImage:[UIImage imageNamed: [imageDic objectForKey:[keys objectAtIndex:j]]] forState:UIControlStateNormal];
        btn.tag = [[keys objectAtIndex:j] intValue]; //btn.tag
        [btn addTarget:self action:@selector(cellBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}

-(void)cellBtnAction:(UIButton *)btn{
    
    int tag = btn.tag;
    if (tag == 100) { //转发
        ForwardingViewController *vc = [[ForwardingViewController alloc]initWithNibName:@"ForwardingViewController" bundle:nil];
        vc.projectid = self.myMessageClass.XinXi_proid;
        vc.zhuangfarenid = [UserInfo shareInstance].userId;
        vc.messageid = self.myMessageClass.XinXi_ID;
        vc.messageType = self.myMessageClass.XinXi_type;
        vc.faultid = self.myMessageClass.XinXi_faultid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag == 200){ //评价
        AddPingjiaViewController *vc = [[AddPingjiaViewController alloc]init];
        vc.xinxiType = self.myMessageClass.XinXi_type;
        vc.fankuiId =self.myMessageClass.XinXi_faultid;
        vc.xiangmuId = self.myMessageClass.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 300){ //确认
//        if ( [self CanAdd:300 fankuiID:self.myMessageClass.XinXi_faultid]) {
        
            AddSubmitViewController  *vc = [[AddSubmitViewController alloc]init];
            vc.xinxiType = self.myMessageClass.XinXi_type;
            vc.fankuiId =self.myMessageClass.XinXi_faultid;
            vc.xiangmuId = self.myMessageClass.XinXi_proid;
            [self.navigationController pushViewController:vc animated:YES];
//            
//        }else{
//            
//            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目已经添加结果确认"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alterView show];
//            
//        }
        
    }
    
    else if(tag == 400){ //结果
        
//        if ( [self CanAdd:400 fankuiID:cell.XinXi_faultid]) {
            ResultViewController *vc = [[ResultViewController alloc]init];
            vc.xinxiType = self.myMessageClass.XinXi_type;
            vc.fankuiId =self.myMessageClass.XinXi_faultid;
            vc.xiangmuId = self.myMessageClass.XinXi_proid;
            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该项目已经添加结果"delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alterView show];
//        }
        
        
        
    }else if(tag == 500){ //意见
        AddviceViewController *vc = [[AddviceViewController alloc]init];
        vc.xinxiType = self.myMessageClass.XinXi_type;
        vc.fankuiId =self.myMessageClass.XinXi_faultid;
        vc.xiangmuId = self.myMessageClass.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (tag == 600){ //建议
        SuggectionViewController *vc = [[SuggectionViewController alloc]init];
        vc.xinxiType = self.myMessageClass.XinXi_type;
        vc.fankuiId =self.myMessageClass.XinXi_faultid;
        vc.xiangmuId = self.myMessageClass.XinXi_proid;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    if ([elementName isEqualToString:@"ChaKanFanKuiWenTiXiangQingResult"]) {
        self.resultJsonStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.resultJsonStr appendString:string];
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


-(void)GotoVC:(int)i{
    NSString *titStr;
    NSString *type;
    if (i == 100) {
        titStr = @"查看建议";
        type = @"3";
    }else if (i == 111){
        titStr = @"查看意见";
        type = @"4";
    }else if (i == 222){
        titStr = @"查看结果";
        type = @"5";
    }else if (i == 333){
        titStr = @"查看确认";
        type = @"6";
    }else if (i == 444){
        titStr = @"查看评价";
        type = @"7";
    }
    FindViewController *findVC = [[FindViewController alloc]initWithNibName:@"FindViewController" bundle:nil];
    findVC.selfTilteStr = titStr;
    NSLog(@"findVC.selfTilteStr = %@",findVC.selfTilteStr);
    findVC.dataType = type;
    findVC.czClass = [[CaoZuoClass alloc]init];
    findVC.czClass.fautlid = self.myMessageClass.XinXi_faultid;
    findVC.czClass.bianhao = self.myMessageClass.XinXi_BiaoHao;
    findVC.czClass.biaoti = self.myMessageClass.XinXi_Biaoti;
    findVC.czClass.zhuanye = self.myMessageClass.XinXi_ZhuanYe;
    findVC.czClass.wentijiBie = self.myMessageClass.XinXi_WenTiJiBie;
    findVC.czClass.read_state = self.myMessageClass.XinXi_read_state;
    findVC.czClass.deal_state = self.myMessageClass.XinXi_deal_state;
    findVC.czClass.fabutime = self.myMessageClass.XinXi_FaBuShiJian;
    findVC.czClass.faqiperson = self.myMessageClass.XinXi_FaQiRen;
    findVC.czClass.faqirole = self.myMessageClass.XinXi_faqi_role;
    findVC.czClass.huifuperson = self.myMessageClass.XinXi_huifu_person;
    findVC.czClass.huifurole = self.myMessageClass.XinXi_huifu_role;
    findVC.czClass.faultContent = self.myMessageClass.XinXi_contants;
    findVC.myfaultID = self.xinxi_currentFaultId;
    findVC.czClass.xinxiType = self.myMessageClass.XinXi_type;
    findVC.czClass.proId = self.myMessageClass.XinXi_proid;
    findVC.czClass.faultType = self.myMessageClass.XinXi_faultType;
    findVC.czClass.xinxiID = self.myMessageClass.XinXi_ID;
    [self.navigationController pushViewController:findVC animated:YES];
}
@end
