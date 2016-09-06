//
//  CP_LOGIN_LOG.h
//  hmg
//
//  Created by Hongxianyu on 16/5/26.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CP_LOGIN_LOG : NSObject
{
    //ID
    NSString *_IN_SABEON;
    //公司
    NSString *_IN_COMPANY;
    //手机id
    NSString *_IN_IMEI_CODE;
    //版本号
    NSString *_IN_VERSION;
    
}

@property (nonatomic,strong)NSString *IN_SABEON;
@property (nonatomic,strong)NSString *IN_COMPANY;
@property (nonatomic, strong)NSString *IN_IMEI_CODE;
@property(nonatomic,strong)NSString *IN_VERSION;

@end
