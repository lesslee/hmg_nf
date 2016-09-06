//
//  MonthReport.h
//  hmg
//
//  Created by hongxianyu on 2016/8/17.
//  Copyright © 2016年 com.lz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthReport : NSObject
@property(nonatomic,strong)NSString *OUT_RESULT;
@property(nonatomic,strong)NSString *STORE_ID;
@property(nonatomic,strong)NSString *STORE_NM;
@property(nonatomic,strong)NSString *MONTH;
@property(nonatomic,strong)NSString *PRODUCT_NM;
@property(nonatomic,strong)NSString *PRODUCT_ID;
@property(nonatomic,strong)NSString *INVENTORY;
@property(nonatomic,strong)NSString *SALES_QTY;
@property(nonatomic,strong)NSString *UDP_USER;
@property(nonatomic,strong)NSString *EMP_NM;
@property(nonatomic,strong)NSString *UDP_DTM;
@property(nonatomic,strong)NSString *TOTAL_RECORDS;
-(NSMutableArray *)searchNodeToArray:(id)data nodeName:(NSString *)name;

@end
