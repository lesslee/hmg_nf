//
//  ReportModel.h
//  hmg
//
//  Created by Lee on 15/4/10.
//  Copyright (c) 2015年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject

@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSString * COUNTRYANDCITY;
@property (nonatomic, retain) NSString * INP_DTM;
@property (nonatomic, retain) NSString * RMK;
@property (nonatomic, retain) NSString * DEPT_NM;
@property (nonatomic, retain) NSString * EMP_NM;
@property (nonatomic, retain) NSString * AGENT_NM;
@property (nonatomic, retain) NSString * STORE_NM;
@property (nonatomic, retain) NSString * AREA_NM;
@property (nonatomic, retain) NSString * PRODUCT_NM;
@property (nonatomic, retain) NSString * VISIT_PURPOSE;
@property (nonatomic, retain) NSString * TOTAL_RECORDS;
@property (nonatomic, retain) NSString *EMP_NO;
@property (nonatomic, retain) NSString *CUSTOMER_ID;

-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
