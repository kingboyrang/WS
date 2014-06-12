//
//  CVRadio.h
//  WS
//
//  Created by liuqin on 14-6-5.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CVRadioDelegate <NSObject>
- (void)selectedRadioWithSender:(id)sender;
@end

@interface CVRadio : UIView
@property (nonatomic,strong) UILabel *labName;
@property (nonatomic,strong) UIButton *button;
@property (assign) BOOL selected;//是否选中
@property (nonatomic,retain) id Entity;
@property (nonatomic,assign) id<CVRadioDelegate> delegate;
//设置选中状态
- (void)setRadioSelected:(BOOL)isSelected;
//设置radio名称
- (void)setRadioTitle:(NSString*)title source:(id)mod;
@end
