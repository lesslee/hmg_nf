//
//  SoapHelper.h
//  HMClient
//
//  Created by Lee on 15/1/20.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoapHelper : NSObject

//默认soap信息
+(NSString*) defaultSoapMessage;

//生成soap信息---无参数
+(NSString*)methodSoapMessage:(NSString*)methodName;
+(NSString*)methodSoapMessage1:(NSString*)methodName;
+(NSString*)nameSpaceSoapMessage:(NSString*)space methodName:(NSString*)methodName;


//生成soap信息---有参数
+(NSString*)objToDefaultSoapMessage:(id)obj;
+(NSString*)arratToNameSpaceSoapMessage:(NSString*)space params:(NSArray*)arr methodName:(NSString*)methodName;

@end
