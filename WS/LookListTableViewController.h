//
//  LookListTableViewController.h
//  WS
//
//  Created by liuqin on 14-5-15.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//


#import "BaseViewController.h"
@interface LookListTableViewController :BaseViewController

@property (strong, nonatomic)NSMutableArray *dataArray;

@property (strong, nonatomic) IBOutlet UITableView *lookTableView;




@end
