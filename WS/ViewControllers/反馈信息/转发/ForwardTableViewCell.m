//
//  ForwardTableViewCell.m
//  WS
//
//  Created by liuqin on 14-5-4.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ForwardTableViewCell.h"

@implementation ForwardTableViewCell
@synthesize name_label;
@synthesize btn;
@synthesize idStr;
@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAction:(id)sender {
    [self.delegate changeCellBtnImage:(UIButton *)sender];
}
@end
