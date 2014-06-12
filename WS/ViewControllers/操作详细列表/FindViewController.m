//
//  FindViewController.m
//  WS
//
//  Created by liuqin on 14-5-20.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FindViewController.h"
#import "Header.h"
#import "FMDBClass.h"
#import "FujianBtn.h"
@interface FindViewController ()

@end

@implementation FindViewController

@synthesize myTableView;
@synthesize selfTilteStr,dataType,serverJsonStr,czClass;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[Global getPreferredLanguage]isEqualToString:@"en"]) {
        self.navView.titel_Label.text = @"Feedback information";
    }else{
        
          self.navView.titel_Label.text = selfTilteStr;
    }
    
  
    self.tableArray = [[NSMutableArray alloc]init];
    self.serverJsonStr = [[NSMutableString alloc]init];
    self.heightArray = [[NSMutableArray alloc]init];
    
    [self sendMessage];
}
-(void)sendMessage{
    NSMutableArray *params=[NSMutableArray array];
    NSString *str;
    
    NSString *whereStr = [NSString stringWithFormat:@"WHERE proid = %@ and fautlid = %@ and xinxiType = %@",[UserInfo shareInstance].project_current_Id ,self.czClass.fautlid,self.dataType];
    int zuida = [Global TableName:CZTABLE where:whereStr isFault:NO zuidaZhuanfa:NO];
    
    if ([self.dataType isEqualToString:@"3"]) {
      
        str = [NSString stringWithFormat:@"{XinXiLeiXing: \"%@\",FanKuiID: \"%@\",ZuiDaJianYiID: \"%d\",ZuiDaYiJianID: \"0\",JieGuoID: \"0\",JieGuoQueRenID: \"0\",PingJiaID: \"0\"}",self.dataType,self.czClass.fautlid,zuida];

    }else if ([self.dataType isEqualToString:@"4"]){
        str = [NSString stringWithFormat:@"{XinXiLeiXing: \"%@\",FanKuiID: \"%@\",ZuiDaJianYiID: \"0\",ZuiDaYiJianID: \"%d\",JieGuoID: \"0\",JieGuoQueRenID: \"0\",PingJiaID: \"0\"}",self.dataType,self.czClass.fautlid,zuida];

    }else if ([self.dataType isEqualToString:@"5"]){
        str = [NSString stringWithFormat:@"{XinXiLeiXing: \"%@\",FanKuiID: \"%@\",ZuiDaJianYiID: \"0\",ZuiDaYiJianID: \"0\",JieGuoID: \"%d\",JieGuoQueRenID: \"0\",PingJiaID: \"0\"}",self.dataType,self.czClass.fautlid,zuida];

    }else if ([self.dataType isEqualToString:@"6"]){
        str = [NSString stringWithFormat:@"{XinXiLeiXing: \"%@\",FanKuiID: \"%@\",ZuiDaJianYiID: \"0\",ZuiDaYiJianID: \"0\",JieGuoID: \"0\",JieGuoQueRenID: \"%d\",PingJiaID: \"0\"}",self.dataType,self.czClass.fautlid,zuida];

    }else if ([self.dataType isEqualToString:@"7"]){
        str = [NSString stringWithFormat:@"{XinXiLeiXing: \"%@\",FanKuiID: \"%@\",ZuiDaJianYiID: \"0\",ZuiDaYiJianID: \"0\",JieGuoID: \"0\",JieGuoQueRenID: \"0\",PingJiaID: \"%d\"}",self.dataType,self.czClass.fautlid,zuida];

    }
    
    
   
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"chaKanXinXiXiangQing", nil]];
    
    ServiceArgs *args=[[ServiceArgs alloc] init] ;
    args.methodName=@"ChaKanXiaoXiLieBiao";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    [manager setSuccessBlock:^() {
        if (manager.error) {
            NSLog(@"同步请求失败，失败原因=%@",manager.error.description);
            return;
        }
//        NSLog(@"同步请求成功，请求结果为=%@",manager.responseString);
        
        NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[manager.responseString dataUsingEncoding:NSUTF8StringEncoding]];
        [xml setDelegate:self];
     
        [xml parse];  //xml开始解
        NSDictionary *resultJsonDic = [Global GetjsonStr:self.serverJsonStr];
        
        
        
        if ([[resultJsonDic objectForKey:@"return"] isEqualToString:@"true"]) {
           [Global resultArray:resultJsonDic : 5 :self.dataType : self.czClass where:@""]; //添加新数据
            
            NSString *whereStr = [NSString stringWithFormat:@"WHERE proid = %@ and fautlid = %@ and xinxiType = %@",[UserInfo shareInstance].project_current_Id ,self.czClass.fautlid,self.dataType];
            self.tableArray = [[FMDBClass shareInstance]seleDate:CZTABLE wherestr:whereStr];
            

            
            for (CaoZuoClass *myclass in self.tableArray) {
                
                NSString *whereStr = [NSString stringWithFormat:@"where proid = %@ and faultid = %@ and faultType = %@ and messType = %@ and orgid = %@",myclass.proId,myclass.fautlid,myclass.faultType,myclass.xinxiType,myclass.xinxiID];
                
                NSArray *fujianarray = [[FMDBClass shareInstance]seleDate:IMAGETABLE wherestr:whereStr];
                
                int heighCell = 0;
                for (int i = 0;i < fujianarray.count; i++) {
                    FujianClass *fjclass = [[FujianClass alloc]init];
                    fjclass = [fujianarray objectAtIndex:i];
                    if ([fjclass.fujiantype isEqualToString:@"1"]) { //图片
                        heighCell += 90;
                    }
                    else
                    {
                        heighCell += 25;
                        
                    }
                }
                [self.heightArray addObject:[NSString stringWithFormat:@"%d",heighCell]];
            }
               [self.myTableView reloadData];
        }else{
            ALERT([Global tishiMessage:[resultJsonDic objectForKey:@"error"]]);
        }
        
    }];
    [manager startSynchronous];//开始同步
}

#pragma mark UITABLEVIEWDELEGATE
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120+[[self.heightArray objectAtIndex:indexPath.row] intValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    
    CZCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell) {
       
        for (CZCell * cz in cell.subviews) {
            [cz removeFromSuperview];
        }
    }
     cell = [[[NSBundle mainBundle]loadNibNamed:@"CZCell" owner:nil options:nil] objectAtIndex:0];
    cell.delegate = self;
    CaoZuoClass *myClass = [self.tableArray objectAtIndex:indexPath.row];
    
    cell.huifuContent.text = myClass.content;
    cell.huifuiRen.text =myClass.huifuperson;
    cell.huifuTime.text = myClass.huifutime;
    if (myClass.HuiFuXuanXiang.length !=0) {
        cell.label.text = myClass.HuiFuXuanXiang;
    }
    NSString *whereStr = [NSString stringWithFormat:@"where proid = %@ and faultid = %@ and faultType = %@ and messType = %@ and orgid = %@",myClass.proId,myClass.fautlid,myClass.faultType,myClass.xinxiType,myClass.xinxiID];
    
    NSArray *fujianarray = [[FMDBClass shareInstance]seleDate:IMAGETABLE wherestr:whereStr];
    [cell setImagesWithArray:fujianarray];
    return cell;
    
}
-(void)BigImage:(UIImage *)myImage{
    ImageCropper *cropper = [[ImageCropper alloc] initWithImage:myImage];
    [cropper setDelegate:self];
    [self presentViewController:cropper animated:YES completion:nil];
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
-(void)downFileAction:(FujianClass *)fjclass{
    NSString *str = fjclass.fujianPaths;
    
    
    [WTStatusBar setStatusText:@"Downloading data..." animated:YES];
     _progress=0.0;
    ServiceRequestManager *manager=[ServiceRequestManager requestWithURL:[NSURL URLWithString:str]];
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
        
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",locationString,fjclass.fujianName]];
        [fileData writeToFile: uniquePath    atomically:YES];
        
        [WTStatusBar setStatusText:@"Done!" timeout:0.5 animated:YES];
        
    }];
    [manager setFailedBlock:^() {
        NSLog(@"下载失败，失败原因=%@",manager.error.description);
         [WTStatusBar setStatusText:@"文件不存在" timeout:0.5 animated:YES];
        
    }];
    [manager startAsynchronous];//开始异步
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
    if ([elementName isEqualToString:@"ChaKanXiaoXiLieBiaoResult"]) {
        self.serverJsonStr = [[NSMutableString alloc]init];
    }
}   

//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.serverJsonStr appendString:string];
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
