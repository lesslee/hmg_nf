//
//  HMG_DAILY_REPORT_QUERY.h
//  hmg
//
//  Created by Lee on 15/4/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_DAILY_REPORT_QUERY : NSObject
{
    
        //大区
    NSString *_IN_AREA_ID;
    //部门
    NSString *_IN_DEPT_ID;
    //人员
    NSString *_IN_EMP_NO;
    //开始日期
    NSString *_IN_START_DATE;
    //结束日期
    NSString *_IN_END_DATE;
    //当前页索引
    NSString *_IN_CURRENT_PAGE;
    //每页条数
    NSString *_IN_PAGE_SIZE;
    
    //
   NSString *_IN_KIND;
}

@property (nonatomic,strong)NSString *IN_AREA_ID;
@property (nonatomic,strong)NSString *IN_DEPT_ID;
@property (nonatomic,strong)NSString *IN_EMP_NO;
@property (nonatomic,strong)NSString *IN_START_DATE;
@property (nonatomic,strong)NSString *IN_END_DATE;
@property (nonatomic,strong)NSString *IN_CURRENT_PAGE;
@property (nonatomic,strong)NSString *IN_PAGE_SIZE;
@property (nonatomic,strong)NSString *IN_KIND;

@end
