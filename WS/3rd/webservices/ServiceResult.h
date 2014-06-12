//
//  ServiceResult.h
//  WS
//
//  Created by rang on 14-6-12.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceArgs.h"
#import "XmlParseHelper.h"
@interface ServiceResult : NSObject
@property (nonatomic,retain) ServiceArgs *Args;
@property (nonatomic,readonly) XmlParseHelper *xmlParse;
@property (nonatomic,copy) NSString *xml;
@property (nonatomic,readonly) NSString *xpath;
@property (nonatomic,readonly) NSString *filterXml;
@property (nonatomic,readonly) id json;
@property (nonatomic,readonly) BOOL success;//判断是否成功(表示返回的json中包含"return":"true")
+ (ServiceResult*)serviceWithArgs:(ServiceArgs*)args responseText:(NSString*)xml;
@end
