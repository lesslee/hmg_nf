//
//  SoapHelper.m
//  HMClient
//
//  Created by Lee on 15/1/20.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "SoapHelper.h"
#import "Header.h"
#import "ObjectToXML.h"

@implementation SoapHelper
//默认soap信息
+(NSString*)defaultSoapMessage
{
    NSString *soapBody=@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>%@</soap:Body></soap:Envelope>";
    
    return soapBody;
}

//生成soap信息---- 无=无参数
+(NSString *)methodSoapMessage:(NSString *)methodName
{
    NSMutableString *soap = [NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,defaultWebServiceNameSpace];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    //NSLog(@"no parma soap =%@",soap);
    //NSLog(@"%@",[NSString stringWithFormat:[self defaultSoapMessage],soap]);
    return [NSString stringWithFormat:[self defaultSoapMessage],soap];
}
+(NSString *)methodSoapMessage1:(NSString *)methodName
{
    NSMutableString *soap = [NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\"/>",methodName,defaultWebServiceNameSpace];
    //NSLog(@"no parma soap =%@",soap);
    //NSLog(@"%@",[NSString stringWithFormat:[self defaultSoapMessage],soap]);
    return [NSString stringWithFormat:[self defaultSoapMessage],soap];
}
+(NSString *)nameSpaceSoapMessage:(NSString *)space methodName:(NSString *)methodName
{
    
    NSMutableString *soap =[NSMutableString stringWithFormat:@"<%@ xmlns=\"%@\">",methodName,space];
    [soap appendString:@"%@"];
    [soap appendFormat:@"</%@>",methodName];
    //NSLog(@"%@",[NSString stringWithFormat:[self defaultSoapMessage],soap]);
    return [NSString stringWithFormat:[self defaultSoapMessage],soap];
    
}

//生成soap信息----有参数
/*
 ***************
 arr 传递参数的 arr
 methodName 方法
 返回 msg
 ***************
 */
+(NSString *)objToDefaultSoapMessage:(id )obj
{
    NSMutableString *msg = [[NSMutableString alloc] initWithString:[ObjectToXML convert:obj]];
    
    //    NSLog(@"msg = %@",msg);
    NSString *mehtodName = [[NSString alloc] initWithFormat:@"%@",[ObjectToXML methodName:obj]];
    //    NSLog(@"%@",[NSString stringWithFormat:[self methodSoapMessage:mehtodName],msg]);
    
    return [NSString stringWithFormat:[self methodSoapMessage:mehtodName],msg];
    
}
//+(NSString *)arrayToDefaultSoapMessage:(NSArray *)arr methodName:(NSString *)methodName
//{
//    //如果传入的arr为空 或者 无参数 调用无参方法
//    if ([arr count] == 0 || arr == nil) {
//        return [NSString stringWithFormat:[self methodSoapMessage:methodName],@""];
//    }
//    NSMutableString *msg = [NSMutableString stringWithFormat:@""];
//    for(NSDictionary *item in arr){
//        NSString *key = [[item allKeys] objectAtIndex:0];
//        [msg appendFormat:@"<%@>",key];
//        [msg appendString:[item objectForKey:key]];
//        [msg appendFormat:@"</%@>",key];
//
//    }
//    NSLog(@"msg = %@",msg);
//    NSLog(@"===========msg==============");
//    NSLog(@"%@",[NSString stringWithFormat:[self methodSoapMessage:methodName],msg]);
//    return [NSString stringWithFormat:[self methodSoapMessage:methodName],msg];
//
//}

+(NSString *)arratToNameSpaceSoapMessage:(NSString *)space params:(NSArray *)arr methodName:(NSString *)methodName
{
    //如果传入的arr为空 或者 无参数 调用无参方法
    if ([arr count] == 0 || arr == nil) {
        return [NSString stringWithFormat:[self nameSpaceSoapMessage:space methodName:methodName],@""];
    }
    NSMutableString *msg = [NSMutableString stringWithFormat:@""];
    for (NSDictionary *item in arr) {
        NSString *key =[[item allKeys] objectAtIndex:0];
        [msg appendFormat:@"<%@>",key];
        [msg appendString:[item objectForKey:key]];
        [msg appendFormat:@"</%@>",key];
    }
    //NSLog(@"===========msg==============");
    //NSLog(@"%@",[NSString stringWithFormat:[self methodSoapMessage:methodName],msg]);
    return [NSString stringWithFormat:[self nameSpaceSoapMessage:space methodName:methodName],msg];
}

@end
