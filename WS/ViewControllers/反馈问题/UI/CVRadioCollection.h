//
//  CVRadioCollection.h
//  WS
//
//  Created by liuqin on 14-6-5.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVRadio.h"

@protocol CVRadioCollectionDelegate <NSObject>
- (void)selectedItemRadioIndex:(NSInteger)index sender:(id)sender source:(id)entity;
@end

@interface CVRadioCollection : UIView<CVRadioDelegate>{
    NSInteger _prevRadioTag;
}
@property (nonatomic,assign) id<CVRadioCollectionDelegate> delegate;
- (void)addRadio:(CVRadio*)radio;
@end
