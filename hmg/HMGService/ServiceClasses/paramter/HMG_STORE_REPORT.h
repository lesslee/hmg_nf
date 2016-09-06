//
//  HMG_STORE_REPORT.h
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_STORE_REPORT : NSObject
{
    //大区
    NSString *_IN_AREA_ID;
    //部门
    NSString *_IN_DEPT_CD;
    //开始年月
    NSString *_IN_S_MONTH;
    //结束年月
    NSString *_IN_E_MONTH;
}

@property (nonatomic,strong)NSString *IN_AREA_ID;
@property (nonatomic,strong)NSString *IN_DEPT_CD;
@property (nonatomic,strong)NSString *IN_S_MONTH;
@property (nonatomic,strong)NSString *IN_E_MONTH;

@end
