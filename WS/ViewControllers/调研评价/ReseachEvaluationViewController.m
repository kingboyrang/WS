//
//  ReseachEvaluationViewController.m
//  WS
//
//  Created by gwzd on 14-4-14.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ReseachEvaluationViewController.h"

@interface ReseachEvaluationViewController ()

@end

@implementation ReseachEvaluationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navView.titel_Label.text = @"调研评价";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navView.titel_Label.text = @"调研评价";
    
}
@end
