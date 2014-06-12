//
//  DetailedViewController.h
//  WS
//
//  Created by liuqin on 14-5-12.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "Global.h"
#import "MessageClass.h"
#import "FMDBClass.h"
#import "FindViewController.h"
#import "CaoZuoClass.h"
#import "FujianBtn.h"

#import "ForwardingViewController.h"
#import "SuggectionViewController.h"
#import "AddviceViewController.h"
#import "ResultViewController.h"
#import "AddPingjiaViewController.h"
#import "AddSubmitViewController.h"

#import "WTStatusBar.h"
#import "ImageCropper.h"
@interface DetailedViewController : BaseViewController<ImageCropperDelegate>

{
    CGFloat _progress;

        UIImageView *imageView;
  

}

@property (weak, nonatomic) IBOutlet UILabel *biaohao_lab;
@property (weak, nonatomic) IBOutlet UILabel *time_lab;
@property (weak, nonatomic) IBOutlet UILabel *fault_lab;
@property (weak, nonatomic) IBOutlet UILabel *state_lab;

@property (weak, nonatomic) IBOutlet UIScrollView *faultScrollView;


@property (nonatomic, strong)NSString *xinxi_type;
@property (nonatomic, strong)NSString *xinxi_id;
@property (nonatomic, strong)NSString *xinxi_currentFaultId;
@property (nonatomic, strong)NSString *zhuanFaID;


@property (nonatomic, strong)NSMutableString *resultJsonStr;

@property (nonatomic, strong)MessageClass *myMessageClass;




@end
