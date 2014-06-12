//
//  BtnView.m
//  WS
//
//  Created by liuqin on 14-5-13.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BtnView.h"

@implementation BtnView
@synthesize label,btn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,frame.size.width-20, 20)];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:13.0f];
        self.label.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.label];
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-20+2, 0, 20, 20)];
        [self.btn setImage:[UIImage imageNamed:@"noSeleYuan"] forState:0];
        [self addSubview:self.btn];
    }
    return self;
}


@end
