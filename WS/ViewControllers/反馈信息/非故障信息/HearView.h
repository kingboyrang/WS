//
//  HearView.h
//  WS
//
//  Created by liuqin on 14-5-26.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol HearViewDelegate <NSObject>
//
//-(void)GotoDetailVC;
//
//@end

@interface HearView : UIView
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *linetwoLable;
@property (weak, nonatomic) IBOutlet UILabel *lineThreeLabel;
//@property (assign, nonatomic)id<HearViewDelegate>delegate;
//- (IBAction)BtnAction:(id)sender;

@end
