//
//  ProCell.h
//  WS
//
//  Created by liuqin on 14-5-16.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectClass.h"

@interface ProCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cellBtn;

@property (strong, nonatomic)ProjectClass *proClass;

@end
