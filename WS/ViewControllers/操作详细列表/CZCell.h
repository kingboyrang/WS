//
//  CZCell.h
//  WS
//
//  Created by liuqin on 14-5-21.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FujianClass.h"
@protocol CZCellDelegate <NSObject>

-(void)BigImage:(UIImage *)myImage;

-(void)downFileAction:(FujianClass *)fjclass;

@end



@interface CZCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *huifuiRen;//回复人
@property (weak, nonatomic) IBOutlet UILabel *huifuContent; //回复内容
@property (weak, nonatomic) IBOutlet UILabel *huifuTime; //回复时间
@property (weak, nonatomic) IBOutlet UIView *fujianView; //附件View
@property (weak, nonatomic) IBOutlet UIView *lineImage;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (assign, nonatomic)id<CZCellDelegate>delegate;

-(CGFloat)setImagesWithArray:(NSArray*)source;
@end
