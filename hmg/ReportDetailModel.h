//
//  ReportDetailModel.h
//  hmg
//
//  Created by Lee on 15/4/14.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportDetailModel : NSObject


@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *AGENT_NM;
@property(nonatomic,strong)NSString *STORE_NM;
@property(nonatomic,strong)NSString *PRODUCT_NM;
@property(nonatomic,strong)NSString *PRODUCT_ID;
@property(nonatomic,strong)NSString *VISIT_PURPOSE;
@property(nonatomic,strong)NSString *VISIT_PERSON;
@property(nonatomic,strong)NSString *VISIT_PERSON_TEL;
@property(nonatomic,strong)NSString *VISIT_PERSON_GH;
@property(nonatomic,strong)NSString *RMK;
@property(nonatomic,strong)NSString *INVENTORY;
@property(nonatomic,strong)NSString *VISIT_PLAN;
@property(nonatomic,strong)NSString *UPLOAD_PHOTO_ID;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
