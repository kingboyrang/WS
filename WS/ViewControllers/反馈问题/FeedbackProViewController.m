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
  
    cell1.labDetail.text=[UserInfo shareInstance].project_current_name;
    
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
        cell5.labDetail.text=@"  The words limitation has 200 character left";
    }else{
        cell5.labTitle.text=@"文字描述:";
        cell5.labDetail.text=@"  字数限制还剩1000字";
    }
    CVTextViewCell *cell6=[[CVTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
- (IBAction)submitAction:(id)sender {
//    if ( self.faultTextView.text.length == 0) {
//        ALERT(@"描述不能为空");
//        return ;
//    }
    
//    NSLog(@"开始同步请求!");
    CVRadioCollectionCell *zhuanyeCell = [self.cells objectAtIndex:1];
    NSString *zhuanyeStr = zhuanyeCell.myId;
    
    CVRadioCollectionCell *wentiCell = [self.cells objectAtIndex:2];
    NSString *wentiStr = wentiCell.myId;
    
    FaultCell *fCell = [self.cells objectAtIndex:3];
    self.seleFaultStr = fCell.seleFaultStr;
    self.seleExitsStr = fCell.seleExitsStr;
    
    
    NSData *sendFujianJson=[self.fujianArray JSONData];
    NSString *strjson=[[NSString alloc]initWithData:sendFujianJson encoding:NSUTF8StringEncoding];

    NSMutableArray *params=[NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"{XiangMuID:\"%@\",RenYuanID:\"%@\",ZhuangYe:\"%@\",WenTiJiBie:\"%@\",ShiFouGuZhang:\"%@\",ShiFouChanQiCunZai:\"%@\",FanKuiNeiRong:\"%@\",FuJian:%@}",[UserInfo shareInstance].project_current_Id,[UserInfo shareInstance].userId,zhuanyeStr,wentiStr,self.seleFaultStr,self.seleExitsStr,self.myTextView.text,strjson];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"fanKuiXiaoXiXinXi", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"FanKuiXiaoXiTianJia";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
//            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            return;
        }
//        NSLog(@"同步请求成功，请求结果为=%@",manager.responseString);
    }];
    [manager startSynchronous];//开始同步

}
@end
