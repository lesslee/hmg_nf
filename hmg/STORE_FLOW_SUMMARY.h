//
//  STORE_FLOW_SUMMARY.h
//  hmg
//
//  Created by Lee on 15/6/18.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STORE_FLOW_SUMMARY : NSObject

@property(nonatomic,strong)NSString *DEPT_ID;//部门id
@property(nonatomic,strong)NSString *DEPT_NM;//部门
@property(nonatomic,strong)NSString *QSYLX;//前三月流向金额
@property(nonatomic,strong)NSString *QLYLX;//前两月流向金额
@property(nonatomic,strong)NSString *QYYLX;//前一月流向金额

@property(nonatomic,strong)NSString *DYLX;//当月流向金额
@property(nonatomic,strong)NSString *PJLX;//平均流向金额
@property(nonatomic,strong)NSString *QUANTITY;//当月库存
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
