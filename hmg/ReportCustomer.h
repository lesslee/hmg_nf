//
//  ReportCustomer.h
//  hmg
//
//  Created by Hongxianyu on 16/3/2.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportCustomer : NSObject

@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *USER_ID;
@property(nonatomic,strong)NSString *EMP_NM;
@property(nonatomic,strong)NSString *CNT;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
