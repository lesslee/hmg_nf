//
//  INSERT_WEEK_PROMOTION.h
//  hmg
//
//  Created by Hongxianyu on 16/4/12.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INSERT_WEEK_PROMOTION : NSObject
{
    //门店 ID
    NSString *_IN_STORE_ID;
    //产品ID
    NSString *_IN_PROD_ID;
    //数量
    NSString *_IN_QTY;
    //周末促日期
    NSString *_IN_PROM_DTM;
    //录入人
    NSString *_IN_INP_USER;
}

@property (nonatomic,strong)NSString *IN_STORE_ID;
@property (nonatomic,strong)NSString *IN_PROD_ID;
@property (nonatomic,strong)NSString *IN_QTY;
@property (nonatomic,strong)NSString *IN_PROM_DTM;
@property (nonatomic,strong)NSString *IN_INP_USER;
@end
