//
//  CKKCViewController.m
//  WS
//
//  Created by liuqin on 14-7-17.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CKKCViewController.h"
#import "CKFindViewController.h"

@interface CKKCViewController ()

@end

@implementation CKKCViewController

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
    self.tableArr = [[NSMutableArray alloc]init];
    
    if (![self IsEnableConnection]) {
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alterView show];
        return;
    }
     NSString *str  =[NSString stringWithFormat:@"{CangKuID:\"%@\",WuLiaoLeiXingID:\"%@\",WuLiaoMingCheng:\"%@\",DuQuShuLiang:\"%@\"}",self.CangKuID,self.WuLiaoLeiXingID,self.WuLiaoMingCheng,self.DuQuShuLiang] ;
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"kuCunXinXiChaKan", nil]];
    ServiceArgs *args=[[ServiceArgs alloc] init];
    args.methodName=@"KuCunXinXiChaKan";//要调用的webservice方法
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
        NSArray *node=[_helper soapXmlSelectNodes:@"//KuCunXinXiChaKanResult"];
        NSDictionary *Dic = [node objectAtIndex:0];
        NSString *dicstr = [Dic objectForKey:@"text"];
        NSDictionary *dic = [Global GetjsonStr:dicstr];
        if ([[dic objectForKey:@"return"]isEqualToString:@"true"]) {
            
            NSArray *arry = [dic objectForKey:@"CangKuWuLiaoList"];
            for (NSDictionary *dic in arry) {
                CkkcCalss *cl = [[CkkcCalss alloc]init];
                cl.WuLiaoBianHao = [dic objectForKey:@"WuLiaoBianHao"];
                cl.KuCunLiang = [NSString stringWithFormat:@"库存数量:%@",[dic objectForKey:@"KuCunLiang"]];
                cl.CunChuWeiZhi = [NSString stringWithFormat:@"库存位置:%@",[dic objectForKey:@"CunChuWeiZhi"]];
                cl.message = [NSString stringWithFormat:@"%@-%@-%@",[dic objectForKey:@"WuLiaoMingCheng"],[dic objectForKey:@"WuLiaoLeiXing"],[dic objectForKey:@"SuoShuCangKu"]];
                [self.tableArr addObject:cl];
            }
            
            [self.tableV reloadData];
            
        }else{
//            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:[Global tishiMessage:[resultDic objectForKey:@"error"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alterView show];
        }
        
        
            }];
    [manager startSynchronous];//开始同步

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navView.titel_Label.text = @"库存查看";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setImage:[UIImage imageNamed:@"backgroundImage.png"]];
    [self.view insertSubview:imageView belowSubview:self.navView];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, (self.view.bounds.size.height-60-49))];
    self.tableV.backgroundColor = [UIColor clearColor];
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.view addSubview:self.tableV];
    
    UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height - 49 , 320, 1)];
    [lineImage setImage:[UIImage imageNamed:@"line"]];
    [self.view addSubview:lineImage];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(140, lineImage.frame.origin.y + 8, 28, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"searchBtn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    
}
#pragma mark tableViewDeleagte
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *identifier = @"identifier";
    CkkcCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CkkcCell" owner:nil options:nil]objectAtIndex:0];
    }

    CkkcCalss *cl = [self.tableArr objectAtIndex:indexPath.row];
    cell.row1.text = cl.WuLiaoBianHao;
    cell.row2.text = cl.message;
    cell.row3.text = cl.CunChuWeiZhi;
    cell.row4.text = cl.KuCunLiang;
    
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArr.count;
}



#pragma mark搜索页面
-(void)searchAction{
    
    CKFindViewController *vc = [[CKFindViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
