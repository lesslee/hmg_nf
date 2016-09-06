//
//  ServiceHelper.m
//  HMClient
//
//  Created by Lee on 15/1/20.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import "ServiceHelper.h"
#import "Header.h"

@implementation ServiceHelper
@synthesize delegate,httpRequest;

#pragma mark-
#pragma mark 初始化操作
-(id)initWithDelegate:(id<ServiceHelperDelgate>)theDelegate
{
    if (self = [super init]) {
        self.delegate = theDelegate;
        
    }
    return self;
}
#pragma mark-
#pragma  mark 获取共有请求的ASIhttprequest
+(ASIHTTPRequest*)commonSharedRequestMethod:(NSString*)methodName soapMessage:(NSString*)soapMsg{
    return [self commonSharedServiceRequestUrl:serviceUrl serviceNameSpace:defaultWebServiceNameSpace serviceMethodName:methodName soapMessage:soapMsg];
}


+(ASIHTTPRequest*)commonSharedRequestMethod1:(NSString*)methodName soapMessage:(NSString*)soapMsg{
    return [self commonSharedServiceRequestUrl:serviceUrl1 serviceNameSpace:defaultWebServiceNameSpace serviceMethodName:methodName soapMessage:soapMsg];
}

+(ASIHTTPRequest*)commonSharedServiceRequestUrl:(NSString*)url serviceNameSpace:(NSString*)nameSapce serviceMethodName:(NSString*)methosName soapMessage:(NSString*)soapMsg{
    NSURL *webUrl=[NSURL URLWithString:url];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:webUrl];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [request addRequestHeader:@"Host" value:[webUrl host]];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request addRequestHeader:@"Content-Length" value:msgLength];
    [request addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",nameSapce,methosName]];
    [request setRequestMethod:@"POST"];
    //设置用户信息
    //[request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:methosName,@"name", nil]];
    //传soap信息
    [request appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:30.0];//表示30秒请超时
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    return request;
    
}

-(ASIHTTPRequest *)commonServiceRequestUrl:(NSString *)url serviceNameSpace:(NSString *)nameSapce serviceMethodName:(NSString *)methosName soapMessage:(NSString *)soapMsg{
    return NULL;
}
#pragma mark-
#pragma mark 同步请求


#pragma mark-
#pragma mark 异步请求
-(void)asynServiceRequestUrl:(NSString *)url serviceNameSpace:(NSString *)nameSpace serviceMethodName:(NSString *)methodName soapMessage:(NSString *)soapMsg
{
    NSLog(@"===========异步请求 post===============");
    
    NSURL *webUrl = [NSURL URLWithString:url];
    [self.httpRequest setDelegate:nil];
    //停止运行当前任务进程
    [self.httpRequest cancel];
    [self setHttpRequest:[ASIHTTPRequest requestWithURL:webUrl]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%d",(int)[soapMsg length]];
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [self.httpRequest addRequestHeader:@"Host" value:[webUrl host]];
    [self.httpRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [self.httpRequest addRequestHeader:@"Content-Length" value:msgLength];
    [self.httpRequest addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@",nameSpace,methodName]];
    
    [self.httpRequest setRequestMethod:@"POST"];
    //设置用户信息
    [self.httpRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:methodName,@"name", nil]];
    //传soap信息
    [self.httpRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [self.httpRequest setValidatesSecureCertificate:NO];
    //请求超时的时间
    [self.httpRequest setTimeOutSeconds:30.0];
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    [self.httpRequest setDelegate:self];
    //异步请求
    [self.httpRequest startAsynchronous];
    
    
}
-(void)asynServiceMethod:(NSString *)methodName soapMessage:(NSString *)soapMsg
{
    // NSLog(@"========异步通信 上传============= methodName :%@ soapMessage: %@",methodName,soapMsg);
    [self asynServiceRequestUrl:
     serviceUrl
               serviceNameSpace:@"http://hmg.org/"
              serviceMethodName:methodName
                    soapMessage:soapMsg];
}

-(void)asynServiceMethod1:(NSString *)methodName soapMessage:(NSString *)soapMsg
{
    // NSLog(@"========异步通信 上传============= methodName :%@ soapMessage: %@",methodName,soapMsg);
    [self asynServiceRequestUrl:
     serviceUrl1
               serviceNameSpace:@"http://hmg.org/"
              serviceMethodName:methodName
                    soapMessage:soapMsg];
}



#pragma mark-
#pragma mark ASIHTTPRequest delegate Methods
-(void)requestFinished:(ASIHTTPRequest*)request
{
    if (request == nil) {
        NSLog(@"=========yes");
    }
    // NSLog(@"==========异步请求结束 接受返回结果======== %@",request);
    NSData *result = [request responseData];
    
    [self.delegate finishSuccessRequest:result];
    //    [self.delegate finishSuccessRequest1:result];
    //    [self.delegate finishSuccessRequest2:result];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
   // NSLog(@"==========异步请求失败 接受返回结果========");
    NSData *error = [request responseData];
    [self.delegate finishFailedRequest:error];
}
#pragma mark-
#pragma mark 队列请求
//开始排列
-(void)resetQueue{
    if (!networkQueue) {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    [networkQueue reset];
    //表示队列操作完成
    [networkQueue setQueueDidFinishSelector:@selector(queueFetchComplete:)];
    [networkQueue setRequestDidFinishSelector:@selector(requestFetchComplete:)];
    [networkQueue setRequestDidFailSelector:@selector(requestFetchFailed:)];
    [networkQueue setDelegate:self];
}

//取消所有操作
-(void) cancelAllOperations
{
    if(networkQueue)
    [networkQueue cancelAllOperations];
}

-(void)startQueue{
    [networkQueue go];
}
//添加队列
-(void)addRequestQueue:(ASIHTTPRequest*)request{
    [networkQueue addOperation:request];
    [networkQueue setShouldCancelAllRequestsOnFailure:NO];
}

//队列请求处理
-(void)queueFetchComplete:(ASIHTTPRequest*)request{
    [self.delegate finishQueueComplete];
}

-(void)requestFetchComplete:(ASIHTTPRequest*)request{
    
    //NSString *result=[self soapMessageResult:request];
    NSData *result = [request responseData];
    @try {
        if (self.delegate) {
            [self.delegate finishSingleRequestSuccess:result userInfo:[request userInfo]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        
    }
}

-(void)requestFetchFailed:(ASIHTTPRequest*)request{
    [self.delegate finishSingleRequestFailed:[request error] userInfo:[request userInfo]];
}


@end
