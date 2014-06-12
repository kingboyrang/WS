//
//  BaseViewController.h
//  WS
//
//  Created by gwzd on 14-4-1.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ServiceRequestManager.h"
#import "UserInfo.h"
#import "JSONKit.h"
#import "FujianClass.h"
#import "ShowImageView.h"
#import "Global.h"

#import "XmlParseHelper.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS7_OR_GREATER(...)
#endif


@interface BaseViewController : UIViewController<NacViewDelegate,UITextViewDelegate,UIActionSheetDelegate,QBImagePickerControllerDelegate>


@property (nonatomic, strong)NSString *xiangmuId;
@property (nonatomic, strong)NSString *fankuiId;
@property (nonatomic, strong)UIImageView *bgImageView;

@property (nonatomic, strong)ShowImageView *imageScrollView;

@property (nonatomic, strong)UIView *toolbar;
@property (nonatomic, strong)NavView *navView;

@property (nonatomic, strong)NSMutableArray *fujianArray; //选择图片的信息数组
@property (nonatomic, strong)NSMutableString *fujianResultStr;
@property (nonatomic, strong)NSString *xinxiType;
@property (nonatomic, strong)NSMutableArray *sendFujianArray;//向服务发送的数组

@property (nonatomic, strong)UITextView *myTextView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIImageView *lineImageView;


-(void)chooseImage;
-(void)SubmitAction;
-(void)sendMessage:(NSString *)base64string  fileName:(NSString *)fileName completed:(void(^)())finished;
@end
