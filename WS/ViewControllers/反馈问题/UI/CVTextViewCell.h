//
//  CVTextViewCell.h
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCPlaceholderTextView.h"

@protocol CVTextViewCellDelegate <NSObject>

-(void)ChangeSuzi:(NSString *)str;

@end


@interface CVTextViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) GCPlaceholderTextView *textView;
//@property (nonatomic, strong)UIButton *placeholderBtn;

@property (nonatomic, strong)id<CVTextViewCellDelegate>delegate;
@end
