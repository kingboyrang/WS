//
//  FaultCell.m
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "FaultCell.h"


@interface FaultCell()
@property (nonatomic,strong) UIView *bgView;

@end

@implementation FaultCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    
    _bgView=[[UIView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor=[UIColor grayColor];
    
  
    
	[self.contentView addSubview:_bgView];
    
    
    self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 40, 20)];
    self.label1.backgroundColor = [UIColor clearColor];
    self.label1.text = @"故障";
    self.label1.textColor = [UIColor whiteColor];
    self.btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.label1.frame.origin.x+self.label1.frame.size.width+2, self.label1.frame.origin.y, 20, 20)];
    [self.btn1 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
    [self.btn1 setImage:[UIImage imageNamed:@"yesSelefang"] forState:UIControlStateSelected];
    [self addSubview:self.label1];
    [self addSubview:self.btn1];
    
    
    
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(self.btn1.frame.origin.x+self.btn1.frame.size.width+20, self.label1.frame.origin.y, 80, 20)];
    self.label2.backgroundColor = [UIColor clearColor];
    self.label2.text = @"长期存在";
    self.label2.textColor = [UIColor whiteColor];
    self.btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.label2.frame.origin.x+self.label2.frame.size.width+2, self.label2.frame.origin.y, 20, 20)];
    [self.btn2 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
    [self.btn2 setImage:[UIImage imageNamed:@"yesSelefang"] forState:UIControlStateSelected];
    [self addSubview:self.label2];
    [self addSubview:self.btn2];
    self.label2.hidden = YES;
    self.btn2.hidden = YES;
    
    [self.btn1 addTarget:self action:@selector(buttonChkClik:) forControlEvents:UIControlEventTouchUpInside];
     [self.btn2 addTarget:self action:@selector(buttonChkClik:) forControlEvents:UIControlEventTouchUpInside];

    
//    
//    self.CVRadio1=[[CVRadio alloc] initWithFrame:CGRectMake(90, 5, 50, 20)];
//
//    UIImage *img=[UIImage imageNamed:@"noSelefang"];
//    [self.CVRadio1.button setImage:img forState:UIControlStateNormal];
//    [self.CVRadio1.button setImage:[UIImage imageNamed:@"yesSelefang"] forState:UIControlStateSelected];
//    CGRect r=self.CVRadio1.frame;
//    r.size=img.size;
//    self.CVRadio1.frame=r;
//    [self.CVRadio1 setRadioTitle:@"故障" source:nil];
//    [self addSubview:self.CVRadio1];
//    
//    
//    self.CVRadio2=[[CVRadio alloc] initWithFrame:CGRectMake(160, 5, 50, 20)];
//    UIImage *img2=[UIImage imageNamed:@"noSelefang"];
//    [self.CVRadio2.button setImage:img2 forState:UIControlStateNormal];
//    [self.CVRadio2.button setImage:[UIImage imageNamed:@"yesSelefang"] forState:UIControlStateSelected];
////    CGRect r2=self.CVRadio1.frame;
////    r2.size=img.size;
////    self.CVRadio2.frame=r2;
//    [self.CVRadio2 setRadioTitle:@"长期存在" source:nil];
//    self.CVRadio2.hidden = YES;
//      [self addSubview:self.CVRadio2];
//    
//    [self.CVRadio1.button addTarget:self action:@selector(buttonChkClik:) forControlEvents:UIControlEventTouchUpInside];
   
    return self;
}
-(void)buttonChkClik:(UIButton *)btn{
    btn.selected=!btn.selected;
  
    if (btn == self.btn1) {
        if(btn.selected){
            self.label2.hidden = NO;
            self.btn2.hidden = NO;
            [self.btn2 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
            self.seleFaultStr =@"1";
             self.seleExitsStr = @"False";
        }else{
            self.label2.hidden = YES;
            self.btn2.hidden = YES;
            [self.btn2 setImage:[UIImage imageNamed:@"noSelefang"] forState:UIControlStateNormal];
            self.seleExitsStr = @"False";
            self.seleFaultStr =@"2";
        }
        
    }
    if (btn == self.btn2) {
        if (btn.selected) {
            self.seleExitsStr =@"True";
        }else{
            self.seleExitsStr = @"False";
        }
    }
    

    
//    NSLog(@"exec1");
//    if (btn == self.CVRadio1.button) {
//        [self.CVRadio1 setRadioSelected:btn.selected];
//        if (self.CVRadio1.button.selected) {
//            self.CVRadio2.hidden=NO;
//            self.CVRadio2.button.selected = NO;
//        }else{
//            self.CVRadio2.hidden=YES;
//            self.CVRadio2.button.selected = NO;
//        }
//
//    }
//    if (btn.selected) {
//        NSLog(@"Yes");
//    }else{
//         NSLog(@"NO");
//    }
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    _bgView.frame=CGRectMake(80, 0, self.frame.size.width, self.frame.size.height-2);

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 


//        

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
