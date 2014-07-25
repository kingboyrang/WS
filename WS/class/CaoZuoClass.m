//
//  CaoZuoClass.m
//  WS
//
//  Created by liuqin on 14-5-20.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CaoZuoClass.h"
#import "NSString+TPCategory.h"
@implementation CaoZuoClass
- (CGFloat)cellHeight{
    CGFloat h=5;
    CGSize size = [self.huifuperson textSize:[UIFont systemFontOfSize:14] withWidth:320];
    h+=size.height+4;
    size = [self.content textSize:[UIFont systemFontOfSize:15] withWidth:320];
    h+=size.height+4;
    
    if ([self.HuiFuXuanXiang length]) {
        h+=21+5;
    }
    size = [self.huifutime textSize:[UIFont systemFontOfSize:14] withWidth:320];
    h+=size.height+15;
    h+=2;
    h+=5;
    return h;
    //return h<120.0f?120.0f:h;
}
@end
