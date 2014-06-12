//
//  ServiceResult.m
//  WS
//
//  Created by rang on 14-6-12.
//  Copyright (c) 2014年 刘琴. All rights reserved.
//

#import "ServiceResult.h"

@interface ServiceResult ()
@property (nonatomic,retain) XmlParseHelper *xmlHelper;
@end

@implementation ServiceResult
- (NSString*)xpath{
    return [NSString stringWithFormat:@"//%@Result",self.Args.methodName];
}
- (NSString*)filterXml{
    if (_xml&&[_xml length]>0) {
        return [_xml stringByReplacingOccurrencesOfString:self.Args.serviceNameSpace withString:@""];
    }
    return  @"";
}
- (id)json{
    [self.xmlHelper setDataSource:[self filterXml]];
    XmlNode *node=[self.xmlHelper soapXmlSelectSingleNode:[self xpath]];
    if (node) {
        return [NSJSONSerialization JSONObjectWithData:[node.InnerText dataUsingEncoding:NSUTF8StringEncoding] options:1 error:nil];
    }
    return nil;
}
- (XmlParseHelper*)xmlParse{
    return self.xmlHelper;
}
+ (ServiceResult*)serviceWithArgs:(ServiceArgs*)args responseText:(NSString*)xml{
    ServiceResult *sr=[[ServiceResult alloc] init];
    sr.xml=xml;
    sr.Args=args;
    sr.xmlHelper=[[XmlParseHelper alloc] initWithData:xml];
    return sr;
}
@end
