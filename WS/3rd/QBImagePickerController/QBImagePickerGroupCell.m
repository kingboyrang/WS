//
//  QBImagePickerGroupCell.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerGroupCell.h"

// Views
#import "QBImagePickerThumbnailView.h"

@interface QBImagePickerGroupCell ()

@property (nonatomic, strong) QBImagePickerThumbnailView *thumbnailView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation QBImagePickerGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 39)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:86/255.0 alpha:1];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
        [imageView setImage:[UIImage imageNamed:@"line2"]];
        imageView.tag = 0.8;
       [self.contentView addSubview:imageView];
        
     }
    
    return self;
}


#pragma mark - Accessors

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    

    self.nameLabel.text = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
}

@end
