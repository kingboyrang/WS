//
//  FujianBtn.h
//  WS
//
//  Created by liuqin on 14-5-28.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FujianClass.h"
@interface FujianBtn : UIButton

@property (nonatomic, strong)NSString *fujiantype;
@property (nonatomic, strong)NSString *fujianName;
@property (nonatomic, strong)UIImage *btnImage;
@property (nonatomic, strong)NSString *Paths;
@property (nonatomic, strong)FujianClass *fjclass;



@end
