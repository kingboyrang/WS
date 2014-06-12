//
//  ForwardingViewController.m
//  WS
//
//  Created by liuqin on 14-5-4.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ForwardingViewController.h"

@interface ForwardingViewController ()

@end

@implementation ForwardingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navView.titel_Label.text = @"转发";
    }
    return self;
}
-(void)sendMessage{
    NSString *str =[NSString stringWithFormat: @"{XiangMuID:\"%@\",RenYuanID:\"%@\"}",[UserInfo shareInstance].project_current_Id,[UserInfo shareInstance].userId];
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"xiangMuRenYuan", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"XiangMuRenYuan";//要调用的webservice方法
    args.soapParams=params;//传递方法参数
    //    NSLog(@"soap=%@",args.bodyMessage);
    ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
    __block ServiceRequestManager *this = manager;
    [manager setSuccessBlock:^() {
        if (this.error) {
            NSLog(@"同步请求失败，失败原因=%@",this.error.description);
            //请求失败
           
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"连接服务器失败" message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alterView show];
                
        
            
            return;
        }
        //请求成功
            NSLog(@"%@",this.responseString);
            NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[this.responseString dataUsingEncoding:NSUTF8StringEncoding]];
            [xml setDelegate:self];
            [xml parse];  //xml开始解析
            //
            NSError *err;
            NSData *jsonData = [self.jsonStr dataUsingEncoding:NSUTF8StringEncoding];      //json解析 转成 data
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
                       NSLog(@"jsonDic = %@",jsonDic);
            NSString *returnStr = [jsonDic objectForKey:@"return"];
            if ([returnStr isEqualToString:@"false"])
            {
                NSString *errorStr = [jsonDic objectForKey:@"error"];
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:errorStr] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alterView show];
            }
            else
            {
                NSArray *array = [jsonDic objectForKey:@"XiangMuRenYuanList"];
                for (NSDictionary *dic in array) {
                    PerSonClass *class = [[PerSonClass alloc]init];
                    class.XingMing = [dic objectForKey:@"XingMing"];
                    class.RenYuanID = [dic objectForKey:@"RenYuanID"];
                    class.RenYuanJueSeMiaoShu = [dic objectForKey:@"RenYuanJueSeMiaoShu"];
                    class.FenZhi = [dic objectForKey:@"FenZhi"];
                    class.isSele  = @"0";
                    [self.personArray addObject:class];
                }
                [self.myTableView reloadData];
             }
            
        
    }];
    [manager startSynchronous];//开始同步
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navView.titel_Label.text = @"转发";

    self.personArray = [[NSMutableArray alloc]init];
    [self sendMessage];
//    NSMutableArray *array = [[FMDBClass shareInstance]seleDate:PRO_PERSON_INFOTABLE wherestr:@""];
//    for(int i = 0; i< array.count; i++){
//        NSMutableDictionary *dic1 = [array objectAtIndex:i];
//        [dic1  setObject:@"0" forKey:@"isSele"];
//        NSLog(@"%@",dic1);
//        [self.personArray addObject:dic1];
//    }
    
//    NSLog(@"self.personArray----%@",self.personArray);
}
#pragma mark 转发
-(void)sendforwardMessage{
    NSMutableString *nameStr = [[NSMutableString alloc]init];
    for (PerSonClass *class in self.personArray  ) {
      NSString *str = class.isSele;
        if ([str isEqualToString:@"1"]) {
            [nameStr appendString:[NSString stringWithFormat:@"%@,",class.XingMing]];
            
        }
        
        
    }
    self.jieshourenid = [nameStr substringToIndex:[nameStr length]-1];  //得到转发人id
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str =[NSString stringWithFormat:@"{XinXiLeiXing:\"%@\",XinXiID:\"%@\",FanKuiID:\"%@\",ZhuanFaRenID:\"%@\",JieShouRenIds:\"%@\",XiangMuID:\"%@\"}",self.messageType,self.messageid,self.faultid,self.zhuangfarenid,self.jieshourenid,self.projectid];
        NSMutableArray *params=[NSMutableArray array];
        [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"xinXiZhuanFa", nil]];
        ServiceArgs *args=[[ServiceArgs alloc] init];
        args.methodName=@"XinXiZhuanFa";//要调用的webservice方法
        args.soapParams=params;//传递方法参数
        //    NSLog(@"soap=%@",args.bodyMessage);
        ServiceRequestManager *manager=[ServiceRequestManager requestWithArgs:args];
        __block ServiceRequestManager *this = manager;
        [manager setSuccessBlock:^() {
            if (this.error) {
                NSLog(@"同步请求失败，失败原因=%@",this.error.description);
                //请求失败
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:this.error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                    
                });
                
                return;
            }
            //请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"登录请求成功，请求结果为=\n%@",this.responseString);
                NSXMLParser *xml = [[NSXMLParser alloc]initWithData:[this.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                [xml setDelegate:self];
                [xml parse];  //xml开始解析
                NSLog(@"%@",self.jsonStr);
                NSString * responseString = self.jsonStr;
                responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                             NSError *err;
                NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];      //json解析 转成 data
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
                NSLog(@"%@",jsonDic);
                NSString *returnstr = [jsonDic objectForKey:@"return"];
                if (![returnstr isEqualToString:@"true"]) {
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:[jsonDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"转发成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alterView show];
                }
             });
            
        }];
        [manager startSynchronous];//开始同步
        
    });
    

   
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.personArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellid";
    ForwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"ForwardTableViewCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
        cell.delegate = self;
    }
 
  
  
    PerSonClass *person = [[PerSonClass alloc]init];
     person = [self.personArray objectAtIndex:indexPath.row];
    person.RenYuanID = person.RenYuanID;
    cell.name_label.text = person.XingMing;
    cell.idStr = person.RenYuanID;
    cell.isSele = person.isSele;
    if ([cell.isSele isEqualToString:@"1"]) {
        [cell.btn setImage:[UIImage imageNamed:@"forwardSele"]forState:0];
    }else{
         [cell.btn setImage:[UIImage imageNamed:@"forwardNormal"]forState:0 ];
    }
    cell.btn.tag = indexPath.row;
    
    return cell;
    
}
-(void)changeCellBtnImage:(UIButton *)btn{
    PerSonClass *class = [[PerSonClass alloc]init];
    class = [self.personArray objectAtIndex:btn.tag];
    NSString *str = class.isSele;
    if ([str isEqualToString:@"0"])
    {
        class.isSele = @"1";
    }
    else
    {
        class.isSele = @"0";
        
    }
[self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([elementName isEqualToString:@"XinXiZhuanFaResult"]) {
        self.jsonStr = [[NSMutableString alloc]init];
    }else if ([elementName isEqualToString:@"XiangMuRenYuanResult"]){
        self.jsonStr =[[NSMutableString alloc]init];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd) );
    [self.jsonStr appendString:string];
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





- (IBAction)ButtonAction:(id)sender {
    [self sendforwardMessage];
}
@end
