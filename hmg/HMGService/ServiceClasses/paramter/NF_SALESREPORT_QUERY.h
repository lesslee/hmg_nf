//
//  NF_SALESREPORT_QUERY.h
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NF_SALESREPORT_QUERY : NSObject
{

    NSString *_IN_MONTH;
    NSString *_IN_DEPT_CD;
    NSString *_IN_EMP_NO;
    NSString *_IN_CURRENT_PAGE;
    NSString *_IN_PAGE_SIZE;
}
@property (nonatomic,strong)NSString *IN_MONTH;
@property (nonatomic,strong)NSString *IN_DEPT_CD;
@property (nonatomic,strong)NSString *IN_EMP_NO;
@property (nonatomic,strong)NSString *IN_CURRENT_PAGE;
@property (nonatomic,strong)NSString *IN_PAGE_SIZE;


@end
