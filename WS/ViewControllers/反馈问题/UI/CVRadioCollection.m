//
//  CVRadioCollection.m
//  WS
//
//  Created by liuqin on 14-6-5.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVRadioCollection.h"

@implementation CVRadioCollection

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _prevRadioTag=-1;
    }
    return self;
}
- (void)addRadio:(CVRadio*)radio{
    NSInteger tag=[self.subviews count]+10;
    radio.tag=tag;
    radio.delegate=self;
    [self addSubview:radio];
    [self relaySubOuts];
    
}
- (void)selectedRadioWithSender:(id)sender{
    CVRadio *radio=(CVRadio*)sender;
    
    if (_prevRadioTag!=radio.tag) {
        if ([self viewWithTag:_prevRadioTag]) {
            CVRadio *radio1=(CVRadio*)[self viewWithTag:_prevRadioTag];
            [radio1 setRadioSelected:NO];
            NSLog(@"no selected");
        }
    }
    _prevRadioTag=radio.tag;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedItemRadioIndex:sender:source:)]) {
        [self.delegate selectedItemRadioIndex:radio.tag-10 sender:radio source:radio.Entity];
    }
}
- (void)relaySubOuts{
    CGFloat w=self.bounds.size.width;//总宽度
    CGFloat sepW=15;//分隔宽度
    CGFloat w1=0,topY=5,leftX=0,leftX2;
    for (UIView *item in self.subviews) {
        
        CGRect r=item.frame;
        if (w-w1>r.size.width) {
            w1+=r.size.width+sepW;
            r.origin.x=leftX;
            r.origin.y=topY;//改这里
            item.frame=r;
            leftX=w1;
        }else{
            topY+=r.size.height+10;
            w1=0;
            r.origin.x=leftX2;
            r.origin.y=topY;//改这里
            item.frame=r;
            leftX = item.frame.size.width +sepW;
        }
        CGRect rect = self.frame;
        rect.size.height  = topY + item.frame.size.height;
        self.frame = rect;
        if (rect.size.height>self.frame.size.height) {
            
        }
        
    }

}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
