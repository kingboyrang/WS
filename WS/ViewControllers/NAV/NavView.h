//
//  NavView.h
//  WS
//
//  Created by liuqin on 14-4-25.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NacViewDelegate <NSObject>

-(void)back;

@end

@interface NavView : UIView

@property (nonatomic, weak)id<NacViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *titel_Label;

- (IBAction)Actionbtn:(id)sender;

@end
