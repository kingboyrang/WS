//
//  BottonView.m
//  WS
//
//  Created by liuqin on 14-5-26.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "BottonView.h"
#import "NSString+TPCategory.h"


@implementation BottonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentLabel.numberOfLines=0;
        self.contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
        
    }
    return self;
}
- (IBAction)zhuanfaAction:(id)sender {
    [self.delegate zhuanfaAction];
}

-(void)setImagesWithArray:(NSMutableArray *)source{
  __block  CGFloat hight=0.0;
    ///把图片添加写到这里面的
    NSMutableArray *fjimageArrary = [[NSMutableArray alloc]init];
    NSMutableArray *fjfileArray = [[NSMutableArray alloc]init];
    for (int i = 0;i < source.count; i++) {
        FujianClass *fjclass = [[FujianClass alloc]init];
        fjclass = [source objectAtIndex:i];
        if ([fjclass.fujiantype isEqualToString:@"1"]) { //图片
            [fjimageArrary addObject:fjclass];
        }
        else
        {
            [fjfileArray addObject:fjclass];
        }
    }
    
     dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i< fjimageArrary.count;i++) {
        FujianClass *fj = [[FujianClass alloc]init];
        fj = [fjimageArrary objectAtIndex:i];
        FujianBtn *fujianBtn = [[FujianBtn alloc]init];
        fujianBtn.backgroundColor = [UIColor clearColor];
       
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:fj.fujianPaths];
            NSData *data = [NSData dataWithContentsOfURL:url];
          __block UIImage *image = [UIImage imageWithData:data];
            fujianBtn.btnImage = image;
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    fujianBtn.frame = CGRectMake(10, hight + 10, 240, image.size.height*240/image.size.width);
                    [fujianBtn setImage:image forState:0];
                    hight += fujianBtn.frame.size.height ;
                    [self.fujianView addSubview:fujianBtn];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    fujianBtn.frame = CGRectMake(10, hight +10, 120, 100);
                    [fujianBtn setImage:[UIImage imageNamed:@"test"] forState:0];
                    hight += fujianBtn.frame.size.height ;
                    [self.fujianView addSubview:fujianBtn];
                });
            }
            
            [fujianBtn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        });

    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        hight += 20;
        for (int i = 0; i< fjfileArray.count;i++) {
            FujianClass *fj = [[FujianClass alloc]init];
           
            fj = [fjfileArray objectAtIndex:i];
             CGSize size = [fj.fujianName textSize:[UIFont systemFontOfSize:12.0f] withWidth:self.frame.size.width - 20];
            FujianBtn *fujianBtn = [[FujianBtn alloc]initWithFrame:CGRectMake(10, hight ,size.width, 25)];
            fujianBtn.fjclass = fj;
            fujianBtn.backgroundColor = [UIColor clearColor];
            [fujianBtn setTitleColor:[UIColor whiteColor] forState:0];
            [fujianBtn setTitle:fj.fujianName forState:0];
            fujianBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [fujianBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.fujianView addSubview:fujianBtn];
            hight += 25;
            
        }

    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        CGRect r=self.fujianView.frame;
        r.size.height=hight;
        self.fujianView.frame = r;
         [self setNeedsLayout];
    });
 

    //fujianView加了内容后，可能高度会变记得重设frame
    //表示重新布～～～over
   
}
-(void)imageBtnAction:(FujianBtn *)btn{
    
    [self.delegate imageAction:btn.btnImage];
}
-(void)BtnAction:(FujianBtn *)btn{
    [self.delegate DownLoadAction:btn];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect r=self.typeLabel.frame;
   CGSize size=[self.typeLabel.text textSize:self.typeLabel.font withWidth:r.size.width];
    self.typeLabel.frame=r;

    
    r=self.headLineImage.frame;
    r.origin.y=self.typeLabel.frame.origin.y+self.typeLabel.frame.size.height+4;
    self.headLineImage.frame=r;
    
    
    r=self.huifuPersonLab.frame;
    size=[self.huifuPersonLab.text textSize:self.huifuPersonLab.font withWidth:self.bounds.size.width];
    r.size=size;
    r.origin.y=self.headLineImage.frame.origin.y+self.headLineImage.frame.size.height+2;
    self.huifuPersonLab.frame=r;
    
    
     r=self.contentLabel.frame;
     size=[self.contentLabel.text textSize:self.contentLabel.font withWidth:r.size.width];
    r.size=size;
    r.origin.y=self.huifuPersonLab.frame.origin.y+self.huifuPersonLab.frame.size.height+2;
    self.contentLabel.frame=r;
    
    CGFloat topY=self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height+5;
    //
    r=self.fujianView.frame;
    r.origin.y=topY;
    if ([self.fujianView.subviews count]==0) {//表示没有子元素
        r.size.height=0;
    }else{
        topY+=r.size.height+5;
    }
    self.fujianView.frame=r;

    
    
    r=self.timeLabel.frame;
    size=[self.timeLabel.text textSize:self.timeLabel.font withWidth:self.bounds.size.width];
    r.size=size;
    r.origin.y=topY+15;
    self.timeLabel.frame=r;
    
    r=self.zhuanFaBtn.frame;
    r.origin.y=topY+5;
    self.zhuanFaBtn.frame=r;
    
    r=self.lineImage.frame;
    r.origin.y=self.zhuanFaBtn.frame.size.height+self.zhuanFaBtn.frame.origin.y+5;
    self.lineImage.frame=r;
    
    r=self.bottomImage.frame;
    r.origin.y=self.lineImage.frame.size.height+self.lineImage.frame.origin.y+5;
    self.bottomImage.frame=r;
   
    
    r=self.frame;
    r.size.height=self.bottomImage.frame.origin.y+self.bottomImage.frame.size.height+(182-166);  //182 是什么 166 是什么。。。
    
    self.frame=r;
    
   
    
    if([[self superview] isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView=(UIScrollView*)[self superview];
        //重设contextSize
        scrollView.contentSize=CGSizeMake(320, self.frame.origin.y+r.size.height);
    }

//    这里已经发生改变了〜〜〜
    NSLog(@"self frame=%@",NSStringFromCGRect(r));
}

@end
