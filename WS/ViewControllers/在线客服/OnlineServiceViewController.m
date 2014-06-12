//
//  OnlineServiceViewController.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "OnlineServiceViewController.h"
#import "PersonClass.h"


@interface OnlineServiceViewController ()

@end

@implementation OnlineServiceViewController

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
    self.navView.titel_Label.text = @"项目人员";
    self.resultArray = [[NSMutableArray alloc]init];
    [self sendMessage];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell != nil) {
        for (UIView *v in cell.subviews) {
            [v removeFromSuperview];
        }
      }
    cell = [[[NSBundle mainBundle]loadNibNamed:@"OnlineCell" owner:nil options:nil] objectAtIndex:0];
   
    PerSonClass *person = [PerSonClass alloc];
    person = [self.resultArray objectAtIndex:indexPath.row];
    
    cell.idLabel.text = person.RenYuanID;
    cell.nameLabel.text = person.XingMing;
    cell.roleLabel.text = person.RenYuanJueSeMiaoShu;
    cell.fizhilabel.text = person.FenZhi;
    
    
    
    return cell;
}
#pragma mark
-(void)sendMessage{
   NSString *str =[NSString stringWithFormat:@"{XiangMuID:\"%@\",RenYuanID:\"%@\"}",[UserInfo shareInstance].project_current_Id,[UserInfo shareInstance].userId ];
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
//            NSLog(@"jsonDic = %@",jsonDic);
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
                    [self.resultArray addObject:class];
                }
                [self.MytableView reloadData];
                
                
                
//                self.resultArray = [Global resultArray:self.jsonStr :3];//项目人员信息
//                NSLog(@"%@",self.resultArray);
//                [self.MytableView reloadData];
            }
            
    
        
    }];
    [manager startSynchronous];//开始同步
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //        NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"XiangMuRenYuanResult"]) {
        self.jsonStr = [[NSMutableString alloc]init];
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


@end
