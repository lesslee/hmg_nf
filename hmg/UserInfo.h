//
//  UserInfo.h
//  hmg
//
//  Created by Lee on 15/3/25.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *OUT_RESULT_NM;
@property(nonatomic,strong)NSString *EMP_NO;
@property(nonatomic,strong)NSString *EMP_NM;
@property(nonatomic,strong)NSString *DEPT_CD;
@property(nonatomic,strong)NSString *DEPT_NM;
@property(nonatomic,strong)NSString *EMP_TYPE;
@property(nonatomic,strong)NSString *V_MONTH;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
