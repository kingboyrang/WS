//
//  FindViewController.h
//  WS
//
//  Created by liuqin on 14-5-20.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "Global.h"
#import "CaoZuoClass.h"
#import "CZCell.h"
#import "WTStatusBar.h"
#import "ServiceRequestManager.h" //soap请求

#import "ImageCropper.h"

@interface FindViewController :BaseViewController<UITableViewDataSource,UITableViewDelegate,ImageCropperDelegate,CZCellDelegate>
{
    CGFloat _progress;
    UIImageView *imageView;

}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong)NSMutableArray *showContentArr;


@property (nonatomic, strong)NSString *selfTilteStr;
@property (nonatomic, strong)NSString *dataType;
@property (nonatomic, strong)NSString *myfaultID;
@property (nonatomic, strong)NSString *FanKuiXinXiLeiXing;
@property (nonatomic, strong)NSMutableString *serverJsonStr;
@property (nonatomic, strong)CaoZuoClass *czClass;
@property (nonatomic, strong)NSMutableArray *heightArray;
@property (nonatomic, strong)NSMutableArray *tableArray;

@end
