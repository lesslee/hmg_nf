//
//  HMG_AREA_QUERY.h
//  hmg
//
//  Created by Lee on 15/4/9.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMG_AREA_QUERY : NSObject
{
    //部门编号
    NSString *_IN_DEPT_ID;
    //员工类型
    NSString *_IN_IS_FCU;
}

@property (nonatomic,strong)NSString *IN_DEPT_ID;
@property (nonatomic,strong)NSString *IN_IS_FCU;

@end
