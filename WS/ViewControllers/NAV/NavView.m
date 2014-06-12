//
//  NavView.m
//  WS
//
//  Created by liuqin on 14-4-25.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "NavView.h"

@implementation NavView

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


- (IBAction)Actionbtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
    
}
@end
