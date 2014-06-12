//
//  CanKanListView.h
//  WS
//
//  Created by liuqin on 14-5-27.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CaKanListDelate <NSObject>

-(void)GotoVC:(int)i;

@end

@interface CanKanListView : UIView

@property (nonatomic, assign)id<CaKanListDelate>delegate;
- (IBAction)BtnAction:(id)sender;

@end
