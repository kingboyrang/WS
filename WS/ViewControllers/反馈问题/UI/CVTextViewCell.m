//
//  CVTextViewCell.m
//  WS
//
//  Created by liuqin on 14-6-6.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "CVTextViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation CVTextViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(!(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    _textView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectZero];
	
    _textView.font = [UIFont systemFontOfSize:12.0f];

    _textView.delegate = self;

    _textView.returnKeyType = UIReturnKeyDone;
    _textView.backgroundColor=[UIColor colorWithRed:192/255.0 green:195/255.0 blue:200/255.0 alpha:1.0];
    
      if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
          _textView.placeholder =  @" Please fill in the ...";
       }else{
           _textView.placeholder = @" 请填写...";
       }
	[self.contentView addSubview:_textView];
    

    self.backgroundColor=[UIColor grayColor];
    
    return self;
}
- (id) initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	return self;
}
- (void) layoutSubviews {
    [super layoutSubviews];

       _textView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.placeholderBtn.frame = _textView.frame;
    
}
#pragma mark textView
-(void)textViewDidBeginEditing:(UITextView *)textView{
    id v=[self superview];
    do{
        v=[v superview];
    }while(![v isKindOfClass:[UITableView class]]);
    UITableView *table = (UITableView *)v;
    table.frame = CGRectMake(0, -100, 320, 448);
 }

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        id v=[self superview];
        do{
            v=[v superview];
        }while(![v isKindOfClass:[UITableView class]]);
        UITableView *table = (UITableView *)v;
        table.frame = CGRectMake(0, 60, 320, 448);
        return NO;
    }
    return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if ([[Global getPreferredLanguage] isEqualToString:@"en"]) {
         [self.delegate ChangeSuzi:[NSString stringWithFormat:@" The words limitation has %d character left",1000-number]];
    }else{
        [self.delegate ChangeSuzi:[NSString stringWithFormat:@" 字数限制还剩%d字",1000-number]];
    }
  
    if (number > 1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"字符个数不能大于1000" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:128];
        number = 1000;
    }
}

@end
