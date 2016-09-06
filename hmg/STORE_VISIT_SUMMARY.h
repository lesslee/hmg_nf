//
//  STORE_VISIT_SUMMARY.h
//  hmg
//
//  Created by Lee on 15/6/18.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STORE_VISIT_SUMMARY : NSObject

@property(nonatomic,strong)NSString *AREA_NM;//大区
@property(nonatomic,strong)NSString *DEPT_NM;//地区
@property(nonatomic,strong)NSString *EMP_NM;//业务（负责人）
@property(nonatomic,strong)NSString *USER_ID;
@property(nonatomic,strong)NSString *REPORT_COUNT;//拜访次数

@property(nonatomic,strong)NSString *DYBF;//当月拜访
@property(nonatomic,strong)NSString *KF;//开发

@property(nonatomic,strong)NSString *JD;//进店

@property(nonatomic,strong)NSString *HD;//活动
@property(nonatomic,strong)NSString *PX;//培训
@property(nonatomic,strong)NSString *CLGS;//陈列改善
@property(nonatomic,strong)NSString *RC;//日常
@property(nonatomic,strong)NSString *HY;//会议

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;
@end
