//
//  ShowImageView.m
//  WS
//
//  Created by liuqin on 14-5-9.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ShowImageView.h"

@implementation ShowImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor =  [UIColor colorWithRed:214/255.0 green:215/255.0 blue:219/255.0 alpha:1];
        self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        self.scrollview.backgroundColor = [UIColor clearColor];
        self.scrollview.pagingEnabled = YES;
        self.scrollview.showsHorizontalScrollIndicator = YES;
        self.scrollview.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollview];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
