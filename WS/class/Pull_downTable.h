//
//  Pull_downTable.h
//  WS
//
//  Created by liuqin on 14-5-8.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pull_downClass.h"


@protocol Pull_downTableDelegate <NSObject>

-(void)getResultJieguoId:(NSString *)jieguoID title:(NSString *)titleStr;

@end
@interface Pull_downTable : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) float fondSize;
@property (nonatomic, strong)NSArray *tableArray;
@property (nonatomic, assign)id<Pull_downTableDelegate>myDelegate;

@end
