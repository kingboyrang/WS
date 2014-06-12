//
//  downTableView.h
//  WS
//
//  Created by liuqin on 14-5-15.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownTableCell.h"

@protocol TableViewDelegte <NSObject>

-(void)hideTableView:(int)row;

@end

@interface downTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *tableArray;

@property (nonatomic, strong)id<TableViewDelegte>myTableDelegate;

@end
