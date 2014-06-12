//
//  BottonView.h
//  WS
//
//  Created by liuqin on 14-5-26.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FujianBtn.h"
#import "FujianClass.h"
#import "Global.h"
#import "FMDBClass.h"

@protocol ButtomViewZhuanfaAction <NSObject>

-(void)DownLoadAction:(FujianBtn *)fjBtn;
-(void)imageAction:(UIImage *)myimage;
-(void)zhuanfaAction;

@end


@interface BottonView : UIView

//写一下这些属性说明
@property (weak, nonatomic) IBOutlet UIButton *zhuanFaBtn; //转发按扭

@property (weak, nonatomic) IBOutlet UIImageView *bottomImage; //最下面图片
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;//下线图片
@property (weak, nonatomic) IBOutlet UIImageView *headLineImage;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel; //最上面标题
@property (weak, nonatomic) IBOutlet UILabel *huifuPersonLab;//回复人
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UIView *fujianView;//白色view
@property (assign, nonatomic)id<ButtomViewZhuanfaAction>delegate;


- (IBAction)zhuanfaAction:(id)sender;



-(void)setImagesWithArray:(NSArray*)source;
@end
