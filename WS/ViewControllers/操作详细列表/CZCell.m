//
//  CZCell.m
//  WS
//
//  Created by liuqin on 14-5-21.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CZCell.h"
#import "FujianClass.h"
#import "FujianBtn.h"
#import "FMDBClass.h"
#import "Global.h"
#import "NSString+TPCategory.h"

@implementation CZCell

@synthesize huifuiRen,huifuContent,huifuTime;

- (void)awakeFromNib
{
    // Initialization code
    self.huifuContent.numberOfLines=0;
    self.huifuContent.lineBreakMode=NSLineBreakByWordWrapping;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(void)layoutSubviews{
    [super layoutSubviews];

    CGRect r = self.huifuiRen.frame;
    CGSize size = [self.huifuiRen.text textSize:self.huifuiRen.font withWidth:r.size.width];
    r.origin.y=5;
    r.size.height=size.height;
    self.huifuiRen.frame = r;
    NSLog(@"huifuiRen frame=%@",NSStringFromCGRect(r));
    
    
    r = self.huifuContent.frame;
    size = [self.huifuContent.text textSize:self.huifuContent.font withWidth:self.bounds.size.width];
    r.size = size;
    r.origin.y = self.huifuiRen.frame.origin.y + self.huifuiRen.frame.size.height +4;
    self.huifuContent.frame = r;
    
    
    r = self.label.frame;
    if (self.label.text.length == 0) {
        size = CGSizeMake(280, 0);
    }else{
     size = self.label.frame.size;
    }
    r.size = size;
    self.label.textAlignment = NSTextAlignmentRight;
    r.origin.y = self.huifuContent.frame.origin.y + self.huifuContent.frame.size.height + 4;
    self.label.frame = r;
    
    
    CGFloat topY = self.label.frame.origin.y + self.label.frame.size.height + 5;
    r = self.fujianView.frame;
    r.origin.y = topY;
    if ([self.fujianView.subviews count] == 0) {
        r.size.height = 0;
    }else{
        topY += r.size.height + 5;
    }
    self.fujianView.frame = r;
    
    
   r = self.huifuTime.frame;
    size = [self.huifuTime.text textSize:self.huifuTime.font withWidth:self.bounds.size.width];
    r.size = size;
    r.origin.y = topY +15;
    self.huifuTime.frame = r;
    
    r = self.lineImage.frame;
    r.origin.y = self.huifuTime.frame.origin.y + self.huifuTime.frame.size.height + 4;
    self.lineImage.frame = r;

    
    r=self.frame;
    r.size.height=self.lineImage.frame.origin.y+self.lineImage.frame.size.height+5;
    self.frame=r;
}

-(CGFloat)setImagesWithArray:(NSArray*)source{
    CGFloat hight=0.0;
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
    
    for (int i = 0; i< fjimageArrary.count;i++) {
        FujianClass *fj = [[FujianClass alloc]init];
        fj = [fjimageArrary objectAtIndex:i];
        FujianBtn *fujianBtn = [[FujianBtn alloc]initWithFrame:CGRectMake(10,hight,160, 80)];
        fujianBtn.backgroundColor = [UIColor clearColor];
        fujianBtn.fjclass = fj;
        /*读取入图片*/
        //因为拿到的是个路径，所以把它加载成一个data对象
        NSData *data=[NSData dataWithContentsOfFile:fj.fujianbendiPath];
        UIImage *image = [UIImage imageWithData:data];
        //直接把该图片读出来
        if (data.length == 0) {
            image = [UIImage imageNamed:@"test"];
            [fujianBtn setImage:image forState:0];
        }else{
            image = [UIImage imageWithData:data];
            [fujianBtn setImage:image forState:0];
        }
        fujianBtn.btnImage = image;
        [fujianBtn addTarget:self action:@selector(imageAction:) forControlEvents:UIControlEventTouchUpInside];
        hight += 90;
        [self.fujianView addSubview:fujianBtn];
        
        
        
    }
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
        [fujianBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.fujianView addSubview:fujianBtn];
        hight += 25;
        
    }
    CGRect r=self.fujianView.frame;
    r.size.height=hight;
    
    self.fujianView.frame = r;
    [self setNeedsLayout];
    return self.fujianView.frame.size.height;
}
-(void)btnAction:(FujianBtn *)btn{
    [self.delegate downFileAction:btn.fjclass];
}
-(void)imageAction:(FujianBtn *)btn{
    [self.delegate BigImage:btn.btnImage];
}
@end
