//
//  SAVE_DAILY_REPORT.h
//  hmg
//
//  Created by Lee on 15/5/5.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAVE_DAILY_REPORT : NSObject
{
    //员工号
    NSString *_IN_EMP_NO;
    //品牌 ID
    NSString *_IN_PRODUCT_ID;
    //经销商 ID
    NSString *_IN_AGENT_ID;
    //门店 ID
    NSString *_IN_STORE_ID;
    //目的
    NSString *_IN_VISIT_PURPOSE;
    //被拜访人
    NSString *_IN_VISIT_PERSON;
    //手机
    NSString *_IN_VISIT_PERSON_TEL;
//    //固话
//    NSString *_IN_VISIT_PERSON_GH;
    //摘要
    NSString *_IN_RMK;
    //今天或昨天
    NSString *_IN_TODAY_OR_YESTODAY;
    //库存
    NSString *_IN_INVENTORY;
    //下次拜访计划安排
    NSString *_IN_VISIT_PLAN;
        //拜访时间
    NSString *_IN_VISIT_TIME;
}

@property (nonatomic,strong)NSString *IN_EMP_NO;
@property (nonatomic,strong)NSString *IN_PRODUCT_ID;
@property (nonatomic,strong)NSString *IN_AGENT_ID;
@property (nonatomic,strong)NSString *IN_STORE_ID;
@property (nonatomic,strong)NSString *IN_VISIT_PURPOSE;
@property (nonatomic,strong)NSString *IN_VISIT_PERSON;
@property (nonatomic,strong)NSString *IN_VISIT_PERSON_TEL;
@property (nonatomic,strong)NSString *IN_VISIT_PERSON_GH;
@property (nonatomic,strong)NSString *IN_RMK;
@property (nonatomic,strong)NSString *IN_TODAY_OR_YESTODAY;
@property (nonatomic,strong)NSString *IN_INVENTORY;
@property (nonatomic,strong)NSString *IN_VISIT_PLAN;
@property (nonatomic,strong)NSString *IN_VISIT_TIME;
@end
