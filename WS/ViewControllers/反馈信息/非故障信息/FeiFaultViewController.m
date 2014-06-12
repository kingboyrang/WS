//
//  FeiFaultViewController.m
//  WS
//
//  Created by liuqin on 14-5-26.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FeiFaultViewController.h"
#import "Global.h"
#import "NSString+TPCategory.h"
@interface FeiFaultViewController ()
{
    NSString *bianhao;
    NSString *zhuangye;
    NSString *wentijibie;
    NSString *proName;
    NSString *deal_state;
    NSString *faqiPerson;
    NSString *faqiRole;
    NSString *fabuTime;
    NSString *faultgaiyao;
    
    NSString *huifuPerson;
    NSString *huifutime;
    NSString *huifuNeiRong;
    
    
    NSString *projectid;
    NSString *zhuangfarenid;
    NSString *messageid;
    NSString *messageType;
    NSString *faultid;
    NSString *FanKuiXinXiLeiXing;
    
    NSString *fankuiType;
    
}
@end

@implementation FeiFaultViewController

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
    self.fujianArray = [[NSMutableArray alloc]init];
    [self sendMessage];
    
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        self.navView.titel_Label.text = @"Feedback information";
    }else{
        
        self.navView.titel_Label.text = @"详细信息";
    }
    HearView *hv = [[[NSBundle mainBundle]loadNibNamed:@"HearView" owner:nil options:nil]objectAtIndex:0];
    hv.bianhaoLabel.text = bianhao;
    hv.timeLabel.text = fabuTime;
    hv.linetwoLable.text = [NSString stringWithFormat:@"%@ - %@,反馈 - %@",zhuangye,wentijibie,proName];
    NSString *dealStr = [Global dealState:deal_state];
    hv.lineThreeLabel.text = [NSString stringWithFormat:@"状态 - %@ 发起人:%@[%@]",dealStr,faqiPerson,faqiRole];
    hv.delegate = self;
    [self.myScrollView addSubview:hv];
    
    UILabel *contantlabe = [[UILabel alloc]initWithFrame:CGRectZero];
    contantlabe.backgroundColor = [UIColor clearColor];
    contantlabe.textColor = [UIColor whiteColor];
    contantlabe.numberOfLines = 0;
    contantlabe.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize contantSize =[faultgaiyao textSize:contantlabe.font withWidth:300];
    contantlabe.frame = CGRectMake(10,120, 300, contantSize.height);
    contantlabe.text = faultgaiyao;
    [self.myScrollView addSubview:contantlabe];
    
    BottonView *btmView = [[[NSBundle mainBundle]loadNibNamed:@"BottonView" owner:nil options:nil] objectAtIndex:0];
    btmView.delegate = self;
    btmView.frame = CGRectMake(0, contantlabe.frame.origin.y+contantlabe.frame.size.height , 320, 0);
    btmView.typeLabel.text = self.typeStr;
    btmView.huifuPersonLab.text = huifuPerson;
    btmView.timeLabel.text = huifutime;
    btmView.contentLabel.text = huifuNeiRong;
    
      [btmView setImagesWithArray:self.fujianArray];

    [self.myScrollView addSubview:btmView];
    self.myScrollView.contentSize = CGSizeMake(320,1000);
    
    
}
-(void)imageAction:(UIImage *)myimage{
    if (myimage) {
        ImageCropper *cropper = [[ImageCropper alloc] initWithImage:myimage];
        [cropper setDelegate:self];
        
        [self presentModalViewController:cropper animated:YES];
    }else{
        ImageCropper *cropper = [[ImageCropper alloc] initWithImage:[UIImage imageNamed:@"test"]];
        [cropper setDelegate:self];
        
        [self presentModalViewController:cropper animated:YES];
    }
}
#pragma mark 下载事件
-(void)DownLoadAction:(FujianBtn *)fjBtn{
    
    
    
        
        [WTStatusBar setStatusText:@"Downloading data..." animated:YES];
        
        _progress=0.0;
        ServiceRequestManager *manager=[ServiceRequestManager requestWithURL:[NSURL URLWithString:fjBtn.fjclass.fujianPaths]];
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
            
            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",locationString,fjBtn.fjclass.fujianName]];
            [fileData writeToFile: uniquePath    atomically:YES];
            [WTStatusBar setStatusText:@"Done!" timeout:0.5 animated:YES];
            
        }];
        [manager setFailedBlock:^() {
            NSLog(@"下载失败，失败原因=%@",manager.error.description);
            [WTStatusBar setStatusText:@"文件不存在!" timeout:0.5 animated:YES];
            
        }];
        [manager startAsynchronous];//开始异步
        
   
}

- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)image {
	[imageView setImage:image];
	
	[self dismissModalViewControllerAnimated:YES];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)imageCropperDidCancel:(ImageCropper *)cropper {
	[self dismissModalViewControllerAnimated:YES];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark 转发事件
-(void)zhuanfaAction{
    ForwardingViewController *vc = [[ForwardingViewController alloc]initWithNibName:@"ForwardingViewController" bundle:nil];
    vc.projectid = projectid;
    vc.zhuangfarenid = [UserInfo shareInstance].userId;
    vc.messageid = messageid;
    vc.messageType = messageType;
    vc.faultid = faultid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 发送数据
-(void)sendMessage{
    
    
    NSMutableArray *params=[NSMutableArray array];
    NSString *str =[NSString stringWithFormat: @"{XinXiLeiXing: \"%@\",XinXiID: \"%@\",FanKuiID:\"%@\",RenYuanID:\"%@\",ZuiDaJianYiID: \"%@\",ZuiDaYiJianID:\"%@\",JieGuoID:\"%@\",JieGuoQueRenID: \"%@\",PingJiaID:\"%@\"}",self.FieXinXiLeiXing,self.FieXinXiID,self.FieFanKuiID,self.FieRenYuanID,self.ZuiDaJianYiID,self.ZuiDaYiJianID,self.JieGuoID,self.JieGuoQueRenID,self.PingJiaID];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chaKanXinXiXiangQing", nil]];
    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"ChaKanQiTaXiaoXiXiangQing";//要调用的webservice方法
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
        NSDictionary *resultJsonDic = [Global GetjsonStr:self.serverDataStr];
        if ([[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
           
            NSArray *arry = [resultJsonDic objectForKey:@"FanKuiXinXi"];

            for (NSDictionary *dic in arry) { //反馈信息
                bianhao = [dic objectForKey:@"FanKuiXinXiBianHao"];
                zhuangye = [dic objectForKey:@"ZhuanYe"];
                wentijibie = [dic objectForKey:@"WenTiJiBie"];
                fabuTime = [dic objectForKey:@"FaBuShiJian"];
                deal_state = [dic objectForKey:@"ChuLiZhuangTai"];
                faqiPerson = [dic objectForKey:@"FaQiRen"];
                faqiRole = [dic objectForKey:@"FaQiRenJueSe"];
                faultgaiyao = [dic objectForKey:@"FanKuiNeiRongSuoLue"];
                proName = [dic objectForKey:@"XiangMuMingCheng"];
                huifuNeiRong = [dic objectForKey:@"NeiRong"];
                huifuPerson = [dic objectForKey:@"HuiFuRen"];
                huifutime = [dic objectForKey:@"HuiFuShiJian"];
                
                projectid = [dic objectForKey:@"XiangMuID"];
                messageid = [dic objectForKey:@"XinXiID"];;
                messageType = [dic objectForKey:@"XinXiLeiXing"];;
                faultid = [dic objectForKey:@"FanKuiXinXiID"];
                FanKuiXinXiLeiXing = [dic objectForKey:@"FanKuiXinXiLeiXing"];
                fankuiType = [dic objectForKey:@"FanKuiXinXiLeiXing"];
                 NSArray *fujianarray = [dic objectForKey:@"FuJian"];
                for (NSDictionary *fujiandic in fujianarray) {
                    
                    FujianClass *fujianC = [[FujianClass alloc]init];
                    fujianC.fujianorgid = [dic objectForKey:@"XinXiID"];
                    fujianC.fujianproid = [dic objectForKey:@"XiangMuID"];
                    fujianC.fujianfaultid = [dic objectForKey:@"FanKuiXinXiID"];
                    fujianC.fujianFaultType = [dic objectForKey:@"FanKuiXinXiLeiXing"];
                    fujianC.fujianMessageType = [dic objectForKey:@"XinXiLeiXing"];
                    fujianC.fujianid = [fujiandic objectForKey:@"FuJianID"];
                    fujianC.fujiantype = [fujiandic objectForKey:@"FuJianLeiXing"];
                    fujianC.fujianName = [fujiandic objectForKey:@"FuJianMingCheng"];
                    fujianC.fujianPaths = [NSString stringWithFormat:@"%@%@",URLHEADER,[fujiandic objectForKey:@"FuJianDiZhi"]];
                    [self.fujianArray addObject:fujianC];

                }
            
            }
            
             
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:[resultJsonDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
        }
    
    
    
    }];
    [manager startSynchronous];//开始同步

    
    
    
}
#pragma mark 跳转详细页
-(void)GotoDetailVC{
    DetailedViewController *vc = [[DetailedViewController alloc]initWithNibName:@"DetailedViewController" bundle:nil];
    vc.xinxi_type = fankuiType;
    vc.xinxi_id = messageid;
    vc.xinxi_currentFaultId = faultid;
    
    [self.navigationController pushViewController:vc animated:YES];
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
    if ([elementName isEqualToString:@"ChaKanQiTaXiaoXiXiangQingResult"]) {
        self.serverDataStr = [[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.serverDataStr appendString:string];
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



@end
