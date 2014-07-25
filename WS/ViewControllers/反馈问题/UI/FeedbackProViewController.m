//
//  FeedbackProViewController.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FeedbackProViewController.h"
#import "BtnView.h"
#import "BtnClass.h"
#import "FaultCell.h"
#import "ServiceOperation.h"
#import "ServiceOperationQueue.h"
@interface FeedbackProViewController ()<CVRadioCollectionDelegate>

@property(nonatomic,strong)BtnView *selectBtnClass;
@property (strong, nonatomic)  UIButton *fautltBtn;
@property (strong, nonatomic)  UIButton *exitsBtn;
@property (strong, nonatomic)  NSMutableArray *btnArray;

@end

@implementation FeedbackProViewController

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
    
    
    cellH=0;

    zhuanyebtnArr = [[NSMutableArray alloc]init];
    wentijibieArr = [[NSMutableArray alloc]init];
    self.seleExitsStr = @"False";
    self.seleFaultStr = @"2";
    self.xinxiType = @"1";

    
    lauguageStr = [Global getPreferredLanguage];
    if ([lauguageStr isEqualToString:@"en"]) {
        self.navView.titel_Label.text = @"Feedback issues";
    }else{
        self.navView.titel_Label.text = @"反馈问题";
    }
    self.ZhuanYeBtnArr = [self sendJiChuData:ZHUANYE];
    self.WenTiJiBieArr = [self sendJiChuData:JIBIE]; //这已经获取了。。
    
    
    
    CVLabelLabelCell *cell1=[[CVLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if ([lauguageStr isEqualToString:@"en"]) {
          cell1.labTitle.text=@"Project:";
    }else{
          cell1.labTitle.text=@"项目:";
    }
  
    cell1.labDetail.text=[NSString stringWithFormat:@" %@",[UserInfo shareInstance].project_current_name] ;
    
    CVRadioCollectionCell *cell2=[[CVRadioCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if ([lauguageStr isEqualToString:@"en"]) {
        cell2.labTitle.text=@"Specialized filed:";
    }else{
        cell2.labTitle.text=@"专业:";
    }
    
    
   
    for (BtnClass *class in self.ZhuanYeBtnArr) {
        CVRadio *radio = [[CVRadio alloc]init];
        [radio setRadioTitle:class.MingCheng source:class];
        [cell2.radios addRadio:radio];
    }
    
    CVRadioCollectionCell *cell3=[[CVRadioCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if ([lauguageStr isEqualToString:@"en"]) {
        cell3.labTitle.text=@"Level:";
    }else{
        cell3.labTitle.text=@"级别:";
    }
    
    for (BtnClass *class in self.WenTiJiBieArr) {
        CVRadio *radio = [[CVRadio alloc]init];
        radio.delegate =self;
        [radio setRadioTitle:class.MingCheng source:class];
        [cell3.radios addRadio:radio];
    }
    FaultCell *cell4=[[FaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if ([lauguageStr isEqualToString:@"en"]) {
        cell4.labTitle.text=@"Malfunction:";
    }else{
        cell4.labTitle.text=@"故障:";
    }
    cell5=[[CVLabelLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if ([lauguageStr isEqualToString:@"en"]) {
        cell5.labTitle.text=@"Text description:";
        cell5.labDetail.text=@" The words limitation has 200 character left";
    }else{
        cell5.labTitle.text=@"文字描述:";
        cell5.labDetail.text=@" 字数限制还剩1000字";
    }
    cell6=[[CVTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell6.delegate = self;
    
    self.cells=[NSMutableArray arrayWithObjects:cell1,cell2,cell3,cell4,cell5,cell6, nil];

 }
-(void)ChangeSuzi:(NSString *)str{
     cell5.labDetail.text=str;
}
#pragma mark请求基础数据
-(NSMutableArray *)sendJiChuData:(NSString *)str{
      NSMutableArray *selfresutArray = [[NSMutableArray alloc]init];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"fenLei", nil]];
    
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"GetJiChuShuJuByFenLei";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
//            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            return;
        }
//        NSLog(@"同步请求成功，请求结果为=%@",manager.responseString);
        NSString *resulStr = manager.responseString;
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[resulStr dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
        [xml parse];  //xml开始解析
        NSString * responseString = self.jsonStr;
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSError *err;
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];      //json解析 转成 data
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
        if ([[jsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
            NSArray *array = [jsonDic objectForKey:@"JiChuShuJu"];
            for (NSDictionary *dic in array) {
                BtnClass *class = [[BtnClass alloc]init];
                class.myId = [dic objectForKey:@"ID"];
                class.MingCheng = [dic objectForKey:@"MingCheng"];
                class.seleID = 0;
                [selfresutArray addObject:class];
            }
        }
    }];
    [manager startSynchronous];//开始同步
    return selfresutArray;
    
    

}
#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   if ([self.cells[indexPath.row] isKindOfClass:[CVTextViewCell class]]) {
       
       if (self.faultTableV.frame.size.height-cellH>40) {
           return self.faultTableV.frame.size.height-cellH;
       }
       return 120;
    }
    CGFloat h=40;
    if ([self.cells[indexPath.row] isKindOfClass:[CVRadioCollectionCell class]]) {
        CVRadioCollectionCell *cell=self.cells[indexPath.row];
        if (cell.radios.frame.size.height>40) {
            h=cell.radios.frame.size.height+10;
        }
    }
    cellH+=h;
    return h;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 5;
    return [self.cells count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=self.cells[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark xmlparser
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //        NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetJiChuShuJuByFenLeiResult"]) {
        self.jsonStr = [[NSMutableString alloc]init];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.jsonStr appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //      NSLog(@"%@",NSStringFromSelector(_cmd) );
}
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
}

- (IBAction)SeleImageAction:(id)sender {
    [self chooseImage];
}
#pragma  mark 提交事件
- (IBAction)submitActionPro:(id)sender{
    if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
    if ( cell6.textView.text.length == 0) {
        ALERT(@"描述不能为空");
        return ;
    }

    CVRadioCollectionCell *zhuanyeCell = [self.cells objectAtIndex:1];
    NSString *zhuanyeStr = zhuanyeCell.myId;
    
    CVRadioCollectionCell *wentiCell = [self.cells objectAtIndex:2];
    NSString *wentiStr = wentiCell.myId;
    
    FaultCell *fCell = [self.cells objectAtIndex:3];
    self.seleFaultStr = fCell.seleFaultStr;
    self.seleExitsStr = fCell.seleExitsStr;
    
    
    if (zhuanyeStr.length == 0) {
        ALERT(@"请选择专业");
        return ;
    }
    if (wentiStr.length == 0) {
        ALERT(@"请选择级别");
        return ;
    }
    __block UIView *bg=nil;
    if (!bg) {
        bg=[[UIView alloc] initWithFrame:self.view.bounds];
        bg.backgroundColor=[UIColor grayColor];
        bg.alpha=0.613f;
        
        UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-30)/2, (self.view.bounds.size.height-30)/2, 30, 30)];
        indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
        [indicator startAnimating];
        [bg addSubview:indicator];
        [self.view addSubview:bg];
    }

    
    if (self.fujianArray.count > 0) {
        
        //队列请求
        ServiceOperationQueue *queue=[[ServiceOperationQueue alloc] init];
        //这是上传图片
        for (FujianClass *fujianClass in self.fujianArray) {
            NSString *datastr = fujianClass.fujianData;
            NSString *name = fujianClass.fujianName;
            //添加图片上传线程
            [queue addOperation:[self uploadWithBase64:datastr fileName:name]];
        }
        [queue setFinishBlock:^(ServiceOperation *operation) {
            NSDictionary *userInfo=[operation userInfo];
            NSLog(@"operation.responseStatusCode = %d",operation.responseStatusCode);
            if (operation.responseStatusCode==200) {
                NSString *xml=[operation.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
                XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
                XmlNode *node=[_helper soapXmlSelectSingleNode:@"//UploadFileResult"];
                BOOL boo=NO;
                NSDictionary *resultJsonDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
                if (resultJsonDic&&[resultJsonDic.allKeys containsObject:@"return"]&&[[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
                    boo=YES;
                    NSMutableArray *array = [[NSMutableArray alloc]init];
                    NSDictionary *dic = @{@"YuanMingCheng": [resultJsonDic objectForKey:@"YuanMingCheng"],@"XinMingCheng":[resultJsonDic objectForKey:@"XinMingCheng"],@"LeiXing":[resultJsonDic objectForKey:@"LeiXing"]};
                    [array addObject:dic];
                    [self.sendFujianArray addObject:dic];
                }
                NSLog(@"upload image %@==%@!",[userInfo objectForKey:@"name"],boo?@"success":@"failed!");
            }
            
        }];
        //队列请求成功
        [queue setCompleteBlock:^{
            NSLog(@"image finished!!!!!");
            //图片上传成功后，执行其它处理
            NSString *fujianStr = [self.sendFujianArray JSONString];
            NSMutableArray *params=[NSMutableArray array];
            NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",RenYuanID:\"%@\",ZhuangYe:\"%@\",WenTiJiBie:\"%@\",ShiFouGuZhang:\"%@\",ShiFouChanQiCunZai:\"%@\",FanKuiNeiRong:\"%@\",FuJian:%@}",[UserInfo shareInstance].project_current_Id,[UserInfo shareInstance].userId,zhuanyeStr,wentiStr,self.seleFaultStr,self.seleExitsStr,cell6.textView.text,fujianStr];
            [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"fanKuiXiaoXiXinXi", nil]];
            ServiceArgs *args=[[ServiceArgs alloc] init];
            args.methodName=@"FanKuiXiaoXiTianJia";//要调用的webservice方法
            args.soapParams=params;//传递方法参数
            ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
            [manager setFinishBlock:^{
                [bg removeFromSuperview];
                bg=nil;
                NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
                XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
                XmlNode *node=[_helper soapXmlSelectSingleNode:@"//FanKuiXiaoXiTianJiaResult"];
                
                NSDictionary *resultJsonDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
                if (resultJsonDic&&[resultJsonDic.allKeys containsObject:@"return"]&&[[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
                    
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提交失败" message:[resultJsonDic objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alterView show];
                    
                }
                
            }];
            [manager setFailedBlock:^{
                [bg removeFromSuperview];
                bg=nil;
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alterView show];
            }];
            [manager startAsynchronous];
        }];
    }else{
        NSString *fujianStr = [self.sendFujianArray JSONString];
        NSMutableArray *params=[NSMutableArray array];
        NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",RenYuanID:\"%@\",ZhuangYe:\"%@\",WenTiJiBie:\"%@\",ShiFouGuZhang:\"%@\",ShiFouChanQiCunZai:\"%@\",FanKuiNeiRong:\"%@\",FuJian:%@}",[UserInfo shareInstance].project_current_Id,[UserInfo shareInstance].userId,zhuanyeStr,wentiStr,self.seleFaultStr,self.seleExitsStr,cell6.textView.text,fujianStr];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"fanKuiXiaoXiXinXi", nil]];
        
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.methodName=@"FanKuiXiaoXiTianJia";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        [manager setSuccessBlock:^() {
            if (manager.error) {
                return;
            }
            [bg removeFromSuperview];
            NSString *xml=[manager.responseString stringByReplacingOccurrencesOfString:@"xmlns=\"http://tempuri.org/\"" withString:@""];
            XmlParseHelper *_helper = [[XmlParseHelper alloc] initWithData:xml];
            XmlNode *node=[_helper soapXmlSelectSingleNode:@"//FanKuiXiaoXiTianJiaResult"];
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
            
            if ([[resultDic objectForKey:@"return"]isEqualToString:@"true"]) {
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alterView show];
            }else{
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"添加不成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alterView show];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        [manager startSynchronous];//开始同步
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
@end
