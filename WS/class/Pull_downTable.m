//
//  Pull_downTable.m
//  WS
//
//  Created by liuqin on 14-5-8.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "Pull_downTable.h"

@implementation Pull_downTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor redColor];
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *labele = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 28)];
        labele.backgroundColor = [UIColor colorWithRed:34/255.0 green:68/255.0 blue:105/255.0 alpha:1];
        labele.textAlignment = NSTextAlignmentCenter;
        labele.font = [UIFont systemFontOfSize:self.fondSize];
        labele.textColor = [UIColor whiteColor];
        labele.tag = 100;
        [cell.contentView addSubview:labele];
        UIView *View = [[UIView alloc]initWithFrame:CGRectMake(0, labele.frame.origin.y+labele.frame.size.height, self.frame.size.width, 2)];
        View.backgroundColor = [UIColor whiteColor];
        View.alpha = 0.95f;
        [cell.contentView addSubview:View];

        
    }
    Pull_downClass *pull_down = [self.tableArray objectAtIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    label.text = pull_down.MingCheng;
    cell.tag = [pull_down.idStr intValue];
   

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    [self.myDelegate getResultJieguoId:[NSString stringWithFormat:@"%d",cell.tag] title:label.text tag:tableView.tag];
    
    
}


@end
