//
//  FaultCell.h
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVLabelCell.h"
#import "CVRadio.h"

@interface FaultCell : CVLabelCell
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;

@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;

@property (nonatomic, strong)NSString *seleFaultStr;
@property (nonatomic, strong)NSString *seleExitsStr;

@end
