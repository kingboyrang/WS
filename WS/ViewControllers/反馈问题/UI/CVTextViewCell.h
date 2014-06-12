//
//  CVTextViewCell.h
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CVTextViewCellDelegate <NSObject>

-(void)ChangeSuzi:(NSString *)str;

@end


@interface CVTextViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) UITextView *textView;


@property (nonatomic, strong)id<CVTextViewCellDelegate>delegate;
@end
