//
//  NSString+TPCategory.m
//  WS
//
//  Created by liuqin on 14-5-28.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "NSString+TPCategory.h"

@implementation NSString (TPCategory)
//获取文本大小
-(CGSize)textSize:(UIFont*)f withWidth:(CGFloat)w{
    return  [self sizeWithFont:f constrainedToSize:CGSizeMake(w, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}
@end
