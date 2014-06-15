//
//  FeedbackProViewController.h
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceRequestManager.h" //soap请求
#import "Global.h"
#import "UserInfo.h"
#import "Header.h"
#import "Header.h"

#import "CVRadioCollection.h"
#import "CVLabelLabelCell.h"
#import "CVRadioCollectionCell.h"
#import "CVTextViewCell.h"
@interface FeedbackProViewController : BaseViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,CVRadioCollectionDelegate,CVRadioDelegate,CVTextViewCellDelegate>

{
    NSMutableArray *zhuanyebtnArr;
    NSMutableArray *wentijibieArr;
    CGFloat cellH;
    NSString *lauguageStr;
    
    
    CVLabelLabelCell *cell5;
}


@property (weak, nonatomic) IBOutlet UITableView *faultTableV;


@property (nonatomic, strong)NSMutableString *jsonStr;
//@property (weak, nonatomic) IBOutlet UILabel *currentProLabel;

@property (nonatomic, strong)NSString *seleZuanYeStr;
@property (nonatomic, strong)NSString *seleWenTiJiBieStr;
@property (nonatomic, strong)NSString *seleFaultStr;
@property (nonatomic, strong)NSString *seleExitsStr;



@property (nonatomic, strong)NSMutableArray *ZhuanYeBtnArr;
@property (nonatomic, strong)NSMutableArray *WenTiJiBieArr;
@property (nonatomic, strong)NSMutableArray *cells;



- (IBAction)SeleImageAction:(id)sender;

- (IBAction)submitAction:(id)sender;

@end
