//
//  STORE_INFO_SUMMARY.h
//  hmg
//
//  Created by Lee on 15/6/16.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STORE_INFO_SUMMARY : NSObject


@property(nonatomic,strong)NSString *AREA_NM;//大区
@property(nonatomic,strong)NSString *DEPT_NM;//地区
@property(nonatomic,strong)NSString *EMP_NM;//业务（负责人）
@property(nonatomic,strong)NSString *STORE_MANAGER;
@property(nonatomic,strong)NSString *STORE_COUNT;//门店数量

@property(nonatomic,strong)NSString *HZZ;//合作中
@property(nonatomic,strong)NSString *TZHZ;//停止合作
@property(nonatomic,strong)NSString *DYXZ;//当月新增

@property(nonatomic,strong)NSString *LS;//连锁
@property(nonatomic,strong)NSString *SC;//商场
@property(nonatomic,strong)NSString *BH;//百货
@property(nonatomic,strong)NSString *DD;//单店
@property(nonatomic,strong)NSString *QTQD;//其他渠道

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
