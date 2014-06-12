//
//  ProView.m
//  WS
//
//  Created by liuqin on 14-5-16.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ProView.h"

@implementation ProView
@synthesize tableArray,proTableVew,seleDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
        
    }
    return self;
}
- (void)makeTableViewCGReframe:(int) x :(int) y :(int) w :(int) h{
   
    self.proTableVew = [[UITableView alloc]initWithFrame:CGRectMake(0,y , 320,h)];
    self.proTableVew.backgroundColor = [UIColor clearColor];
  
    if (h < 568) {
        self.proTableVew.scrollEnabled = NO;
    }
    self.proTableVew.delegate = self;
    self.proTableVew.dataSource = self;
    self.proTableVew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.proTableVew];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    headLabel.text = @"售后服务项目测试";
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.backgroundColor = [UIColor clearColor];
    return headLabel;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return  self.tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    ProCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell) {
        for (UIView *cellview in cell.contentView.subviews) {
            [cellview removeFromSuperview];
        }
        
    }
    cell = [[[NSBundle mainBundle]loadNibNamed:@"ProCell" owner:nil options:nil]objectAtIndex:0];
    
    
   
    ProjectClass *class = [self.tableArray objectAtIndex:indexPath.row];
    cell.proClass = class;
    cell.cellBtn.tag = [cell.proClass.pro_id intValue];
    [cell.cellBtn setTitle:cell.proClass.pro_quancheng forState:UIControlStateNormal];
    [cell.cellBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = cell.cellBtn.titleLabel.frame;
    
       if ( ![cell.proClass.WeiChuLiShuLiang isEqualToString:@"0"]) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.cellBtn.frame.origin.x+rect.origin.x+rect.size.width,  rect.origin.y-5, 20, 20)];
        [imageView setImage:[UIImage imageNamed:@"Red_circle"]];
        [cell addSubview:imageView];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 16, 16)];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = cell.proClass.WeiChuLiShuLiang;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor whiteColor];
        [imageView addSubview:lab];
    }
       else if (![cell.proClass.WeiDuShuLiang isEqualToString:@"0"]) {
           UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.cellBtn.frame.origin.x+rect.origin.x+rect.size.width, rect.origin.y-2, 8, 8)];
           [imageView setImage:[UIImage imageNamed:@"Red_dot"]];
           [cell addSubview:imageView];
       }

    
    
    return cell;
}
-(void)clickAction:(UIButton *)btn{
    id v=[btn superview];
    do{
        v=[v superview];
    }while(![v isKindOfClass:[ProCell class]]);
    ProCell *Cell = (ProCell *)v;
    ProjectClass *proC = Cell.proClass;
    [self.seleDelegate selePro:proC];
}
@end
