//
//  CVLabelLabelCell.m
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVLabelLabelCell.h"

@implementation CVLabelLabelCell
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _labDetail = [[UILabel alloc] initWithFrame:CGRectZero];
	_labDetail.backgroundColor = [UIColor colorWithRed:146/255.0 green:153/255.0 blue:161/255.0 alpha:1];
    _labDetail.textAlignment = NSTextAlignmentLeft;
    _labDetail.textColor = [Global colorWithHexString:@"#27415C"];;
	_labDetail.numberOfLines=0;
    _labDetail.lineBreakMode=NSLineBreakByWordWrapping;
    _labDetail.font = [UIFont systemFontOfSize:12.0f];

	[self.contentView addSubview:_labDetail];

    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void) layoutSubviews {
    [super layoutSubviews];
    
    _labDetail.frame=CGRectMake(80, 0, self.frame.size.width-80, self.frame.size.height-1);
   
}
@end
