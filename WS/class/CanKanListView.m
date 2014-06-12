//
//  CanKanListView.m
//  WS
//
//  Created by liuqin on 14-5-27.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CanKanListView.h"

@implementation CanKanListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (IBAction)BtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"%d",btn.tag);
    [self.delegate GotoVC:btn.tag];
    
}
@end
