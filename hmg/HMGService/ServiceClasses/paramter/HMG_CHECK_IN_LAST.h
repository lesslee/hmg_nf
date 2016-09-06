//
//  HMG_CHECK_IN_LAST.h
//  hmg
//
//  Created by Hongxianyu on 16/5/25.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_CHECK_IN_LAST : NSObject
{
    //员工号
    NSString *_IN_EMP_NO;
    //经度
    NSString *_IN_GPS_LON;
    //纬度
    NSString *_IN_GPS_LAT;
    //地址
    NSString *_IN_ADDRESS;
    //错误代码
    NSString *_IN_ERROR_CODE;
    //门店或经销商的经度
    NSString *_IN_BENCHMARK_LON;
    //门店或经销商的纬度
    NSString *_IN_BENCHMARK_LAT;
    //经销商编号
    NSString *_IN_AGENT_ID;
    //门店编号
    NSString *_IN_STORE_ID;
    //距离
    NSString *_IN_DISTANCE;
    //距离描述
    NSString *_IN_DISTANCE_DESCRIPTION;
}

@property (nonatomic,strong)NSString *IN_EMP_NO;
@property (nonatomic,strong)NSString *IN_GPS_LON;
@property (nonatomic,strong)NSString *IN_GPS_LAT;
@property (nonatomic,strong)NSString *IN_AGENT_ID;
@property (nonatomic,strong)NSString *IN_STORE_ID;
@property (nonatomic,strong)NSString *IN_ADDRESS;
@property (nonatomic,strong)NSString *IN_ERROR_CODE;
@property (nonatomic,strong)NSString *IN_BENCHMARK_LON;
@property (nonatomic,strong)NSString *IN_BENCHMARK_LAT;
@property (nonatomic,strong)NSString *IN_DISTANCE;
@property (nonatomic,strong)NSString *IN_DISTANCE_DESCRIPTION;

@end

