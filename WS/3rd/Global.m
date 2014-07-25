//
//  Global.m
//  weishiDemo
//
//  Created by apple  on 14-3-5.
//  Copyright (c) 2014年 apple . All rights reserved.
//

#import "Global.h"
#import "FMDBClass.h"
#import "MessageClass.h"
#import "PersonInfoClass.h"
#import "UserInfo.h"
#import "ProjectClass.h"
#import "PerSonClass.h"
#import "CaoZuoClass.h"
@implementation Global

+(NSString *)xiaoxiType:(NSString *)type{
    NSString *message;
    if ([type isEqualToString:@"1"]) {
        message = @"自己反馈";
    }else if ([type isEqualToString:@"2"]) {
        message = @"接受反馈";
    }else if ([type isEqualToString:@"3"]){
        message = @"建议";
    }else if ([type isEqualToString:@"4"]){
        message = @"意见";
    }else if ([type isEqualToString:@"5"]){
        message = @"结果";
    }else if ([type isEqualToString:@"6"]){
        message = @"确认";
    }else if ([type isEqualToString:@"7"]){
        message = @"评价";
    }
    return message;
}

+(NSString *)tishiMessage:(NSString *)resultMessage//当检测到return的值为false时，根据以下代码给出相应提示。
{

    NSString *message;
    if ([resultMessage isEqualToString:@"000"]) {
//        message = @"信息提交成功 ，威视人员会在72小时对您注册信息进行审合，请耐心等待";
    }else if ([resultMessage isEqualToString:@"101"]){
        message = @"数据传输失败";
    }else if ([resultMessage isEqualToString:@"102"]){
        message = @"用户名称已存在";
    }else if ([resultMessage isEqualToString:@"103"]){
        message = @"公司名称不存在";
    }else if ([resultMessage isEqualToString:@"104"]){
        message = @"手机号或邮箱已注册";
    }else if ([resultMessage isEqualToString:@"105"]){
        message = @"服务器错误";
    }else if ([resultMessage isEqualToString:@"201"]){
        message = @"用户信息不存在";
    }else if ([resultMessage isEqualToString:@"202"]){
        message = @"用户没有所属项目信息";
    }else if ([resultMessage isEqualToString:@"301"]){
        message = @"用户名不存在或所填写邮箱不是注册邮箱！";
    }else if ([resultMessage isEqualToString:@"302"]){
         message = @"服务器错误，密码修改失败！";
    }

    return message;

}
+(NSString *)isFault:(NSString *)str{
    NSString *resutstr;
    if ([str isEqualToString:@"1"]) {
        resutstr = @"是故障";
    }else if ([str isEqualToString:@"2"]){
         resutstr = @"非故障";
    }
    return resutstr;
}
+(NSString *)readState:(NSString *)str  //阅读状态
{
    NSString *stateStr;
    if ([str isEqualToString:@"1"]) {
        stateStr = @"未阅读";
    }else if ([str isEqualToString:@"2"]){
        stateStr = @"已阅读";
    }
    return stateStr;
}
+(NSString *)dealState:(NSString *)str  //处理状态
{
    NSString *stateStr;
    if ([str isEqualToString:@"1"]) {
        stateStr = @"处理中";
    }else if ([str isEqualToString:@"2"]){
        stateStr =  @"已处理";
    }
    return stateStr;
}
//返回正确的json格式
+(NSDictionary *)GetjsonStr:(NSString *)str{
    NSString * responseString = str;
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSError *err;
    NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];      //json解析 转成 data
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:1 error:&err];
    return jsonDic;
}

+(NSMutableArray *)resultArray:(NSDictionary *)jsonDic :(int) i  :(NSString *)type : (CaoZuoClass *)czClass where:(NSString *)whereStr
{

    NSMutableArray *messageArr = [[NSMutableArray alloc]init];
       
        switch (i) {
            case 1:    //信息表
            {
                NSDictionary *proDic = [jsonDic objectForKey:@"XiangMuList"];
                if (proDic.count > 0)
                {

                    for (NSDictionary *dic in proDic)
                    {
                    
                        MessageClass *messClass = [[MessageClass alloc]init];
                        messClass.XinXi_ID = [dic objectForKey:@"XinXiID"];
                        messClass.XinXi_type = [dic objectForKey:@"XinXiLeiXing"];
                        messClass.XinXi_BiaoHao = [dic objectForKey:@"BianHao"];
                        messClass.XinXi_Biaoti = [dic objectForKey:@"XinXiBiaoTi"];
                        messClass.XinXi_ZhuanYe = [dic objectForKey:@"ZhuanYe"];
                        messClass.XinXi_WenTiJiBie = [dic objectForKey:@"WenTiJiBie"];
                        messClass.XinXi_read_state = [dic objectForKey:@"YueDuZhuangTai"];
                        messClass.XinXi_deal_state = [dic objectForKey:@"ChuLiZhuangTai"];
                        messClass.XinXi_FaBuShiJian = [dic objectForKey:@"FaBuShiJian"];
                        messClass.XinXi_FaQiRen = [dic objectForKey:@"FaQiRen"];
                        messClass.XinXi_faqi_role = [dic objectForKey:@"FaQiRenJueSe"];
                        messClass.XinXi_huifu_person = [dic objectForKey:@"HuiFuRen"];
                        messClass.XinXi_huifu_role = [dic objectForKey:@"HuiFuRenJueSe"];
                        messClass.XinXi_huifutime = [dic objectForKey:@"HuiFuShiJian"];
                        messClass.XinXi_contants = [dic objectForKey:@"XiaoXiGaiYao"];
                        messClass.XinXi_jianyi = [dic objectForKey:@"JianYiCaoZuo"];
                        messClass.XinXi_yijian = [dic objectForKey:@"YiJianCaoZuo"];
                        messClass.XinXi_result = [dic objectForKey:@"JieGuoCaoZuo"];
                        messClass.XinXi_result_submit = [dic objectForKey:@"JieGuoQueRenCaoZuo"];
                        messClass.XinXi_pingjia = [dic objectForKey:@"PinJiaCaoZuo"];
                        messClass.XinXi_forwarding = [dic objectForKey:@"ZhuanFaCaoZuo"];
                        messClass.XinXi_proName =[dic objectForKey:@"XiangMuMingCheng"];
                        messClass.XinXi_proid = [dic objectForKey:@"XiangMuID"];
                        messClass.XinXi_faultid = [dic objectForKey:@"FanKuiXinXiID"];
                        messClass.XinXi_JieShouZhuanFaID = [dic objectForKey:@"ZhuanFaXinXiID"];

                        
                        NSArray *array = [[NSArray alloc]initWithObjects:messClass.XinXi_ID,messClass.XinXi_type,messClass.XinXi_Biaoti, messClass.XinXi_BiaoHao,messClass.XinXi_ZhuanYe,messClass.XinXi_WenTiJiBie,messClass.XinXi_read_state,messClass.XinXi_deal_state,messClass.XinXi_FaBuShiJian,messClass.XinXi_FaQiRen,messClass.XinXi_faqi_role,messClass.XinXi_huifu_person,messClass.XinXi_huifu_role,messClass.XinXi_contants,messClass.XinXi_jianyi,messClass.XinXi_yijian,messClass.XinXi_result,messClass.XinXi_result_submit,messClass.XinXi_pingjia,messClass.XinXi_forwarding,messClass.XinXi_faultid,messClass.XinXi_proName,messClass.XinXi_proid,messClass.XinXi_huifutime,messClass.XinXi_JieShouZhuanFaID, nil];
                        
                        if ([[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:[NSString stringWithFormat:@"where id = %@ and falutid = %@ and proid = %@ and type = %@",messClass.XinXi_ID,messClass.XinXi_faultid,messClass.XinXi_proid,messClass.XinXi_type]].count < 1)           //判断是否重复记录
                        {
                          
                            [messageArr addObject:messClass];
                            [[FMDBClass shareInstance]insertDate:INFOTABLE date:array :@""]; //INFOTABLE表中添加数据
                        }
                    }
                }
                
            }
                break;
              case 2://个人信息
            {
                [UserInfo shareInstance].companyName = [jsonDic objectForKey:@"GongSiJianCheng"];
                [UserInfo shareInstance].passWord = [jsonDic objectForKey:@"MiMa"];
                [UserInfo shareInstance].userId = [jsonDic objectForKey:@"renYuanID"];
                [UserInfo shareInstance].phoneStr = [jsonDic objectForKey:@"ShouJiHao"];
                [UserInfo shareInstance].emailStr = [jsonDic objectForKey:@"YouXiang"];
                [UserInfo shareInstance].userName = [jsonDic objectForKey:@"YongHuMing"];
             
                [[NSUserDefaults standardUserDefaults]setObject:[UserInfo shareInstance].userId forKey:USERID];
                [[NSUserDefaults standardUserDefaults]setObject:[UserInfo shareInstance].userName forKey:USERNAME];
                [[NSUserDefaults standardUserDefaults]setObject:[UserInfo shareInstance].passWord forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults]setObject:[UserInfo shareInstance].companyName forKey:COMPANYNAME];
                [[NSUserDefaults standardUserDefaults]setObject:[UserInfo shareInstance].phoneStr forKey:PHONESTR];
                [[NSUserDefaults standardUserDefaults]setObject:[UserInfo shareInstance].emailStr forKey:EMAILSTR];
                [[NSUserDefaults standardUserDefaults] synchronize];

                
                
                NSArray *proArr = [jsonDic objectForKey:@"XiangMuList"];
                for (NSDictionary *dic in proArr) {
                    ProjectClass *proClass = [[ProjectClass alloc]init];
                    proClass.pro_id = [dic objectForKey:@"XiangMuID"];
                    proClass.pro_bianhao = [dic objectForKey:@"XiangMuBianHao"];
                    proClass.pro_jiancheng = [dic objectForKey:@"XiangMuJianCheng"];
                    proClass.pro_quancheng = [dic objectForKey:@"XiangMuQuanCheng"];
                    proClass.WeiChuLiShuLiang = [dic objectForKey:@"WeiChuLiShuLiang"];
                    proClass.WeiDuShuLiang = [dic objectForKey:@"WeiDuShuLiang"];
                    proClass.pro_ShiFouKeYiFanKui = [dic objectForKey:@"ShiFouKeYiFanKui"];
                    NSArray *arr = [[NSArray alloc]initWithObjects:proClass.pro_id,proClass.pro_jiancheng,proClass.pro_quancheng,proClass.pro_bianhao,proClass.WeiChuLiShuLiang,proClass.WeiDuShuLiang,proClass.pro_ShiFouKeYiFanKui, nil];
                    if ([[FMDBClass shareInstance]seleDate:PROJECTTABLE wherestr:[NSString stringWithFormat:@"where id = %@",proClass.pro_id]].count < 1) {
                        [[FMDBClass shareInstance]insertDate:PROJECTTABLE date:arr :@""];
                       
                    }
                }   //项目组信息

                 messageArr = [[FMDBClass shareInstance]seleDate:PROJECTTABLE wherestr:@""]; //取INFOTABLE表中所有的记录返回
            }
                break;
            case 3: //项目人员列表 PRO_PERSON_INFOTABLE
            {
                NSArray *personArr = [jsonDic objectForKey:@"XiangMuRenYuanList"];
                for (NSDictionary *dic in personArr) {
                    PerSonClass *person = [[PerSonClass alloc]init];
                    person.RenYuanID = [dic objectForKey:@"RenYuanID"];
                    person.XingMing = [dic objectForKey:@"XingMing"];
                    person.RenYuanJueSeMiaoShu = [dic objectForKey:@"RenYuanJueSeMiaoShu"];
                    person.FenZhi = [dic objectForKey:@"FenZhi"];
                    NSArray *array = @[person.RenYuanID,person.XingMing,person.RenYuanJueSeMiaoShu,person.FenZhi];
                    if ([[FMDBClass shareInstance]seleDate:PRO_PERSON_INFOTABLE wherestr:[NSString stringWithFormat:@"where RenYuanID = %@",person.RenYuanID]].count < 1)           //判断是否重复记录
                    {
                        [[FMDBClass shareInstance]insertDate:PRO_PERSON_INFOTABLE date:array :@""]; //PRO_PERSON_INFOTABLE表中添加数据
                        
                        
                    }
            
                }
                messageArr = [[FMDBClass shareInstance]seleDate:PRO_PERSON_INFOTABLE wherestr:@""]; //取INFOTABLE表中所有的记录返回

                
            }
                break;
            case 4: //故障详细信息
            {
                NSArray *arry = [jsonDic objectForKey:@"FanKuiXinXi"];
                NSDictionary *infoDic = [arry objectAtIndex:0];
                MessageClass *messClass = [[MessageClass alloc]init];
                messClass.XinXi_ID = [infoDic objectForKey:@"XinXiID"];
                messClass.XinXi_faultid = [infoDic objectForKey:@"FanKuiXinXiID"];
                messClass.XinXi_type = [infoDic objectForKey:@"XinXiLeiXing"];
                messClass.XinXi_faultType = [infoDic objectForKey:@"FanKuiXinXiLeiXing"];
                messClass.XinXi_BiaoHao = [infoDic objectForKey:@"FanKuiXinXiBianHao"];
                messClass.XinXi_Biaoti = [infoDic objectForKey:@"XinXiBiaoTi"];
                messClass.XinXi_ZhuanYe = [infoDic objectForKey:@"ZhuanYe"];
                messClass.XinXi_WenTiJiBie = [infoDic objectForKey:@"WenTiJiBie"];
                messClass.XinXi_read_state = [infoDic objectForKey:@"YueDuZhuangTai"];
                messClass.XinXi_deal_state = [infoDic objectForKey:@"ChuLiZhuangTai"];
                messClass.XinXi_FaBuShiJian = [infoDic objectForKey:@"FaBuShiJian"];
                messClass.XinXi_FaQiRen = [infoDic objectForKey:@"FaQiRen"];
                messClass.XinXi_faqi_role = [infoDic objectForKey:@"FaQiRenJueSe"];
                messClass.XinXi_contants = [infoDic objectForKey:@"FanKuiNeiRong"];
                messClass.XinXi_yijian = [infoDic objectForKey:@"YiJianCaoZuo"];
                messClass.XinXi_jianyi = [infoDic objectForKey:@"JianYiCaoZuo"];
                messClass.XinXi_result = [infoDic objectForKey:@"JieGuoCaoZuo"];
                messClass.XinXi_result_submit = [infoDic objectForKey:@"JieGuoQueRenCaoZuo"];
                messClass.XinXi_pingjia = [infoDic objectForKey:@"PinJiaCaoZuo"];
                messClass.XinXi_forwarding = [infoDic objectForKey:@"ZhuanFaCaoZuo"];
                messClass.XinXi_proid = [infoDic objectForKey:@"XiangMuID"];
                messClass.XinXi_proName = [infoDic objectForKey:@"XiangMuMingCheng"];
                
                NSArray *array = @[ messClass.XinXi_ID,messClass.XinXi_faultid,messClass.XinXi_type,messClass.XinXi_faultType,messClass.XinXi_BiaoHao, messClass.XinXi_Biaoti,messClass.XinXi_ZhuanYe,messClass.XinXi_WenTiJiBie,messClass.XinXi_read_state,messClass.XinXi_deal_state,messClass.XinXi_FaBuShiJian,messClass.XinXi_FaQiRen,messClass.XinXi_faqi_role,messClass.XinXi_contants,messClass.XinXi_yijian,messClass.XinXi_jianyi,messClass.XinXi_result,messClass.XinXi_result_submit,messClass.XinXi_pingjia,messClass.XinXi_forwarding,messClass.XinXi_proid,messClass.XinXi_proName];
                if ([[FMDBClass shareInstance]seleDate:DETALEDTABLE wherestr:[NSString stringWithFormat:@"where faultid = %@ and proid = %@ and fankuiXinxiType = %@",messClass.XinXi_faultid,messClass.XinXi_proid,messClass.XinXi_faultType]].count < 1)           //判断是否重复记录
                {
                    [[FMDBClass shareInstance]insertDate:DETALEDTABLE date:array :@""]; //表中添加数据
                }
                
                   NSArray *fujianArray = [infoDic objectForKey:@"FanKuiXinXiFuJian"];
                for (NSDictionary *dic in fujianArray) {
                    FujianClass *fujianC = [[FujianClass alloc]init];
                    fujianC.fujianorgid = [infoDic objectForKey:@"XinXiID"];
                    fujianC.fujianproid =  [infoDic objectForKey:@"XiangMuID"];
                    fujianC.fujianfaultid = [infoDic objectForKey:@"FanKuiXinXiID"];
                    fujianC.fujianFaultType = [infoDic objectForKey:@"FanKuiXinXiLeiXing"];
                    fujianC.fujianMessageType = [infoDic objectForKey:@"XinXiLeiXing"];
                    fujianC.fujianid = [dic objectForKey:@"FanKuiXinXiFuJianID"];
                    fujianC.fujiantype = [dic objectForKey:@"FanKuiXinXiFuJianLeiXing"];
                    fujianC.fujianName = [dic objectForKey:@"FanKuiXinXiFuJianMingCheng"];
                   fujianC.fujianPaths =[NSString stringWithFormat:@"%@%@",URLHEADER, [dic objectForKey:@"FanKuiXinXiFuJianDiZhi"]];
                    
                    if ([fujianC.fujiantype isEqualToString:@"1"]) {
                        
                        
                        NSURL *url = [NSURL URLWithString:fujianC.fujianPaths];
                        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
                        
                        
                        NSDate *  senddate=[NSDate date];
                        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                        [dateformatter setDateFormat:@"YYYYMMddhhmmssSSS"];
                        NSString *  locationString=[dateformatter stringFromDate:senddate]; //当前时间
                        
                        
                        //Document
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                        /*写入图片*/
                        //帮文件起个名
                        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",locationString,fujianC.fujianName]];
                        //将图片写到Documents文件中
                        [UIImagePNGRepresentation(image)writeToFile: uniquePath    atomically:YES];
                        
                        fujianC.fujianbendiPath = uniquePath;
                    }else{
                        fujianC.fujianbendiPath = @"";
                    }
                    NSArray *fujianArray = @[fujianC.fujianorgid,fujianC.fujianproid,fujianC.fujianfaultid,fujianC.fujianFaultType,fujianC.fujianMessageType,fujianC.fujianid,fujianC.fujiantype,fujianC.fujianName,fujianC.fujianPaths,fujianC.fujianbendiPath,@""];
                    if ([[FMDBClass shareInstance]seleDate:IMAGETABLE wherestr:[NSString stringWithFormat:@"where proid = %@ and faultid = %@ and faultType = %@ and id = %@ and type = %@  and orgid = %@",fujianC.fujianproid,fujianC.fujianfaultid,fujianC.fujianFaultType,fujianC.fujianid,fujianC.fujiantype,fujianC.fujianorgid]].count < 1)           //判断是否重复记录
                    {
                        [[FMDBClass shareInstance]insertDate:IMAGETABLE date:fujianArray :@""]; //IMAGETABLE表中添加数据
                    }
                }
                
                
                messageArr = [[FMDBClass shareInstance]seleDate:DETALEDTABLE wherestr:[NSString stringWithFormat:@"where faultid = %@",messClass.XinXi_faultid]]; //取INFOTABLE表中所有的记录返回

            }
                break;
            case 5://操作表
            {
                NSArray *XinXiListarry = [jsonDic objectForKey:@"XinXiList"];
                for (NSDictionary *dic in XinXiListarry) {
                    CaoZuoClass *myClass = [[CaoZuoClass alloc]init];
                    myClass.xinxiType = type;
                    myClass.xinxiID = [dic objectForKey:@"XinXiID"];
                    myClass.huifuperson = [dic objectForKey:@"HuiFuRen"];
                    myClass.huifutime = [dic objectForKey:@"HuiFuShiJian"];
                    myClass.content = [dic objectForKey:@"NeiRong"];
                    myClass.HuiFuXuanXiang = [dic objectForKey:@"HuiFuXuanXiang"];
                    myClass.huifurole = @"";
                    myClass.fautlid = czClass.fautlid;
                    myClass.bianhao = czClass.bianhao;
                    myClass.biaoti = czClass.biaoti;
                    myClass.zhuanye = czClass.zhuanye;
                    myClass.wentijiBie = czClass.wentijiBie;
                    myClass.read_state = czClass.read_state;
                    myClass.deal_state = czClass.deal_state;
                    myClass.fabutime = czClass.fabutime;
                    myClass.faqirole = czClass.faqirole;
                    myClass.faqiperson = czClass.faqiperson;
                    myClass.faultContent = czClass.faultContent;
                 
                    NSArray *array = @[myClass.xinxiType,myClass.xinxiID,myClass.fautlid,myClass.bianhao,myClass.biaoti,myClass.zhuanye,myClass.wentijiBie,myClass.read_state,myClass.deal_state,myClass.fabutime,myClass.faqiperson,myClass.faqirole,myClass.huifuperson,myClass.huifurole,myClass.huifutime,myClass.faultContent,myClass.content,myClass.HuiFuXuanXiang,czClass.proId,czClass.faultType];
                   
                    if ([[FMDBClass shareInstance]seleDate:CZTABLE wherestr:[NSString stringWithFormat:@"where fautlid = %@ and xinxiType = %@ and xinxiID = %@ and proid = %@ and faultType = %@",myClass.fautlid,myClass.xinxiType,myClass.xinxiID,czClass.proId,czClass.faultType]].count < 1)           //判断是否重复记录
                    {
                        [[FMDBClass shareInstance]insertDate:CZTABLE date:array :@""]; //PRO_PERSON_INFOTABLE表中添加数据
                    }
                      NSArray *fujianArray = [dic objectForKey:@"FuJian"];
                    for (NSDictionary *fujiandic in fujianArray) {
                        FujianClass *fujianC = [[FujianClass alloc]init];
                        fujianC.fujianorgid = [dic objectForKey:@"XinXiID"];
                        fujianC.fujianproid =  czClass.proId;
                        fujianC.fujianfaultid = czClass.fautlid;
                        fujianC.fujianFaultType = czClass.faultType;
                        fujianC.fujianMessageType = type;
                        fujianC.fujianid = [fujiandic objectForKey:@"FuJianID"];
                        fujianC.fujiantype = [fujiandic objectForKey:@"FuJianLeiXing"];
                        fujianC.fujianName = [fujiandic objectForKey:@"FuJianMingCheng"];
                        fujianC.fujianPaths = [NSString stringWithFormat:@"%@%@",URLHEADER,[fujiandic objectForKey:@"FuJianDiZhi"]];
                        if ([fujianC.fujiantype isEqualToString:@"1"]) {
                            NSURL *url = [NSURL URLWithString:fujianC.fujianPaths];
                            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
                            
                            //Document
                            NSDate *  senddate=[NSDate date];
                            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                            [dateformatter setDateFormat:@"YYYYMMddhhmmssSSS"];
                            NSString *  locationString=[dateformatter stringFromDate:senddate]; //当前时间
                            
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                            /*写入图片*/
                            //帮文件起个名
                            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",locationString,fujianC.fujianName]];
                            //将图片写到Documents文件中
                            [UIImagePNGRepresentation(image)writeToFile: uniquePath    atomically:YES];
                            
                            fujianC.fujianbendiPath = uniquePath;
                        }else{
                            fujianC.fujianbendiPath = @"";
                        }
                       
                        
                        NSArray *fujianArray = @[fujianC.fujianorgid,fujianC.fujianproid,fujianC.fujianfaultid,fujianC.fujianFaultType,fujianC.fujianMessageType,fujianC.fujianid,fujianC.fujiantype,fujianC.fujianName,fujianC.fujianPaths,fujianC.fujianbendiPath,@""];
                        if ([[FMDBClass shareInstance]seleDate:IMAGETABLE wherestr:[NSString stringWithFormat:@"where proid = %@ and faultid = %@ and faultType = %@ and id = %@ and type = %@  and orgid = %@",fujianC.fujianproid,fujianC.fujianfaultid,fujianC.fujianFaultType,fujianC.fujianid,fujianC.fujiantype,fujianC.fujianorgid]].count < 1)           //判断是否重复记录
                        {
                            [[FMDBClass shareInstance]insertDate:IMAGETABLE date:fujianArray :@""]; //IMAGETABLE表中添加数据
                        }
                        
                    }
                }
                messageArr = [[FMDBClass shareInstance]seleDate:CZTABLE wherestr:[NSString stringWithFormat:@"where xinxiType = %@ and proid = %@",type,[UserInfo shareInstance].project_current_Id]]; //取INFOTABLE表中所有的记录返回
                
            }
                break;
            case 6:
            {
                
            }
                break;
            case 7:
            {
                
            }
                break;
            case 8:
            {
                
            }
                break;
            case 9:
            {
                
            }
                break;
            default:
                break;
        }



    return messageArr;

}
//最大值
+(int)TableName:(NSString *)tabName where:(NSString *)seleStr isFault: (BOOL)isfault zuidaZhuanfa:(BOOL)zhuanfa;
{
    int retrunid = 0;
    
    if (isfault) {
        NSMutableArray *dataArray = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:seleStr];
        for (MessageClass *class in dataArray) {
            retrunid = retrunid >= [class.XinXi_faultid intValue] ? retrunid:[class.XinXi_faultid intValue];
        }
        
    }else {
        NSMutableArray *dataArray = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:seleStr];
        
        for (MessageClass *class in dataArray) {
            retrunid = retrunid >= [class.XinXi_ID intValue] ? retrunid:[class.XinXi_ID intValue];
        }
    }
    
    if (zhuanfa) {
        NSMutableArray *dataArray = [[FMDBClass shareInstance]seleDate:INFOTABLE wherestr:seleStr];
        
        for (MessageClass *class in dataArray) {
            retrunid = retrunid >= [class.XinXi_JieShouZhuanFaID intValue] ? retrunid:[class.XinXi_JieShouZhuanFaID intValue];
        }
    }
    return retrunid;
}
+(void)downloadWithImageURL:(NSURL *)url callback:(void (^)(UIImage *, NSError *))callback
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:10];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (data && !connectionError) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   callback(image, nil);
                               } else {
                                   callback(nil, connectionError);
                               }
                           }
     ];
}
//设置数据库附件文件路径
+(NSString*)FilePaths:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"imageFile"];
    NSString *imagePath = [NSString stringWithFormat:@"%@%@",dbPath,imageName];
    
    return imagePath;
}
+ (NSString*)getPreferredLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



@end
