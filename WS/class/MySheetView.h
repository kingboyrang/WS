//
//  MyAlterView.h
//  WS
//
//  Created by liuqin on 14-6-13.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol MySheetViewDelegte <NSObject>

-(void)MySheetAction:(int) tag;

@end



@interface MySheetView : UIView

@property (nonatomic, strong)id<MySheetViewDelegte>delegate;

- (IBAction)BtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *photeBtn;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;

@end
