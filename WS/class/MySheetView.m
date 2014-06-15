//
//  MyAlterView.m
//  WS
//
//  Created by liuqin on 14-6-13.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "MySheetView.h"

@implementation MySheetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
   
    }
    return self;
}



- (IBAction)BtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self.delegate MySheetAction:btn.tag];

}
@end
