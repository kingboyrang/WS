//
//  CKKCViewController.h
//  WS
//
//  Created by liuqin on 14-7-17.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "CkkcCalss.h"
#import "CkkcCell.h"

@class CKFindViewController;

@interface CKKCViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableV;


@property (nonatomic, strong)NSString *CangKuID;
@property (nonatomic, strong)NSString *WuLiaoLeiXingID;
@property (nonatomic, strong)NSString *WuLiaoMingCheng;
@property (nonatomic, strong)NSString *DuQuShuLiang;

@property (nonatomic, strong)NSMutableArray *tableArr;


@end
