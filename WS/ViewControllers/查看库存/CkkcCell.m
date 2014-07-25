//
//  CkkcCell.m
//  WS
//
//  Created by liuqin on 14-7-17.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CkkcCell.h"
#import "NSString+TPCategory.h"

@implementation CkkcCell

- (void)awakeFromNib
{
    // Initialization code
    self.row1.numberOfLines = 0;
    self.row2.numberOfLines = 0;
    self.row3.numberOfLines = 0;
    self.row4.numberOfLines = 0;
    self.row1.lineBreakMode = NSLineBreakByWordWrapping;
    self.row2.lineBreakMode = NSLineBreakByWordWrapping;
    self.row3.lineBreakMode = NSLineBreakByWordWrapping;
    self.row4.lineBreakMode = NSLineBreakByWordWrapping;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGRect r = self.row1.frame;
    CGSize size = [self.row1.text textSize:self.row1.font withWidth:self.row1.frame.size.width];
    r.size = size;
    self.row1.frame = r;
    
    
    
    
    r = self.row2.frame;
    size = [self.row2.text textSize:self.row2.font withWidth:self.row2.frame.size.width];
    r.size = size;
    r.origin.y = self.row1.frame.origin.y + self.row1.frame.size.height;
    self.row2.frame = r;
    
    
    
    
    
    self.lineImage.frame = CGRectMake(self.lineImage.frame.origin.x, self.row2.frame.origin.y + self.row2.frame.size.height + 5, self.lineImage.frame.size.width, self.lineImage.frame.size.height);
    
    
    
    
    
    r = self.row3.frame;
    size = [self.row3.text textSize:self.row3.font withWidth:self.row3.frame.size.width];
    r.size = size;
    r.origin.y = self.lineImage.frame.origin.y + self.lineImage.frame.size.height + 5;
    self.row3.frame = r;
    
    
    
    
    
    r = self.row4.frame;
    size = [self.row4.text textSize:self.row4.font withWidth:self.row4.frame.size.width];
    r.size = size;
    r.origin.y = self.row3.frame.origin.y + self.row3.frame.size.height + 3;
    self.row4.frame = r;
}

@end
