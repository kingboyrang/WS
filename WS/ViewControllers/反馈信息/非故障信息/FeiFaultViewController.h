//
//  FeiFaultViewController.h
//  WS
//
//  Created by liuqin on 14-5-26.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "HearView.h"
#import "BottonView.h"
#import "MessageClass.h"
#import "DetailedViewController.h"
#import "ForwardingViewController.h"
#import "FujianBtn.h"

#import "WTStatusBar.h"

#import "ImageCropper.h"

@interface FeiFaultViewController : BaseViewController<ButtomViewZhuanfaAction,ImageCropperDelegate>
{
    CGFloat _progress;
      UIImageView *imageView;
}


@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (nonatomic, strong)NSMutableArray *fujianArray;


@property (nonatomic, strong)NSString *typeStr;
@property (nonatomic, strong)NSString *FieXinXiLeiXing;
@property (nonatomic, strong)NSString *FieXinXiID;
@property (nonatomic, strong)NSString *FieFanKuiID;
@property (nonatomic, strong)NSString *FieRenYuanID;
@property (nonatomic, strong)NSString *ZuiDaJianYiID;
@property (nonatomic, strong)NSString *ZuiDaYiJianID;
@property (nonatomic, strong)NSString *JieGuoID;
@property (nonatomic, strong)NSString *JieGuoQueRenID;
@property (nonatomic, strong)NSString *PingJiaID;
@property (nonatomic, strong)NSMutableString *serverDataStr;

@end
