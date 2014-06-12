//
//  ForwardTableViewCell.h
//  WS
//
//  Created by liuqin on 14-5-4.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForwardTableViewCellDelegate <NSObject>

-(void)changeCellBtnImage:(UIButton *)btn;

@end

@interface ForwardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic)NSString *idStr;
@property (strong, nonatomic)NSString *isSele;
@property (nonatomic, strong)id<ForwardTableViewCellDelegate>delegate;
- (IBAction)btnAction:(id)sender;

@end


