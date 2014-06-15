//
//  CVLabelCell.m
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVLabelCell.h"

@interface CVLabelCell ()
@property (nonatomic,strong) UILabel *labLine;//畫線
@end


@implementation CVLabelCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    _labTitle.textColor = [UIColor whiteColor];
	_labTitle.numberOfLines=0;
    _labTitle.lineBreakMode=NSLineBreakByWordWrapping;
    _labTitle.font = [UIFont systemFontOfSize:15.0f];
    //70,101,132
    _labTitle.backgroundColor=[UIColor colorWithRed:70/255.0 green:101/255.0 blue:132/255.0 alpha:1.0];
	[self.contentView addSubview:_labTitle];
    
    
    _labLine = [[UILabel alloc] initWithFrame:CGRectZero];
	_labLine.backgroundColor = [UIColor whiteColor];

    
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    
	//CGSize size=[_labTitle.text textSize:_labTitle.font withWidth:80];
    _labTitle.frame=CGRectMake(0, 0, 80, self.frame.size.height-2);
    _labLine.frame=CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2);
}

@end
