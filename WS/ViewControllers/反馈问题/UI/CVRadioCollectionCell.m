//
//  CVRadioCollectionCell.m
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVRadioCollectionCell.h"
#import "BtnClass.h"

@interface CVRadioCollectionCell ()
@property (nonatomic,strong) UIView *bgView;
@end

@implementation CVRadioCollectionCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    
    _bgView=[[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor=[UIColor grayColor];
    
    _radios = [[CVRadioCollection alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-80, 78)];
    _radios.delegate=self;
    [_bgView addSubview:_radios];
    
	[self.contentView addSubview:_bgView];
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void)selectedItemRadioIndex:(NSInteger)index sender:(id)sender source:(id)entity{
    if ([entity isKindOfClass:[BtnClass class]]) {
        BtnClass *mod=(BtnClass*)entity;
        self.myId=mod.myId;
        NSLog(@"me choose radio value=%@",self.myId);
    }
}
- (void) layoutSubviews {
    [super layoutSubviews];
    
    _bgView.frame=CGRectMake(80, 0, self.frame.size.width, self.frame.size.height-2);
    CGRect r=_radios.frame;
    r.origin.y=(_bgView.frame.size.height-r.size.height)/2;
    _radios.frame=r;
}

@end
