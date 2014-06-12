//
//  CVRadioCollectionCell.h
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVLabelCell.h"
#import "CVRadioCollection.h"
@interface CVRadioCollectionCell : CVLabelCell<CVRadioCollectionDelegate>
@property (nonatomic,strong) CVRadioCollection *radios;
@property (nonatomic,copy) NSString *myId;//取radio选中的值
@end
