//
//  FaultCellTableViewCell.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FaultCellTableViewCell.h"

@implementation FaultCellTableViewCell

@synthesize messLabel;
@synthesize BiaoHao;
@synthesize FaBuShijian;
@synthesize ZhuanYe;
@synthesize Deal_state;
@synthesize FaQiRen;

//@synthesize sugbtn; //建议
//@synthesize advbtn; //意见
//@synthesize reslutbtn; //结果
//@synthesize pingjiaban; //评价
//@synthesize forwardbtn; //转发
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
