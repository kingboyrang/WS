//
//  CVRadio.m
//  WS
//
//  Created by liuqin on 14-6-5.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVRadio.h"
#import "NSString+TPCategory.h"
@implementation CVRadio

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        _labName=[[UILabel alloc] initWithFrame:CGRectZero];
        _labName.backgroundColor=[UIColor clearColor];
        _labName.font=[UIFont boldSystemFontOfSize:14];
        _labName.textColor=[UIColor whiteColor];
        [self addSubview:_labName];
        
        self.selected=NO;
        
        UIImage *img=[UIImage imageNamed:@"noSeleYuan"];
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(0, 0, 20, 20);

//        _button.frame=CGRectMake(0, 0, img.size.width, img.size.height);
        [_button setImage:img forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"yesSeleYuan"] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(buttonChkClick:) forControlEvents:UIControlEventTouchUpInside];
        _button.selected=NO;
        [self addSubview:_button];
    }
    return self;
}
- (void)setRadioSelected:(BOOL)isSelected{
    _button.selected=isSelected;
    self.selected=isSelected;
}
- (void)setRadioTitle:(NSString*)title source:(id)mod{
    _labName.text=title;
    self.Entity=mod;
    [self relaySubViewOut];
}
- (void)buttonChkClick:(UIButton*)btn{

    btn.selected=YES;
    self.selected=btn.selected;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedRadioWithSender:)]){
        [self.delegate selectedRadioWithSender:self];
    }
}
- (void)relaySubViewOut{
    CGRect r=_button.frame;
    CGSize size=[_labName.text textSize:_labName.font withWidth:320-r.size.width];
    CGFloat h=size.height>r.size.height?size.height:r.size.height;
    _labName.frame=CGRectMake(0,(h-size.height)/2, size.width, size.height);
    
    r.origin.x=_labName.frame.size.width+_labName.frame.origin.x+2;
    r.origin.y=(h-r.size.height)/2;
    
    _button.frame=r;
    
    r=self.frame;
    r.size.height=h;
    r.size.width=_button.frame.origin.x+_button.frame.size.width;
    self.frame=r;
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
