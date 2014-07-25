//
//  FaultCell.m
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FaultCell.h"


@interface FaultCell()
@property (nonatomic,strong) UIView *bgView;

@end

@implementation FaultCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    
    _bgView=[[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor= [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];
	[self.contentView addSubview:_bgView];
    
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 30, 20)];
    self.label1.backgroundColor = [UIColor clearColor];
    self.label1.text = @"故障";
    self.label1.font = [UIFont systemFontOfSize:12.0f];
    self.label1.textColor = [Global colorWithHexString:@"#27415C"];;
    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.label1.frame.origin.x+self.label1.frame.size.width, self.label1.frame.origin.y+2, 15, 15)];
    [self.btn1 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
    [self.btn1 setImage:[UIImage imageNamed:@"yesSelefang"] forState:UIControlStateSelected];
    [self addSubview:self.label1];
    [self addSubview:self.btn1];
    
    
    
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.btn1.frame.origin.x+self.btn1.frame.size.width+20, self.label1.frame.origin.y, 55, 20)];
    self.label2.backgroundColor = [UIColor clearColor];
    self.label2.text = @"长期存在";
    self.label2.font = [UIFont systemFontOfSize:13.0f];
    self.label2.textColor = [Global colorWithHexString:@"#27415C"];;
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.label2.frame.origin.x+self.label2.frame.size.width+2, self.label2.frame.origin.y+2, 15, 15)];
    [self.btn2 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"yesSelefang"] forState:UIControlStateSelected];
    [self addSubview:self.label2];
    [self addSubview:self.btn2];
    self.label2.hidden = YES;
    self.btn2.hidden = YES;
    
    [self.btn1 addTarget:self action:@selector(buttonChkClik:) forControlEvents:UIControlEventTouchUpInside];
     [self.btn2 addTarget:self action:@selector(buttonChkClik:) forControlEvents:UIControlEventTouchUpInside];

    
    self.seleFaultStr = @"2";
    self.seleExitsStr = @"False";
    
     return self;
}
-(void)buttonChkClik:(UIButton *)btn{
    btn.selected=!btn.selected;
  
    if (btn == self.btn1) {
        if(btn.selected){
            self.label2.hidden = NO;
            self.btn2.hidden = NO;
            [self.btn2 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
            self.seleFaultStr =@"1";
             self.seleExitsStr = @"False";
        }else{
            self.label2.hidden = YES;
            self.btn2.hidden = YES;
            [self.btn2 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
            self.seleExitsStr = @"False";
            self.seleFaultStr =@"2";
        }
        
    }
    if (btn == self.btn2) {
        if (btn.selected) {
            self.seleExitsStr =@"True";
        }else{
            self.seleExitsStr = @"False";
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    _bgView.frame=CGRectMake(80, 0, self.frame.size.width, self.frame.size.height-1);

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
     }
    return self;
}

@end
