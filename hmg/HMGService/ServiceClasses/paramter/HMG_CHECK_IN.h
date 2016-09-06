//
//  HMG_CHECK_IN.h
//  hmg
//
//  Created by Lee on 15/5/12.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_CHECK_IN : NSObject
{
    //员工号
    NSString *_IN_EMP_NO;
    //精度
    NSString *_IN_GPS_LON;
    //纬度
    NSString *_IN_GPS_LAT;
    //经销商编号
    NSString *_IN_AGENT_ID;
    //门店编号
    NSString *_IN_STORE_ID;
}

@property (nonatomic,strong)NSString *IN_EMP_NO;
@property (nonatomic,strong)NSString *IN_GPS_LON;
@property (nonatomic,strong)NSString *IN_GPS_LAT;
@property (nonatomic,strong)NSString *IN_AGENT_ID;
@property (nonatomic,strong)NSString *IN_STORE_ID;

@end
