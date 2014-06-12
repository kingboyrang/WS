//
//  FMDBClass.m
//  weishiDemo
//
//  Created by apple  on 14-3-11.
//  Copyright (c) 2014年 apple . All rights reserved.
//

#import "FMDBClass.h"
#import "MessageClass.h"
#import "ProjectClass.h"
#import "CaoZuoClass.h"
#import "UserInfo.h"

#define kDatabaseName @"DB.sqlite"


@implementation FMDBClass

+(FMDBClass *)shareInstance{
   
    static FMDBClass *aFMDBClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aFMDBClass = [[self alloc]init];
    });
    return aFMDBClass;
}
-(id)init{
    self = [super init];
    if (self) {
        db = [[FMDatabase alloc]initWithPath:[self FilePaths]];
        if (![db open]) {
            NSLog(@"open faile");
        }
        [self createTable];
    }
    return self;
}

//设置数据库文件路径
-(NSString*)FilePaths{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:kDatabaseName];
      NSLog(@"%@",dbPath);
    return dbPath;
  
}


#pragma mark 创建数据表
-(void)createTable{
    if ([db open]) {
        [db beginTransaction];//使用事物处理
        // 反馈信息id,项目id
        [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id text,type text,Biaoti text,bianhao text,zhuanye text,wentijibie text,read_state text,deal_state text,fabu_time text,faqi_person text,faqi_role text,huifu_person text,huifu_role text,contants text,suggested text,advice text,result text,result_submit text,pingjia text,forwarding text,falutid text,proname text,proid text,huifutime text,zhuanfaId text)",INFOTABLE]];
        
        [db executeUpdate:[NSString stringWithFormat:@"create table IF NOT EXISTS %@ (id text,short text,full text,code text,state text,read text)",PROJECTTABLE]];
        
        [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(orgid text,proid text,faultid text,faultType text,messType text,id text,type text,name text,path text,bendiPath text)",IMAGETABLE]];
        
        [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(RenYuanID text,XingMing text,RenYuanJueSeMiaoShu text,FenZhi text)",PRO_PERSON_INFOTABLE]];
        //主表
        [db executeUpdate:[NSString stringWithFormat:@"create table IF NOT EXISTS %@ (xinxiType text,xinxiID text,fautlid text,bianhao text,biaoti text,zhuanye text,wentijiBie text,read_state text,deal_state text,fabutime text,faqiperson text,faqirole text,huifuperson text,huifurole text,huifutime text,faultContent text,content text,HuiFuXuanXiang text,proid text,faultType text)",CZTABLE]] ;
        //反馈表
        [db  executeUpdate:[NSString stringWithFormat:@"create table IF NOT EXISTS %@ (xinxiid text,faultid text,type text,fankuiXinxiType text,bianhao text,biaoti text,zhuanye text,wentijibie text,readState text,dealState text,fabutime text,faqiren text,faqirole text,faultContant text,jianyi text,yijian text,result text,resultsubmit text,pingjia text,zhuangfa text,proid text,proname text)",DETALEDTABLE]] ;
        [db commit];
        [db close];
    }

}

#pragma mark 添加信息
-(void)insertDate:(NSString *)tableName date:(NSArray *)array : (NSString *)userid{
    if( [db open]) {
        NSString *sql;
        NSMutableString *Str = [[NSMutableString alloc]init];
        for (int i = 0; i < [array count]; i++) {
            NSString *obj = [array objectAtIndex:i];
            [Str appendFormat:@"\"%@\",",obj];
        }
        NSString *valueStr = [Str substringToIndex:[Str length]-1];
        //列表
        if ([tableName isEqualToString:INFOTABLE]) {
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (id ,type ,Biaoti ,bianhao ,zhuanye ,wentijibie ,read_state ,deal_state ,fabu_time ,faqi_person ,faqi_role ,huifu_person ,huifu_role ,contants ,suggested ,advice ,result ,result_submit ,pingjia ,forwarding ,falutid ,proname ,proid ,huifutime,zhuanfaId ) VALUES (%@)",tableName,valueStr];
        }
        //项目表
        else if ([tableName isEqualToString:PROJECTTABLE]){
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (id,short,full,code,state ,read ) VALUES (%@)",tableName,valueStr];
            
        }
        //附件表
        else if ([tableName isEqualToString:IMAGETABLE]){
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (orgid ,proid ,faultid ,faultType ,messType ,id ,type ,name ,path ,bendiPath ) VALUES (%@)",tableName,valueStr];
        }
        //项目人员表
        else if ([tableName isEqualToString:PRO_PERSON_INFOTABLE]){
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (RenYuanID,XingMing,RenYuanJueSeMiaoShu,FenZhi) VALUES (%@)",tableName,valueStr];
        }
        //主表
        else if ([tableName isEqualToString:CZTABLE]){
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (xinxiType,xinxiID,fautlid,bianhao,biaoti,zhuanye,wentijiBie,read_state,deal_state,fabutime,faqiperson,faqirole,huifuperson,huifurole,huifutime,faultContent,content,HuiFuXuanXiang,proid,faultType)VALUES (%@)",tableName,valueStr];
            
        }
        //故障表
        else if ([tableName isEqualToString:DETALEDTABLE]){
            sql = [NSString stringWithFormat:@"INSERT INTO %@ (xinxiid,faultid,type,fankuiXinxiType,bianhao,biaoti,zhuanye,wentijibie,readState,dealState,fabutime,faqiren,faqirole,faultContant,jianyi,yijian,result,resultsubmit,pingjia,zhuangfa,proid,proname) VALUES (%@)",tableName,valueStr];
        }
        [db executeUpdate:sql];
    }
    [db close];
}

#pragma mark 更新
-(void)UpData:(NSString *)tableName setStr:(NSString *)setStr  whereStr:(NSString *)whereStr{
    
     if ([db open]) {
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,setStr,whereStr]];
        [db close];
    }

}

#pragma mark 查询是否已经收藏
-(NSMutableArray *)seleDate:(NSString *)tableName  wherestr:(NSString *)str {
        NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    if ([db open]) {
    
        NSString *seleSql= [NSString stringWithFormat:@"select * from %@ %@",tableName,str];
//        NSLog(@"查询语句-------->\n%@\n\n\n",seleSql);
        FMResultSet *resultSet = [db executeQuery:seleSql];
        //项目表
        if ([tableName isEqualToString:PROJECTTABLE])
        {
            while ([resultSet next]) {
                ProjectClass *proClass = [[ProjectClass alloc]init];
                proClass.pro_id = [resultSet stringForColumn:@"id"];
                proClass.pro_jiancheng = [resultSet stringForColumn:@"short"];
                proClass.pro_quancheng = [resultSet stringForColumn:@"full"];
                proClass.pro_bianhao = [resultSet stringForColumn:@"code"];
                proClass.WeiChuLiShuLiang = [resultSet stringForColumn:@"state"];
                proClass.WeiDuShuLiang = [resultSet stringForColumn:@"read"];
                [resultArr addObject:proClass];
            }
        }
        //项目人员表
        else if ([tableName isEqualToString:PRO_PERSON_INFOTABLE])
        {
            
            while ([resultSet next]) {
                
                NSString *person_id = [resultSet stringForColumn:@"RenYuanID"];
                NSString *_XingMing = [resultSet stringForColumn:@"XingMing"];
                NSString *_RenYuanJueSeMiaoShu = [resultSet stringForColumn:@"RenYuanJueSeMiaoShu"];
                NSString *_FenZhi = [resultSet stringForColumn:@"FenZhi"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setValue:person_id forKey:@"id"];
                [dic setValue:_XingMing forKey:@"name"];
                [dic setValue:_RenYuanJueSeMiaoShu forKey:@"role"];
                [dic setValue:_FenZhi forKey:@"fenzhi"];
                
                [resultArr addObject:dic];
            }
        }
        //信息列表
        else if ([tableName isEqualToString:INFOTABLE])
        {
            
            while ([resultSet next]) {
                MessageClass *messClass = [[MessageClass alloc]init];
                messClass.XinXi_ID = [resultSet stringForColumn:@"id"];
                messClass.XinXi_type = [resultSet stringForColumn:@"type"];
                messClass.XinXi_Biaoti = [resultSet stringForColumn:@"Biaoti"];
                messClass.XinXi_BiaoHao = [resultSet stringForColumn:@"bianhao"];
                messClass.XinXi_ZhuanYe = [resultSet stringForColumn:@"zhuanye"];
                messClass.XinXi_WenTiJiBie = [resultSet stringForColumn:@"wentijibie"];
                messClass.XinXi_read_state = [resultSet stringForColumn:@"read_state"];
                messClass.XinXi_deal_state = [resultSet stringForColumn:@"deal_state"];
                messClass.XinXi_FaBuShiJian = [resultSet stringForColumn:@"fabu_time"];
                messClass.XinXi_FaQiRen = [resultSet stringForColumn:@"faqi_person"];
                messClass.XinXi_faqi_role = [resultSet stringForColumn:@"faqi_role"];
                messClass.XinXi_huifu_person = [resultSet stringForColumn:@"huifu_person"];
                messClass.XinXi_huifu_role = [resultSet stringForColumn:@"huifu_role"];
                messClass.XinXi_contants = [resultSet stringForColumn:@"contants"];
                messClass.XinXi_jianyi = [resultSet stringForColumn:@"suggested"];
                messClass.XinXi_yijian = [resultSet stringForColumn:@"advice"];
                messClass.XinXi_result = [resultSet stringForColumn:@"result"];
                messClass.XinXi_result_submit = [resultSet stringForColumn:@"result_submit"];
                messClass.XinXi_pingjia = [resultSet stringForColumn:@"pingjia"];
                messClass.XinXi_forwarding = [resultSet stringForColumn:@"forwarding"];
                messClass.XinXi_faultid =[resultSet stringForColumn:@"falutid"];
                messClass.XinXi_proName =[resultSet stringForColumn:@"proname"];
                messClass.XinXi_proid =[resultSet stringForColumn:@"proid"];
                messClass.XinXi_huifutime =[resultSet stringForColumn:@"huifutime"];
                messClass.XinXi_JieShouZhuanFaID = [resultSet stringForColumn:@"zhuanfaId"];
                [resultArr addObject:messClass];
            }
        }
        //主表
        else if ([tableName isEqualToString:CZTABLE])
        {
            while ([resultSet next]) {
                CaoZuoClass *myClass = [[CaoZuoClass alloc]init];
                myClass.xinxiType = [resultSet stringForColumn:@"xinxiType"];
                myClass.xinxiID = [resultSet stringForColumn:@"xinxiID"];
                myClass.fautlid = [resultSet stringForColumn:@"fautlid"];
                myClass.bianhao = [resultSet stringForColumn:@"bianhao"];
                myClass.biaoti = [resultSet stringForColumn:@"biaoti"];
                myClass.zhuanye = [resultSet stringForColumn:@"zhuanye"];
                myClass.wentijiBie = [resultSet stringForColumn:@"wentijiBie"];
                myClass.read_state =[resultSet stringForColumn:@"read_state"];
                myClass.deal_state =[resultSet stringForColumn:@"deal_state"];
                myClass.fabutime = [resultSet stringForColumn:@"fabutime"];
                myClass.faqiperson = [resultSet stringForColumn:@"faqiperson"];
                myClass.faqirole = [resultSet stringForColumn:@"faqirole"];
                myClass.huifuperson = [resultSet stringForColumn:@"huifuperson"];
                myClass.huifurole = [resultSet stringForColumn:@"huifurole"];
                myClass.huifutime = [resultSet stringForColumn:@"huifutime"];
                myClass.faultContent = [resultSet stringForColumn:@"faultContent"];
                myClass.content = [resultSet stringForColumn:@"content"];
                myClass.HuiFuXuanXiang =[resultSet stringForColumn:@"HuiFuXuanXiang"];
                myClass.proId = [resultSet stringForColumn:@"proid"];
                myClass.faultType = [resultSet stringForColumn:@"faultType"];
                [resultArr addObject:myClass];
            }
        }
        //反馈表
        else if ([tableName isEqualToString:DETALEDTABLE]){
            while ([resultSet next]) {
                MessageClass *messClass = [[MessageClass alloc]init];
                messClass.XinXi_ID = [resultSet stringForColumn:@"xinxiid"];
                messClass.XinXi_faultid = [resultSet stringForColumn:@"faultid"];
                messClass.XinXi_type = [resultSet stringForColumn:@"type"];
                messClass.XinXi_faultType = [resultSet stringForColumn:@"fankuiXinxiType"];
                messClass.XinXi_BiaoHao = [resultSet stringForColumn:@"bianhao"];
                messClass.XinXi_Biaoti = [resultSet stringForColumn:@"biaoti"];
                messClass.XinXi_ZhuanYe = [resultSet stringForColumn:@"zhuanye"];
                messClass.XinXi_WenTiJiBie = [resultSet stringForColumn:@"wentijibie"];
                messClass.XinXi_read_state = [resultSet stringForColumn:@"readState"];
                messClass.XinXi_deal_state = [resultSet stringForColumn:@"dealState"];
                messClass.XinXi_FaBuShiJian = [resultSet stringForColumn:@"fabutime"];
                messClass.XinXi_FaQiRen = [resultSet stringForColumn:@"faqiren"];
                messClass.XinXi_faqi_role = [resultSet stringForColumn:@"faqirole"];
                messClass.XinXi_contants = [resultSet stringForColumn:@"faultContant"];
                messClass.XinXi_yijian = [resultSet stringForColumn:@"jianyi"];
                messClass.XinXi_jianyi = [resultSet stringForColumn:@"yijian"];
                messClass.XinXi_result = [resultSet stringForColumn:@"result"];
                messClass.XinXi_result_submit = [resultSet stringForColumn:@"resultsubmit"];
                messClass.XinXi_pingjia = [resultSet stringForColumn:@"pingjia"];
                messClass.XinXi_forwarding =  [resultSet stringForColumn:@"zhuangfa"];
                messClass.XinXi_proid =  [resultSet stringForColumn:@"proid"];
                messClass.XinXi_proName = [resultSet stringForColumn:@"proname"];
                
                [resultArr addObject:messClass];
            }
        }
        //附件表
        else if ([tableName isEqualToString:IMAGETABLE]){
            while ([resultSet next]) {
                FujianClass *fjClass = [[FujianClass alloc]init];
                fjClass.fujianorgid = [resultSet stringForColumn:@"orgid"];
                fjClass.fujianproid = [resultSet stringForColumn:@"proid"];
                fjClass.fujianfaultid = [resultSet stringForColumn:@"faultid"];
                fjClass.fujianFaultType = [resultSet stringForColumn:@"faultType"];
                fjClass.fujianMessageType = [resultSet stringForColumn:@"messType"];
                fjClass.fujianid = [resultSet stringForColumn:@"id"];
                fjClass.fujiantype = [resultSet stringForColumn:@"type"];
                fjClass.fujianName = [resultSet stringForColumn:@"name"];
                fjClass.fujianPaths = [resultSet stringForColumn:@"path"];
                fjClass.fujianbendiPath = [resultSet stringForColumn:@"bendiPath"];
                [resultArr addObject:fjClass];
            }
            
        }
        [db close];
    }
        return resultArr;
}



@end
