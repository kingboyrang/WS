
//
//  SeleViewController.m
//  WS
//
//  Created by liuqin on 14-4-25.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "SeleViewController.h"

@interface SeleViewController ()

@end

@implementation SeleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BtnActionSele:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag;
    if (tag == 100) {
        FeedbackViewController *vc = [[FeedbackViewController alloc]initWithNibName:IPHONE5 ? @"FeedbackViewController": @"FeedbackViewController_3.5" bundle:nil];
         vc.messageArr = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"WHERE proid = %@",[UserInfo shareInstance].project_current_Id]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 200){
        ReseachEvaluationViewController *vc = [[ReseachEvaluationViewController alloc]initWithNibName:@"ReseachEvaluationViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 300){
        OnlineServiceViewController *vc = [[OnlineServiceViewController alloc]initWithNibName:@"OnlineServiceViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (tag == 400){
        NSString *whereStr = [NSString stringWithFormat:@"Where id = %@",[UserInfo shareInstance].project_current_Id];
        NSMutableArray *array = [[FMDBClass shareInstance]seleDate:PROJECTTABLE wherestr:whereStr];
        ProjectClass *class = [array objectAtIndex:0];
        
        if ([class.pro_ShiFouKeYiFanKui isEqualToString:@"True"]) {
            
            NSString *xibName;
            FeedbackProViewController *vc;
            if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
                xibName =IPHONE5? @"FeedbackProViewController_en":@"FeedbackProViewController_en3.5";
            }else{
                xibName =IPHONE5? @"FeedbackProViewController":@"FeedbackProViewController_3.5";
            }
            vc = [[FeedbackProViewController alloc]initWithNibName:xibName bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:nil message:@"没有权限添加反馈信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alterView show];
            
        }
        
     
    }
    else if (tag == 500){
        CKFindViewController *vc = [[CKFindViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
