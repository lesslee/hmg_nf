//
//  HMG_CUSTOMER_LOCATION.h
//  hmg
//
//  Created by Hongxianyu on 16/5/24.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_CUSTOMER_LOCATION : NSObject


@property(nonatomic, strong)NSString *IN_CUSTOMER_ID;//门店或经销商ID
@property(nonatomic, strong)NSString *IN_CUSTOMER_TYPE;//客户类型 A经销商 S门店
@property(nonatomic, strong)NSString *IN_GPS_LON;//经度
@property(nonatomic, strong)NSString *IN_GPS_LAT;//纬度
@property(nonatomic, strong)NSString *IN_FILE_NM1;//文件名
@property(nonatomic, strong)NSString *IN_FILE_NM2;//重命名后的文件名
@property(nonatomic, strong)NSString *IN_SABEON;//员工号


@end
