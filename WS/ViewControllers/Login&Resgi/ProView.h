//
//  ProView.h
//  WS
//
//  Created by liuqin on 14-5-16.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProCell.h"
#import "ProjectClass.h"
@protocol ProViewDelegate <NSObject>

-(void)selePro:(ProjectClass *)proclass;

@end

@interface ProView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *proTableVew;
@property (nonatomic, strong)NSMutableArray *tableArray;
@property (nonatomic, assign)id<ProViewDelegate>seleDelegate;
- (void)makeTableViewCGReframe:(int) x :(int) y :(int) w :(int) h;

@end
