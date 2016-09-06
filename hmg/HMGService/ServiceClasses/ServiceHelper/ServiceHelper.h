//
//  ServiceHelper.h
//  HMClient
//
//  Created by Lee on 15/1/20.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"

@protocol ServiceHelperDelgate
@optional
//非队列异步请求
-(void)finishSuccessRequest:(NSData*)xml;
-(void)finishFailedRequest:(NSData*)error;
//队列异步请求
-(void)finishQueueComplete;
-(void)finishSingleRequestSuccess:(NSData*)xml userInfo:(NSDictionary*)dic;
-(void)finishSingleRequestFailed:(NSError*)error userInfo:(NSDictionary*)dic;

@end

@interface ServiceHelper : NSObject{
    ASINetworkQueue *networkQueue;
}

@property(nonatomic,assign)id<ServiceHelperDelgate> delegate;
@property(nonatomic,retain)ASIHTTPRequest *httpRequest;
//初始化
-(id)initWithDelegate:(id<ServiceHelperDelgate>)theDelegate;
/*******设置共有的请求******/
-(ASIHTTPRequest*)commonServiceRequestUrl:(NSString*)url serviceNameSpace:(NSString*)nameSapce serviceMethodName:(NSString*)methosName soapMessage:(NSString*)soapMsg;
+(ASIHTTPRequest*)commonSharedRequestMethod:(NSString*)methodName soapMessage:(NSString*)soapMsg;
+(ASIHTTPRequest*)commonSharedRequestMethod1:(NSString*)methodName soapMessage:(NSString*)soapMsg;
+(ASIHTTPRequest*)commonSharedServiceRequestUrl:(NSString*)url serviceNameSpace:(NSString*)nameSapce serviceMethodName:(NSString*)methosName soapMessage:(NSString*)soapMsg;

/*******同步请求******/
/*******异步请求******/
-(void)asynServiceRequestUrl:(NSString*)url serviceNameSpace:(NSString*)nameSpace serviceMethodName:(NSString*)methodName soapMessage:(NSString*)soapMsg;
-(void)asynServiceMethod:(NSString*)methodName soapMessage:(NSString*)soapMsg;
-(void)asynServiceMethod1:(NSString*)methodName soapMessage:(NSString*)soapMsg;


/*******队列请求******/

//添加队列
-(void)addRequestQueue:(ASIHTTPRequest*)request;
//开始队列
-(void)resetQueue;
-(void)startQueue;
-(void) cancelAllOperations;
/*******对于返回soap信息的处理******/
//-(NSString*)soapMessageResult:(ASIHTTPRequest*)request;

@end
